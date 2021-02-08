--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with League.Strings;

with WebIDL.Definitions;
with WebIDL.Enumerations;
with WebIDL.Interface_Members;
with WebIDL.Interfaces;

package body WebIDL.Parsers is

   function "+" (Text : Wide_Wide_String)
     return League.Strings.Universal_String
       renames League.Strings.To_Universal_String;

   -----------
   -- Parse --
   -----------

   procedure Parse
     (Self    : in out Parser'Class;
      Lexer   : in out Abstract_Lexer'Class;
      Factory : in out WebIDL.Factories.Factory'Class;
      Errors  : out League.String_Vectors.Universal_String_Vector)
   is
      pragma Unreferenced (Self);
      use all type WebIDL.Tokens.Token_Kind;

      Next : WebIDL.Tokens.Token;

      procedure Expect
        (Kind : WebIDL.Tokens.Token_Kind;
         Ok   : in out Boolean)
        with Inline;

      procedure CallbackOrInterfaceOrMixin
        (Result : out WebIDL.Definitions.Definition_Access;
         Ok     : in out Boolean);

      procedure Definition
        (Result : out WebIDL.Definitions.Definition_Access;
         Ok     : in out Boolean);

      procedure Enum
        (Result : out WebIDL.Enumerations.Enumeration_Access;
         Ok     : in out Boolean);
      procedure EnumValueList
        (Result : out League.String_Vectors.Universal_String_Vector;
         Ok     : in out Boolean);
      procedure Inheritance
        (Result : out League.Strings.Universal_String;
         Ok     : in out Boolean);
      procedure InterfaceMembers
        (Result : out WebIDL.Factories.Interface_Member_Vector_Access;
         Ok     : in out Boolean);
      procedure InterfaceMember
        (Result : out WebIDL.Interface_Members.Interface_Member_Access;
         Ok     : in out Boolean);
      procedure InterfaceOrMixin
        (Result : out WebIDL.Definitions.Definition_Access;
         Ok     : in out Boolean);
      procedure InterfaceRest
        (Result : out WebIDL.Interfaces.Interface_Access;
         Ok     : in out Boolean);

      --------------------------------
      -- CallbackOrInterfaceOrMixin --
      --------------------------------

      procedure CallbackOrInterfaceOrMixin
        (Result : out WebIDL.Definitions.Definition_Access;
         Ok     : in out Boolean) is
      begin
         case Next.Kind is
            when Callback_Token =>
               --  Expect (Callback_Token, Ok);
               raise Program_Error;
            when Interface_Token =>
               Expect (Interface_Token, Ok);
               InterfaceOrMixin (Result, Ok);
            when others =>
               Ok := False;
         end case;
      end CallbackOrInterfaceOrMixin;

      ----------------
      -- Definition --
      ----------------

      procedure Definition
        (Result : out WebIDL.Definitions.Definition_Access;
         Ok     : in out Boolean) is
      begin
         case Next.Kind is
            when Callback_Token | Interface_Token =>
               CallbackOrInterfaceOrMixin (Result, Ok);
            when Enum_Token =>
               declare
                  Node : WebIDL.Enumerations.Enumeration_Access;
               begin
                  Enum (Node, Ok);
                  Result := WebIDL.Definitions.Definition_Access (Node);
               end;
            when others =>
               Ok := False;
         end case;
      end Definition;

      ----------
      -- Enum --
      ----------

      procedure Enum
        (Result : out WebIDL.Enumerations.Enumeration_Access;
         Ok     : in out Boolean)
      is
         Name   : League.Strings.Universal_String;
         Values : League.String_Vectors.Universal_String_Vector;
      begin
         if not Ok then
            return;
         end if;

         Expect (Enum_Token, Ok);
         Expect (Identifier_Token, Ok);
         Name := Next.Text;
         Expect ('{', Ok);
         EnumValueList (Values, Ok);
         Expect ('}', Ok);
         Expect (';', Ok);

         if Ok then
            Result := Factory.Enumeration (Name, Values);
         end if;
      end Enum;

      procedure EnumValueList
        (Result : out League.String_Vectors.Universal_String_Vector;
         Ok     : in out Boolean) is
      begin
         if not Ok then
            return;
         end if;

         Expect (String_Token, Ok);
         Result.Append (Next.Text);

         while Ok and Next.Kind = ',' loop
            Expect (',', Ok);
            Expect (String_Token, Ok);
            Result.Append (Next.Text);
         end loop;
      end EnumValueList;

      ------------
      -- Expect --
      ------------

      procedure Expect
        (Kind : WebIDL.Tokens.Token_Kind;
         Ok   : in out Boolean) is
      begin
         if Ok and Next.Kind = Kind then
            Lexer.Next_Token (Next);
         elsif Ok then
            Errors.Append (+"Expecing ");
            Errors.Append (+Kind'Wide_Wide_Image);
            Ok := False;
         end if;
      end Expect;

      procedure Inheritance
        (Result : out League.Strings.Universal_String;
         Ok     : in out Boolean) is
      begin
         if Next.Kind = ':' then
            Expect (':', Ok);
            Expect (Identifier_Token, Ok);
            Result := Next.Text;
         end if;
      end Inheritance;

      ---------------------
      -- InterfaceMember --
      ---------------------

      procedure InterfaceMember
        (Result : out WebIDL.Interface_Members.Interface_Member_Access;
         Ok     : in out Boolean) is
         pragma Unreferenced (Result);
      begin
         Ok := False;
         null;
      end InterfaceMember;

      ----------------------
      -- InterfaceMembers --
      ----------------------

      procedure InterfaceMembers
        (Result : out WebIDL.Factories.Interface_Member_Vector_Access;
         Ok     : in out Boolean)
      is
      begin
         Result := Factory.Interface_Members;

         while Ok loop
            declare
               Item : WebIDL.Interface_Members.Interface_Member_Access;
            begin
               InterfaceMember (Item, Ok);

               if Ok then
                  Result.Append (Item);
               end if;
            end;
         end loop;

         Ok := True;
      end InterfaceMembers;

      ----------------------
      -- InterfaceOrMixin --
      ----------------------

      procedure InterfaceOrMixin
        (Result : out WebIDL.Definitions.Definition_Access;
         Ok     : in out Boolean) is
      begin
         if Next.Kind = Mixin_Token then
            raise Program_Error;
         else
            declare
               Value : WebIDL.Interfaces.Interface_Access;
            begin
               InterfaceRest (Value, Ok);
               Result := WebIDL.Definitions.Definition_Access (Value);
            end;
         end if;
      end InterfaceOrMixin;

      -------------------
      -- InterfaceRest --
      -------------------

      procedure InterfaceRest
        (Result : out WebIDL.Interfaces.Interface_Access;
         Ok     : in out Boolean)
      is
         Name : League.Strings.Universal_String;
         Parent : League.Strings.Universal_String;
         Members : WebIDL.Factories.Interface_Member_Vector_Access;
      begin
         if not Ok then
            return;
         end if;

         Expect (Identifier_Token, Ok);
         Name := Next.Text;
         Inheritance (Parent, Ok);
         Expect ('{', Ok);
         InterfaceMembers (Members, Ok);
         Expect ('}', Ok);
         Expect (';', Ok);

         if Ok then
            Result := Factory.New_Interface
              (Name    => Name,
               Parent  => Parent,
               Members => Members);
         end if;
      end InterfaceRest;

   begin
      Lexer.Next_Token (Next);

      loop
         declare
            Ok     : Boolean := True;
            Result : WebIDL.Definitions.Definition_Access;
         begin
            Definition (Result, Ok);

            exit when not Ok;
         end;
      end loop;

      if Next.Kind /= End_Of_Stream_Token then
         Errors.Append (+"EOF expected");
      end if;
   end Parse;

end WebIDL.Parsers;

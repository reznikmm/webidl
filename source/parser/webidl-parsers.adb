--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with League.Strings;

with WebIDL.Definitions;
with WebIDL.Enumerations;

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

      procedure Definition
        (Result : out WebIDL.Definitions.Definition_Access;
         Ok     : in out Boolean);

      procedure Enum
        (Result : out WebIDL.Enumerations.Enumeration_Access;
         Ok     : in out Boolean);
      procedure EnumValueList
        (Result : out League.String_Vectors.Universal_String_Vector;
         Ok     : in out Boolean);

      ----------------
      -- Definition --
      ----------------

      procedure Definition
        (Result : out WebIDL.Definitions.Definition_Access;
         Ok     : in out Boolean) is
      begin
         case Next.Kind is
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

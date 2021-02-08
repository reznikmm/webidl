--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with League.Strings;

with WebIDL.Arguments;
with WebIDL.Constructors;
with WebIDL.Definitions;
with WebIDL.Enumerations;
with WebIDL.Interface_Members;
with WebIDL.Interfaces;
with WebIDL.Types;

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

      procedure Argument
        (Result : out WebIDL.Arguments.Argument_Access;
         Ok     : in out Boolean);
      procedure ArgumentList
        (Result : out WebIDL.Factories.Argument_Vector_Access;
         Ok     : in out Boolean);
      procedure ArgumentName
        (Result : out League.Strings.Universal_String;
         Ok     : in out Boolean);
      procedure CallbackOrInterfaceOrMixin
        (Result : out WebIDL.Definitions.Definition_Access;
         Ok     : in out Boolean);
      procedure Constructor
        (Result : out WebIDL.Constructors.Constructor_Access;
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
      procedure DistinguishableType
        (Result : out WebIDL.Types.Type_Access;
         Ok     : in out Boolean);
      procedure SingleType
        (Result : out WebIDL.Types.Type_Access;
         Ok     : in out Boolean);
      procedure ParseType
        (Result : out WebIDL.Types.Type_Access;
         Ok     : in out Boolean);
      procedure RecordType
        (Result : out WebIDL.Types.Type_Access;
         Ok     : in out Boolean);
      procedure UnrestrictedFloatType
        (Result : out WebIDL.Types.Type_Access;
         Ok     : in out Boolean);
      procedure UnsignedIntegerType
        (Result : out WebIDL.Types.Type_Access;
         Ok     : in out Boolean);

      --------------
      -- Argument --
      --------------

      procedure Argument
        (Result : out WebIDL.Arguments.Argument_Access;
         Ok     : in out Boolean)
      is
         Name : League.Strings.Universal_String;
         Type_Def : WebIDL.Types.Type_Access;
         Opt : Boolean := False;
         Ellipsis : Boolean := False;
      begin
         if not Ok then
            return;
         elsif Next.Kind = Optional_Token then
            Opt := True;
            raise Program_Error;
         else
            ParseType (Type_Def, Ok);

            if Next.Kind = Ellipsis_Token then
               Expect (Ellipsis_Token, Ok);
               Ellipsis := True;
            end if;

            ArgumentName (Name, Ok);
         end if;

         Result := Factory.Argument
           (Type_Def     => Type_Def,
            Name         => Name,
            Is_Options   => Opt,
            Has_Ellipsis => Ellipsis);
      end Argument;

      ------------------
      -- ArgumentList --
      ------------------

      procedure ArgumentList
        (Result : out WebIDL.Factories.Argument_Vector_Access;
         Ok     : in out Boolean) is
      begin
         Result := Factory.Arguments;

         loop
            declare
               Item : WebIDL.Arguments.Argument_Access;
            begin
               Argument (Item, Ok);
               exit when not Ok;

               Result.Append (Item);

               exit when Next.Kind /= ',';

               Expect (',', Ok);
            end;
         end loop;

         Ok := True;
      end ArgumentList;

      ------------------
      -- ArgumentName --
      ------------------

      procedure ArgumentName
        (Result : out League.Strings.Universal_String;
         Ok     : in out Boolean) is
      begin
         Expect (Identifier_Token, Ok);
         Result := Next.Text;
      end ArgumentName;

      -----------------
      -- Constructor --
      -----------------

      procedure Constructor
        (Result : out WebIDL.Constructors.Constructor_Access;
         Ok     : in out Boolean)
      is
         Args : WebIDL.Factories.Argument_Vector_Access;
      begin
         if not Ok then
            return;
         end if;

         Expect (Constructor_Token, Ok);
         Expect ('(', Ok);
         ArgumentList (Args, Ok);
         Expect (')', Ok);
         Expect (';', Ok);
         Result := Factory.Constructor (Args);
      end Constructor;

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

      -------------------------
      -- DistinguishableType --
      -------------------------

      procedure DistinguishableType
        (Result : out WebIDL.Types.Type_Access;
         Ok     : in out Boolean) is
      begin
         case Next.Kind is
            when Short_Token | Long_Token | Unsigned_Token =>
               UnsignedIntegerType (Result, Ok);

            when Unrestricted_Token | Float_Token | Double_Token =>
               UnrestrictedFloatType (Result, Ok);

            when Undefined_Token =>
               Expect (Undefined_Token, Ok);
               Result := Factory.Undefined;

            when Boolean_Token =>
               Expect (Boolean_Token, Ok);
               Result := Factory.Bool;

            when Byte_Token =>
               Expect (Byte_Token, Ok);
               Result := Factory.Byte;

            when Octet_Token =>
               Expect (Octet_Token, Ok);
               Result := Factory.Octet;

            when Bigint_Token =>
               Expect (Bigint_Token, Ok);
               Result := Factory.BigInt;

            when DOMString_Token =>
               Expect (DOMString_Token, Ok);
               Result := Factory.DOMString;

            when ByteString_Token =>
               Expect (ByteString_Token, Ok);
               Result := Factory.ByteString;

            when USVString_Token =>
               Expect (USVString_Token, Ok);
               Result := Factory.USVString;

            when Sequence_Token =>
               declare
                  T : WebIDL.Types.Type_Access;
               begin
                  Expect (Sequence_Token, Ok);
                  Expect ('<', Ok);
                  ParseType (T, Ok);
                  Expect ('>', Ok);

                  if Ok then
                     Result := Factory.Sequence (T);
                  end if;
               end;

            when Object_Token =>
               Expect (Object_Token, Ok);
               Result := Factory.Object;

            when Symbol_Token =>
               Expect (Symbol_Token, Ok);
               Result := Factory.Symbol;

            when ArrayBuffer_Token |
                 DataView_Token |
                 Int8Array_Token |
                 Int16Array_Token |
                 Int32Array_Token |
                 Uint8Array_Token |
                 Uint16Array_Token |
                 Uint32Array_Token |
                 Uint8ClampedArray_Token |
                 Float32Array_Token |
                 Float64Array_Token =>

               Result := Factory.Buffer_Related_Type (Next.Text);
               Expect (Next.Kind, Ok);

            when FrozenArray_Token =>
               declare
                  T : WebIDL.Types.Type_Access;
               begin
                  Expect (FrozenArray_Token, Ok);
                  Expect ('<', Ok);
                  ParseType (T, Ok);
                  Expect ('>', Ok);

                  if Ok then
                     Result := Factory.Frozen_Array (T);
                  end if;
               end;

            when ObservableArray_Token =>
               declare
                  T : WebIDL.Types.Type_Access;
               begin
                  Expect (ObservableArray_Token, Ok);
                  Expect ('<', Ok);
                  ParseType (T, Ok);
                  Expect ('>', Ok);

                  if Ok then
                     Result := Factory.Observable_Array (T);
                  end if;
               end;

            when Record_Token =>
               RecordType (Result, Ok);

            when others =>
               raise Program_Error;
         end case;
      end DistinguishableType;

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
         case Next.Kind is
            when Constructor_Token =>
               declare
                  Item : WebIDL.Constructors.Constructor_Access;
               begin
                  Constructor (Item, Ok);
                  Result := WebIDL.Interface_Members.Interface_Member_Access
                    (Item);
               end;
            when others =>
               Ok := False;
         end case;
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

      procedure ParseType
        (Result : out WebIDL.Types.Type_Access;
         Ok     : in out Boolean)
      is
      begin
         if Next.Kind = '(' then
            raise Program_Error;  --  UnionType
         else
            SingleType (Result, Ok);
         end if;
      end ParseType;

      procedure RecordType
        (Result : out WebIDL.Types.Type_Access;
         Ok     : in out Boolean)
      is
         Key   : WebIDL.Types.Type_Access;
         Value : WebIDL.Types.Type_Access;
      begin
         Expect (Record_Token, Ok);
         Expect ('<', Ok);
         ParseType (Key, Ok);
         Expect (',', Ok);
         ParseType (Value, Ok);
         Expect ('>', Ok);

         if Ok then
            Result := Factory.Record_Type (Key, Value);
         end if;
      end RecordType;

      procedure SingleType
        (Result : out WebIDL.Types.Type_Access;
         Ok     : in out Boolean) is
      begin
         case Next.Kind is
            when Any_Token =>
               Expect (Any_Token, Ok);
               Result := Factory.Any;
            when others =>
               DistinguishableType (Result, Ok);
         end case;
      end SingleType;

      procedure UnrestrictedFloatType
        (Result : out WebIDL.Types.Type_Access;
         Ok     : in out Boolean)
      is
         Restricted : Boolean := True;
         Double     : Boolean := False;
      begin
         if Next.Kind = Unrestricted_Token then
            Expect (Unrestricted_Token, Ok);
            Restricted := False;
         end if;

         if Next.Kind = Float_Token then
            Expect (Float_Token, Ok);
         else
            Expect (Double_Token, Ok);
            Double := True;
         end if;

         if Ok then
            Result := Factory.Float (Restricted, Double);
         end if;
      end UnrestrictedFloatType;

      procedure UnsignedIntegerType
        (Result : out WebIDL.Types.Type_Access;
         Ok     : in out Boolean)
      is
         Unsigned : Boolean := False;
         Long     : Natural := 0;
      begin
         if Next.Kind = Unsigned_Token then
            Unsigned := True;
            Expect (Unsigned_Token, Ok);
         end if;

         case Next.Kind is
            when Short_Token =>
               Expect (Short_Token, Ok);
            when others =>
               Expect (Long_Token, Ok);
               Long := Boolean'Pos (Ok);

               if Ok and Next.Kind = Long_Token then
                  Expect (Long_Token, Ok);
                  Long := 2;
               end if;
         end case;

         if Ok then
            Result := Factory.Integer (Unsigned, Long);
         end if;
      end UnsignedIntegerType;

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

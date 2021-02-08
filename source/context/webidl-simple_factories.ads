--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Containers.Vectors;

with League.String_Vectors;
with League.Strings;

with WebIDL.Arguments;
with WebIDL.Constructors;
with WebIDL.Enumerations;
with WebIDL.Factories;
with WebIDL.Interface_Members;
with WebIDL.Interfaces;
with WebIDL.Types;

package WebIDL.Simple_Factories is
   pragma Preelaborate;

   type Factory is limited new WebIDL.Factories.Factory with null record;

   overriding function Enumeration
     (Self   : in out Factory;
      Name   : League.Strings.Universal_String;
      Values : League.String_Vectors.Universal_String_Vector)
        return not null WebIDL.Enumerations.Enumeration_Access;

   overriding function Interface_Members (Self : in out Factory)
     return not null WebIDL.Factories.Interface_Member_Vector_Access;

   overriding function New_Interface
     (Self    : in out Factory;
      Name    : League.Strings.Universal_String;
      Parent  : League.Strings.Universal_String;
      Members : not null WebIDL.Factories.Interface_Member_Vector_Access)
        return not null WebIDL.Interfaces.Interface_Access;

   overriding function Arguments (Self : in out Factory)
     return not null WebIDL.Factories.Argument_Vector_Access;

   overriding function Constructor
     (Self : in out Factory;
      Args : not null WebIDL.Factories.Argument_Vector_Access)
        return not null WebIDL.Constructors.Constructor_Access;

   overriding function Argument
     (Self         : in out Factory;
      Type_Def     : WebIDL.Types.Type_Access;
      Name         : League.Strings.Universal_String;
      Is_Optional  : Boolean;
      Has_Ellipsis : Boolean)
        return not null WebIDL.Arguments.Argument_Access;

   overriding function Any (Self : in out Factory)
     return not null WebIDL.Types.Type_Access;

   overriding function Object (Self : in out Factory)
     return not null WebIDL.Types.Type_Access;

   overriding function Symbol (Self : in out Factory)
     return not null WebIDL.Types.Type_Access;

   overriding function Undefined (Self : in out Factory)
     return not null WebIDL.Types.Type_Access;

   overriding function Bool (Self : in out Factory)
     return not null WebIDL.Types.Type_Access;

   overriding function Byte (Self : in out Factory)
     return not null WebIDL.Types.Type_Access;

   overriding function Octet (Self : in out Factory)
     return not null WebIDL.Types.Type_Access;

   overriding function BigInt (Self : in out Factory)
     return not null WebIDL.Types.Type_Access;

   overriding function Integer
     (Self        : in out Factory;
      Is_Unsigned : Boolean;
      Long        : Natural)
        return not null WebIDL.Types.Type_Access;

   overriding function Float
     (Self       : in out Factory;
      Restricted : Boolean;
      Double     : Boolean)
        return not null WebIDL.Types.Type_Access;

private

   package Nodes is
      type Enumeration is new WebIDL.Enumerations.Enumeration with record
         Name   : League.Strings.Universal_String;
         Values : League.String_Vectors.Universal_String_Vector;
      end record;

      type Enumeration_Access is access all Enumeration;

      overriding function Name (Self : Enumeration)
        return League.Strings.Universal_String is (Self.Name);

      overriding function Values (Self : Enumeration)
        return League.String_Vectors.Universal_String_Vector is (Self.Values);

      package Member_Vectors is new Ada.Containers.Vectors
        (Positive,
         WebIDL.Interface_Members.Interface_Member_Access,
         WebIDL.Interface_Members."=");

      type Member_Vector is limited
        new WebIDL.Factories.Interface_Member_Vector
        and WebIDL.Interface_Members.Iterators.Forward_Iterator with
      record
         Vector : Member_Vectors.Vector;
      end record;

      type Member_Vector_Access is access all Member_Vector;

      overriding function First (Self : Member_Vector)
        return WebIDL.Interface_Members.Cursor;

      overriding function Next
        (Self     : Member_Vector;
         Position : WebIDL.Interface_Members.Cursor)
           return WebIDL.Interface_Members.Cursor;

      overriding procedure Append
        (Self : in out Member_Vector;
         Item : not null WebIDL.Interface_Members.Interface_Member_Access);

      package Argument_Vectors is new Ada.Containers.Vectors
        (Positive,
         WebIDL.Arguments.Argument_Access,
         WebIDL.Arguments."=");

      type Argument_Vector is limited
        new WebIDL.Factories.Argument_Vector
        and WebIDL.Arguments.Iterators.Forward_Iterator with
      record
         Vector : Argument_Vectors.Vector;
      end record;

      type Argument_Vector_Access is access all Argument_Vector;

      overriding function First (Self : Argument_Vector)
        return WebIDL.Arguments.Cursor;

      overriding function Next
        (Self     : Argument_Vector;
         Position : WebIDL.Arguments.Cursor)
           return WebIDL.Arguments.Cursor;

      overriding procedure Append
        (Self : in out Argument_Vector;
         Item : not null WebIDL.Arguments.Argument_Access);

      type Interfase is limited new WebIDL.Interfaces.An_Interface with record
         Name    : League.Strings.Universal_String;
         Parent  : League.Strings.Universal_String;
         Members : aliased Member_Vector;
      end record;

      type Interface_Access is access all Interfase;

      overriding function Name (Self : Interfase)
        return League.Strings.Universal_String is (Self.Name);

      overriding function Members (Self : Interfase)
        return WebIDL.Interface_Members.Interface_Member_Iterator_Access;

      type Constructor is limited new WebIDL.Constructors.Constructor with
      record
         Arguments : aliased Argument_Vector;
      end record;

      type Constructor_Access is access all Constructor;

      overriding function Arguments (Self : Constructor)
        return not null WebIDL.Arguments.Argument_Iterator_Access;

      type Argument is new WebIDL.Arguments.Argument with record
         Name         : League.Strings.Universal_String;
         Type_Def     : WebIDL.Types.Type_Access;
         Is_Optional  : Boolean;
         Has_Ellipsis : Boolean;
      end record;

      type Argument_Access is access all Argument;

      overriding function Name (Self : Argument)
        return League.Strings.Universal_String is (Self.Name);

      overriding function Get_Type (Self : Argument)
        return not null WebIDL.Types.Type_Access is (Self.Type_Def);

      overriding function Is_Optional (Self : Argument) return Boolean is
        (Self.Is_Optional);

      overriding function Has_Ellipsis (Self : Argument) return Boolean is
        (Self.Has_Ellipsis);

   end Nodes;

   package Types is
      function "+" (Text : Wide_Wide_String)
        return League.Strings.Universal_String
          renames League.Strings.To_Universal_String;

      type Base is abstract limited new WebIDL.Types.Type_Definition with
        null record;

      overriding function Is_Nullable (Self : Base) return Boolean is (False);
      overriding function Is_Integer (Self : Base) return Boolean is (False);
      overriding function Is_Numeric (Self : Base) return Boolean is (False);
      overriding function Is_Primiteive (Self : Base) return Boolean
        is (False);

      type Any_Type is new Base with null record;

      overriding function Name (Self : Any_Type)
        return League.Strings.Universal_String is (+"Any");

      Any : aliased Any_Type;

      type Object_Type is new Base with null record;

      overriding function Name (Self : Object_Type)
        return League.Strings.Universal_String is (+"Object");

      Object : aliased Object_Type;

      type Symbol_Type is new Base with null record;

      overriding function Name (Self : Symbol_Type)
        return League.Strings.Universal_String is (+"Symbol");

      Symbol : aliased Symbol_Type;

      type Undefined_Type is new Base with null record;

      overriding function Name (Self : Undefined_Type)
        return League.Strings.Universal_String is (+"Undefined");

      Undefined : aliased Undefined_Type;

      type Short_Type is new Base with null record;

      overriding function Name (Self : Short_Type)
        return League.Strings.Universal_String is (+"Short");

      Short : aliased Short_Type;

      type Long_Type is new Base with null record;

      overriding function Name (Self : Long_Type)
        return League.Strings.Universal_String is (+"Long");

      Long : aliased Long_Type;

      type Long_Long_Type is new Base with null record;

      overriding function Name (Self : Long_Long_Type)
        return League.Strings.Universal_String is (+"LongLong");

      Long_Long : aliased Long_Long_Type;

      type Unsigned_Short_Type is new Base with null record;

      overriding function Name (Self : Unsigned_Short_Type)
        return League.Strings.Universal_String is (+"UnsignedShort");

      Unsigned_Short : aliased Unsigned_Short_Type;

      type Unsigned_Long_Type is new Base with null record;

      overriding function Name (Self : Unsigned_Long_Type)
        return League.Strings.Universal_String is (+"UnsignedLong");

      Unsigned_Long : aliased Unsigned_Long_Type;

      type Unsigned_Long_Long_Type is new Base with null record;

      overriding function Name (Self : Unsigned_Long_Long_Type)
        return League.Strings.Universal_String is (+"UnsignedLongLong");

      Unsigned_Long_Long : aliased Unsigned_Long_Long_Type;

      type Float_Type is new Base with null record;

      overriding function Name (Self : Float_Type)
        return League.Strings.Universal_String is (+"Float");

      Float : aliased Float_Type;

      type Double_Type is new Base with null record;

      overriding function Name (Self : Double_Type)
        return League.Strings.Universal_String is (+"Double");

      Double : aliased Double_Type;

      type Bool_Type is new Base with null record;

      overriding function Name (Self : Bool_Type)
        return League.Strings.Universal_String is (+"Boolean");

      Bool : aliased Bool_Type;

      type Byte_Type is new Base with null record;

      overriding function Name (Self : Byte_Type)
        return League.Strings.Universal_String is (+"Byte");

      Byte : aliased Byte_Type;

      type Octet_Type is new Base with null record;

      overriding function Name (Self : Octet_Type)
        return League.Strings.Universal_String is (+"Octet");

      Octet : aliased Octet_Type;

      type BigInt_Type is new Base with null record;

      overriding function Name (Self : BigInt_Type)
        return League.Strings.Universal_String is (+"BigInt");

      BigInt : aliased BigInt_Type;

   end Types;

end WebIDL.Simple_Factories;

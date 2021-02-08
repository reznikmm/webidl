--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Containers.Vectors;
with Ada.Containers.Hashed_Maps;

with League.String_Vectors;
with League.Strings;
with League.Strings.Hash;

with WebIDL.Arguments;
with WebIDL.Constructors;
with WebIDL.Enumerations;
with WebIDL.Factories;
with WebIDL.Interface_Members;
with WebIDL.Interfaces;
with WebIDL.Types;

package WebIDL.Simple_Factories is
   pragma Preelaborate;

   type Factory is limited new WebIDL.Factories.Factory with private;

private

   package Type_Maps is new Ada.Containers.Hashed_Maps
     (Key_Type        => League.Strings.Universal_String,
      Element_Type    => WebIDL.Types.Type_Access,
      Hash            => League.Strings.Hash,
      Equivalent_Keys => League.Strings."=",
      "="             => WebIDL.Types."=");

   type Factory is limited new WebIDL.Factories.Factory with record
      Sequences   : Type_Maps.Map;
      Buffers     : Type_Maps.Map;
      Arrays      : Type_Maps.Map;
      Observables : Type_Maps.Map;
      Records     : Type_Maps.Map;
      Nullables   : Type_Maps.Map;
      Promises    : Type_Maps.Map;
   end record;

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

   overriding function DOMString (Self : in out Factory)
     return not null WebIDL.Types.Type_Access;

   overriding function ByteString (Self : in out Factory)
     return not null WebIDL.Types.Type_Access;

   overriding function USVString (Self : in out Factory)
     return not null WebIDL.Types.Type_Access;

   overriding function Sequence
     (Self : in out Factory;
      T    : not null WebIDL.Types.Type_Access)
        return not null WebIDL.Types.Type_Access;

   overriding function Buffer_Related_Type
     (Self : in out Factory;
      Name : League.Strings.Universal_String)
        return not null WebIDL.Types.Type_Access;

   overriding function Frozen_Array
     (Self : in out Factory;
      T    : not null WebIDL.Types.Type_Access)
        return not null WebIDL.Types.Type_Access;

   overriding function Observable_Array
     (Self : in out Factory;
      T    : not null WebIDL.Types.Type_Access)
        return not null WebIDL.Types.Type_Access;

   overriding function Record_Type
     (Self  : in out Factory;
      Key   : not null WebIDL.Types.Type_Access;
      Value : not null WebIDL.Types.Type_Access)
        return not null WebIDL.Types.Type_Access;

   overriding function Nullable
     (Self : in out Factory;
      T    : not null WebIDL.Types.Type_Access)
        return not null WebIDL.Types.Type_Access;

   overriding function Promise
     (Self : in out Factory;
      T    : not null WebIDL.Types.Type_Access)
     return not null WebIDL.Types.Type_Access;

   overriding function Union_Members (Self : in out Factory)
     return not null WebIDL.Factories.Union_Member_Vector_Access;

   overriding function Union
     (Self : in out Factory;
      T    : not null WebIDL.Factories.Union_Member_Vector_Access)
        return not null WebIDL.Types.Type_Access;

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

      package Type_Vectors is new Ada.Containers.Vectors
        (Positive,
         WebIDL.Types.Type_Access,
         WebIDL.Types."=");

      type Union_Member_Vector is limited
        new WebIDL.Factories.Union_Member_Vector
        and WebIDL.Types.Iterators.Forward_Iterator with
      record
         Vector : Type_Vectors.Vector;
      end record;

      type Union_Member_Vector_Access is access all Union_Member_Vector;

      overriding function First (Self : Union_Member_Vector)
        return WebIDL.Types.Cursor;

      overriding function Next
        (Self     : Union_Member_Vector;
         Position : WebIDL.Types.Cursor)
           return WebIDL.Types.Cursor;

      overriding procedure Append
        (Self : in out Union_Member_Vector;
         Item : not null WebIDL.Types.Type_Access);

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
      use type League.Strings.Universal_String;

      function "+" (Text : Wide_Wide_String)
        return League.Strings.Universal_String
          renames League.Strings.To_Universal_String;

      type Base is abstract limited new WebIDL.Types.Type_Definition with
        null record;

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

      type DOMString_Type is new Base with null record;

      overriding function Name (Self : DOMString_Type)
        return League.Strings.Universal_String is (+"DOMString");

      DOMString : aliased DOMString_Type;

      type ByteString_Type is new Base with null record;

      overriding function Name (Self : ByteString_Type)
        return League.Strings.Universal_String is (+"ByteString");

      ByteString : aliased ByteString_Type;

      type USVString_Type is new Base with null record;

      overriding function Name (Self : USVString_Type)
        return League.Strings.Universal_String is (+"USVString");

      USVString : aliased USVString_Type;

      type Sequence is new Base and WebIDL.Types.Parameterized_Type with record
         Element : WebIDL.Types.Type_Access;
      end record;

      type Sequence_Access is access all Sequence;

      overriding function Name (Self : Sequence)
        return League.Strings.Universal_String is
          (Self.Element.Name & "Sequence");

      overriding function Parameter (Self : Sequence)
        return not null WebIDL.Types.Type_Access is (Self.Element);

      type Frozen_Array is new Base and WebIDL.Types.Parameterized_Type with
      record
         Element : WebIDL.Types.Type_Access;
      end record;

      type Frozen_Array_Access is access all Frozen_Array;

      overriding function Name (Self : Frozen_Array)
        return League.Strings.Universal_String is
          (Self.Element.Name & "Array");

      overriding function Parameter (Self : Frozen_Array)
        return not null WebIDL.Types.Type_Access is (Self.Element);

      type Observable_Array is new Base and WebIDL.Types.Parameterized_Type
      with record
         Element : WebIDL.Types.Type_Access;
      end record;

      type Observable_Array_Access is access all Observable_Array;

      overriding function Name (Self : Observable_Array)
        return League.Strings.Universal_String is
          (Self.Element.Name & "ObservableArray");

      overriding function Parameter (Self : Observable_Array)
        return not null WebIDL.Types.Type_Access is (Self.Element);

      type Record_Type is new Base and WebIDL.Types.Record_Type with record
         Key   : WebIDL.Types.Type_Access;
         Value : WebIDL.Types.Type_Access;
      end record;

      type Record_Type_Access is access all Record_Type;

      overriding function Name (Self : Record_Type)
        return League.Strings.Universal_String is
          (Self.Key.Name & Self.Value.Name & "Record");

      overriding function Key_Type (Self : Record_Type)
        return not null WebIDL.Types.Type_Access is (Self.Key);

      overriding function Value_Type (Self : Record_Type)
        return not null WebIDL.Types.Type_Access is (Self.Value);

      type Nullable is new Base and WebIDL.Types.Nullable
      with record
         Inner : WebIDL.Types.Type_Access;
      end record;

      type Nullable_Access is access all Nullable;

      overriding function Name (Self : Nullable)
        return League.Strings.Universal_String is
          (Self.Inner.Name & "OrNull");

      overriding function Inner_Type (Self : Nullable)
        return not null WebIDL.Types.Type_Access is (Self.Inner);

      type Promise is new Base and WebIDL.Types.Parameterized_Type with record
         Element : WebIDL.Types.Type_Access;
      end record;

      type Promise_Access is access all Promise;

      overriding function Name (Self : Promise)
        return League.Strings.Universal_String is
          (Self.Element.Name & "Promise");

      overriding function Parameter (Self : Promise)
        return not null WebIDL.Types.Type_Access is (Self.Element);

      type Buffer_Type is new Base with record
         Name : League.Strings.Universal_String;
      end record;

      type Buffer_Type_Access is access all Buffer_Type;

      overriding function Name (Self : Buffer_Type)
        return League.Strings.Universal_String is (Self.Name);

      type Union is new Base and WebIDL.Types.Union with record
         Member : aliased Nodes.Union_Member_Vector;
      end record;

      type Union_Access is access all Union;

      overriding function Name (Self : Union)
        return League.Strings.Universal_String;

      overriding function Members (Self : Union)
        return not null WebIDL.Types.Type_Iterator_Access;

   end Types;

end WebIDL.Simple_Factories;

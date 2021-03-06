--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with League.Strings;
with League.String_Vectors;

with WebIDL.Arguments;
with WebIDL.Constructors;
with WebIDL.Enumerations;
with WebIDL.Interfaces;
with WebIDL.Interface_Members;
with WebIDL.Types;

package WebIDL.Factories is
   pragma Preelaborate;

   type Factory is limited interface;
   type Factory_Access is access all Factory'Class with Storage_Size => 0;

   not overriding function Enumeration
     (Self   : in out Factory;
      Name   : League.Strings.Universal_String;
      Values : League.String_Vectors.Universal_String_Vector)
        return not null WebIDL.Enumerations.Enumeration_Access is abstract;

   type Interface_Member_Vector is limited interface;
   type Interface_Member_Vector_Access is access all
     Interface_Member_Vector'Class
       with Storage_Size => 0;

   not overriding procedure Append
     (Self : in out Interface_Member_Vector;
      Item : not null WebIDL.Interface_Members.Interface_Member_Access)
        is abstract;

   not overriding function Interface_Members (Self : in out Factory)
     return not null Interface_Member_Vector_Access is abstract;

   type Argument_Vector is limited interface;
   type Argument_Vector_Access is access all Argument_Vector'Class
     with Storage_Size => 0;

   not overriding procedure Append
     (Self : in out Argument_Vector;
      Item : not null WebIDL.Arguments.Argument_Access)
        is abstract;

   not overriding function Arguments (Self : in out Factory)
     return not null Argument_Vector_Access is abstract;

   not overriding function New_Interface
     (Self    : in out Factory;
      Name    : League.Strings.Universal_String;
      Parent  : League.Strings.Universal_String;
      Members : not null Interface_Member_Vector_Access)
        return not null WebIDL.Interfaces.Interface_Access is abstract;

   not overriding function Constructor
     (Self : in out Factory;
      Args : not null Argument_Vector_Access)
        return not null WebIDL.Constructors.Constructor_Access is abstract;

   not overriding function Argument
     (Self         : in out Factory;
      Type_Def     : WebIDL.Types.Type_Access;
      Name         : League.Strings.Universal_String;
      Is_Options   : Boolean;
      Has_Ellipsis : Boolean)
        return not null WebIDL.Arguments.Argument_Access is abstract;

   not overriding function Any (Self : in out Factory)
     return not null WebIDL.Types.Type_Access is abstract;

   not overriding function Object (Self : in out Factory)
     return not null WebIDL.Types.Type_Access is abstract;

   not overriding function Symbol (Self : in out Factory)
     return not null WebIDL.Types.Type_Access is abstract;

   not overriding function Undefined (Self : in out Factory)
     return not null WebIDL.Types.Type_Access is abstract;

   not overriding function Integer
     (Self        : in out Factory;
      Is_Unsigned : Boolean;
      Long        : Natural)
        return not null WebIDL.Types.Type_Access is abstract;

   not overriding function Float
     (Self       : in out Factory;
      Restricted : Boolean;
      Double     : Boolean)
        return not null WebIDL.Types.Type_Access is abstract;

   not overriding function Bool (Self : in out Factory)
     return not null WebIDL.Types.Type_Access is abstract;

   not overriding function Byte (Self : in out Factory)
     return not null WebIDL.Types.Type_Access is abstract;

   not overriding function Octet (Self : in out Factory)
     return not null WebIDL.Types.Type_Access is abstract;

   not overriding function BigInt (Self : in out Factory)
     return not null WebIDL.Types.Type_Access is abstract;

   not overriding function DOMString (Self : in out Factory)
     return not null WebIDL.Types.Type_Access is abstract;

   not overriding function ByteString (Self : in out Factory)
     return not null WebIDL.Types.Type_Access is abstract;

   not overriding function USVString (Self : in out Factory)
     return not null WebIDL.Types.Type_Access is abstract;

   not overriding function Sequence
     (Self : in out Factory;
      T    : not null WebIDL.Types.Type_Access)
     return not null WebIDL.Types.Type_Access is abstract;
   --  The sequence<T> type is a parameterized type whose values are (possibly
   --  zero-length) lists of values of type T.

   not overriding function Frozen_Array
     (Self : in out Factory;
      T    : not null WebIDL.Types.Type_Access)
        return not null WebIDL.Types.Type_Access is abstract;
   --  A frozen array type is a parameterized type whose values are references
   --  to objects that hold a fixed length array of unmodifiable values. The
   --  values in the array are of type T.

   not overriding function Observable_Array
     (Self : in out Factory;
      T    : not null WebIDL.Types.Type_Access)
        return not null WebIDL.Types.Type_Access is abstract;
   --  An observable array type is a parameterized type whose values are
   --  references to a combination of a mutable list of objects of type T, as
   --  well as behavior to perform when author code modifies the contents of
   --  the list.

   not overriding function Record_Type
     (Self  : in out Factory;
      Key   : not null WebIDL.Types.Type_Access;
      Value : not null WebIDL.Types.Type_Access)
        return not null WebIDL.Types.Type_Access is abstract;
   --  A record type is a parameterized type whose values are ordered maps with
   --  keys that are instances of K and values that are instances of V. K must
   --  be one of DOMString, USVString, or ByteString.

   not overriding function Nullable
     (Self : in out Factory;
      T    : not null WebIDL.Types.Type_Access)
        return not null WebIDL.Types.Type_Access is abstract;

   not overriding function Promise
     (Self : in out Factory;
      T    : not null WebIDL.Types.Type_Access)
     return not null WebIDL.Types.Type_Access is abstract;
   --  A promise type is a parameterized type whose values are references
   --  to objects that “is used as a place holder for the eventual results
   --  of a deferred (and possibly asynchronous) computation result of an
   --  asynchronous operation”.

   not overriding function Buffer_Related_Type
     (Self : in out Factory;
      Name : League.Strings.Universal_String)
        return not null WebIDL.Types.Type_Access is abstract;

   type Union_Member_Vector is limited interface;
   type Union_Member_Vector_Access is access all
     Union_Member_Vector'Class
       with Storage_Size => 0;

   not overriding procedure Append
     (Self : in out Union_Member_Vector;
      Item : not null WebIDL.Types.Type_Access)
        is abstract;

   not overriding function Union_Members (Self : in out Factory)
     return not null Union_Member_Vector_Access is abstract;

   not overriding function Union
     (Self : in out Factory;
      T    : not null Union_Member_Vector_Access)
        return not null WebIDL.Types.Type_Access is abstract;

end WebIDL.Factories;

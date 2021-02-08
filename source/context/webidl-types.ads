--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with League.Strings;

package WebIDL.Types is
   pragma Preelaborate;

   type Type_Definition is limited interface;
   type Type_Access is access all Type_Definition'Class with Storage_Size => 0;

   not overriding function Name (Self : Type_Definition)
     return League.Strings.Universal_String is abstract;

   not overriding function Is_Integer (Self : Type_Definition)
     return Boolean is abstract;

   not overriding function Is_Numeric (Self : Type_Definition)
     return Boolean is abstract;

   not overriding function Is_Primiteive (Self : Type_Definition)
     return Boolean is abstract;

   type Named_Type is limited interface and Type_Definition;

   type Parameterized_Type is limited interface and Type_Definition;

   not overriding function Parameter (Self : Parameterized_Type)
     return not null Type_Access is abstract;

   type Record_Type is limited interface and Type_Definition;
   --  A record type is a parameterized type whose values are ordered maps with
   --  keys that are instances of K and values that are instances of V. K must
   --  be one of DOMString, USVString, or ByteString.

   not overriding function Key_Type (Self : Record_Type)
     return not null Type_Access is abstract;

   not overriding function Value_Type (Self : Record_Type)
     return not null Type_Access is abstract;

   type Nullable is limited interface and Type_Definition;
   --  A nullable type is an IDL type constructed from an existing type (called
   --  the inner type), which just allows the additional value null to be a
   --  member of its set of values. Nullable types are represented in IDL by
   --  placing a U+003F QUESTION MARK ("?") character after an existing type.

   not overriding function Inner_Type (Self : Nullable)
     return not null WebIDL.Types.Type_Access is abstract;

end WebIDL.Types;

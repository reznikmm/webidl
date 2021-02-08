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

   not overriding function Is_Nullable (Self : Type_Definition)
     return Boolean is abstract;

   not overriding function Is_Integer (Self : Type_Definition)
     return Boolean is abstract;

   not overriding function Is_Numeric (Self : Type_Definition)
     return Boolean is abstract;

   not overriding function Is_Primiteive (Self : Type_Definition)
     return Boolean is abstract;

   type Named_Type is limited interface and Type_Definition;

end WebIDL.Types;

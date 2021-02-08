--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Iterator_Interfaces;

with League.Strings;

with WebIDL.Types;

package WebIDL.Arguments is
   pragma Preelaborate;

   type Argument is limited interface;

   function Assigned (Self : access Argument'Class) return Boolean is
      (Self /= null);

   type Argument_Access is access all Argument'Class
     with Storage_Size => 0;

   not overriding function Name (Self : Argument)
     return League.Strings.Universal_String is abstract;

   not overriding function Is_Optional (Self : Argument)
     return Boolean is abstract;

   not overriding function Has_Ellipsis (Self : Argument)
     return Boolean is abstract;

   not overriding function Get_Type (Self : Argument)
     return not null WebIDL.Types.Type_Access is abstract;

   type Cursor is record
      Index    : Positive;
      Argument : Argument_Access;
   end record;

   function Has_Element (Self : Cursor) return Boolean is
      (Self.Argument.Assigned);

   package Iterators is new Ada.Iterator_Interfaces (Cursor, Has_Element);

   type Argument_Iterator_Access is access constant
     Iterators.Forward_Iterator'Class
       with Storage_Size => 0;

end WebIDL.Arguments;

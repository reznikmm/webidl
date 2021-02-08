--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with League.Strings;

package WebIDL.Arguments is
   pragma Preelaborate;

   type Argument is limited interface;

   type Argument_Access is access all Argument'Class
     with Storage_Size => 0;

   not overriding function Name (Self : Argument)
     return League.Strings.Universal_String is abstract;

   not overriding function Is_Optional (Self : Argument)
     return Boolean is abstract;

   not overriding function Has_Ellipsis (Self : Argument)
     return Boolean is abstract;

end WebIDL.Arguments;

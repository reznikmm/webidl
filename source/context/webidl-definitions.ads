--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with League.Strings;

package WebIDL.Definitions is
   pragma Preelaborate;

   type Definition is limited interface;

   not overriding function Name (Self : Definition)
     return League.Strings.Universal_String is abstract;

   type Definition_Access is access all Definition'Class
     with Storage_Size => 0;

end WebIDL.Definitions;

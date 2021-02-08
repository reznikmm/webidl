--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with WebIDL.Definitions;
with WebIDL.Interface_Members;

package WebIDL.Interfaces is
   pragma Preelaborate;

   type An_Interface is limited interface and WebIDL.Definitions.Definition;

   type Interface_Access is access all An_Interface'Class
     with Storage_Size => 0;

   not overriding function Members (Self : An_Interface)
     return WebIDL.Interface_Members.Interface_Member_Iterator_Access
       is abstract;

end WebIDL.Interfaces;

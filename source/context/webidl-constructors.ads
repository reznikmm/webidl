--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with WebIDL.Interface_Members;

package WebIDL.Constructors is
   pragma Preelaborate;

   type Constructor is limited interface
     and WebIDL.Interface_Members.Interface_Member;

   type Constructor_Access is access all Constructor'Class
     with Storage_Size => 0;

end WebIDL.Constructors;

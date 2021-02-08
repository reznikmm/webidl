--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Iterator_Interfaces;

package WebIDL.Interface_Members is
   pragma Preelaborate;

   type Interface_Member is limited interface;
   --  Interfaces, interface mixins, and namespaces are specifications of a set
   --  of members (respectively matching InterfaceMembers, MixinMembers, and
   --  NamespaceMembers), which are the constants, attributes, operations, and
   --  other declarations that appear between the braces of their declarations.

   function Assigned (Self : access Interface_Member'Class) return Boolean is
      (Self /= null);

   type Interface_Member_Access is access all Interface_Member'Class
     with Storage_Size => 0;

   type Cursor is record
      Index  : Positive;
      Member : Interface_Member_Access;
   end record;

   function Has_Element (Self : Cursor) return Boolean is
      (Self.Member.Assigned);

   package Iterators is new Ada.Iterator_Interfaces (Cursor, Has_Element);

   type Interface_Member_Iterator_Access is access constant
     Iterators.Forward_Iterator'Class
       with Storage_Size => 0;

end WebIDL.Interface_Members;

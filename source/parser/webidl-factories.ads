--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with League.Strings;
with League.String_Vectors;

with WebIDL.Enumerations;
with WebIDL.Interfaces;
with WebIDL.Interface_Members;

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

   not overriding function New_Interface
     (Self    : in out Factory;
      Name    : League.Strings.Universal_String;
      Parent  : League.Strings.Universal_String;
      Members : not null Interface_Member_Vector_Access)
        return not null WebIDL.Interfaces.Interface_Access is abstract;

end WebIDL.Factories;

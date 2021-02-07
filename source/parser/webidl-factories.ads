--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with League.Strings;
with League.String_Vectors;

with WebIDL.Enumerations;

package WebIDL.Factories is
   pragma Preelaborate;

   type Factory is limited interface;
   type Factory_Access is access all Factory'Class with Storage_Size => 0;

   not overriding function Enumeration
     (Self   : in out Factory;
      Name   : League.Strings.Universal_String;
      Values : League.String_Vectors.Universal_String_Vector)
        return not null WebIDL.Enumerations.Enumeration_Access is abstract;

end WebIDL.Factories;

--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

package body WebIDL.Simple_Factories is

   -----------------
   -- Enumeration --
   -----------------

   overriding function Enumeration
     (Self   : in out Factory; Name : League.Strings.Universal_String;
      Values : League.String_Vectors.Universal_String_Vector)
      return not null WebIDL.Enumerations.Enumeration_Access
   is
      Result : constant Nodes.Enumeration_Access := new Nodes.Enumeration'
        (Name, Values);
   begin
      return WebIDL.Enumerations.Enumeration_Access (Result);
   end Enumeration;

end WebIDL.Simple_Factories;

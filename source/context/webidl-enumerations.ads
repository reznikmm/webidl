--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with League.String_Vectors;

with WebIDL.Definitions;

package WebIDL.Enumerations is
   pragma Preelaborate;

   type Enumeration is limited interface and WebIDL.Definitions.Definition;
   --  An enumeration is a definition used to declare a type whose valid values
   --  are a set of predefined strings.

   type Enumeration_Access is access all Enumeration'Class
     with Storage_Size => 0;

   not overriding function Values (Self : Enumeration)
     return League.String_Vectors.Universal_String_Vector is abstract;
   --  The enumeration values are specified as a comma-separated list of string
   --  literals. The list of enumeration values must not include duplicates.

end WebIDL.Enumerations;

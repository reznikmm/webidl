--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with League.String_Vectors;
with League.Strings;

with WebIDL.Enumerations;
with WebIDL.Factories;

package WebIDL.Simple_Factories is
   pragma Preelaborate;

   type Factory is limited new WebIDL.Factories.Factory with null record;

   overriding function Enumeration
     (Self   : in out Factory;
      Name   : League.Strings.Universal_String;
      Values : League.String_Vectors.Universal_String_Vector)
        return not null WebIDL.Enumerations.Enumeration_Access;

private

   package Nodes is
      type Enumeration is new WebIDL.Enumerations.Enumeration with record
         Name   : League.Strings.Universal_String;
         Values : League.String_Vectors.Universal_String_Vector;
      end record;

      type Enumeration_Access is access all Enumeration;

      overriding function Name (Self : Enumeration)
        return League.Strings.Universal_String is (Self.Name);

      overriding function Values (Self : Enumeration)
        return League.String_Vectors.Universal_String_Vector is (Self.Values);
   end Nodes;
end WebIDL.Simple_Factories;

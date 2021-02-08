--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Containers.Vectors;

with League.String_Vectors;
with League.Strings;

with WebIDL.Enumerations;
with WebIDL.Factories;
with WebIDL.Interface_Members;
with WebIDL.Interfaces;

package WebIDL.Simple_Factories is
   pragma Preelaborate;

   type Factory is limited new WebIDL.Factories.Factory with null record;

   overriding function Enumeration
     (Self   : in out Factory;
      Name   : League.Strings.Universal_String;
      Values : League.String_Vectors.Universal_String_Vector)
        return not null WebIDL.Enumerations.Enumeration_Access;

   overriding function Interface_Members (Self : in out Factory)
     return not null WebIDL.Factories.Interface_Member_Vector_Access;

   overriding function New_Interface
     (Self    : in out Factory;
      Name    : League.Strings.Universal_String;
      Parent  : League.Strings.Universal_String;
      Members : not null WebIDL.Factories.Interface_Member_Vector_Access)
        return not null WebIDL.Interfaces.Interface_Access;

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

      package Member_Vectors is new Ada.Containers.Vectors
        (Positive,
         WebIDL.Interface_Members.Interface_Member_Access,
         WebIDL.Interface_Members."=");

      type Member_Vector is limited
        new WebIDL.Factories.Interface_Member_Vector
        and WebIDL.Interface_Members.Iterators.Forward_Iterator with
      record
         Vector : Member_Vectors.Vector;
      end record;

      type Member_Vector_Access is access all Member_Vector;

      overriding function First (Self : Member_Vector)
        return WebIDL.Interface_Members.Cursor;

      overriding function Next
        (Self     : Member_Vector;
         Position : WebIDL.Interface_Members.Cursor)
           return WebIDL.Interface_Members.Cursor;

      overriding procedure Append
        (Self : in out Member_Vector;
         Item : not null WebIDL.Interface_Members.Interface_Member_Access);

      type Interfase is limited new WebIDL.Interfaces.An_Interface with record
         Name    : League.Strings.Universal_String;
         Parent  : League.Strings.Universal_String;
         Members : aliased Member_Vector;
      end record;

      type Interface_Access is access all Interfase;

      overriding function Name (Self : Interfase)
        return League.Strings.Universal_String is (Self.Name);

      overriding function Members (Self : Interfase)
        return WebIDL.Interface_Members.Interface_Member_Iterator_Access;
   end Nodes;

end WebIDL.Simple_Factories;

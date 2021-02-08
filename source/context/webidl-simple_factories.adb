--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

package body WebIDL.Simple_Factories is

   package body Nodes is

      overriding function First (Self : Member_Vector)
        return WebIDL.Interface_Members.Cursor is
      begin
         if Self.Vector.Is_Empty then
            return (1, null);
         else
            return (1, Self.Vector.First_Element);
         end if;
      end First;

      overriding function Next
        (Self     : Member_Vector;
         Position : WebIDL.Interface_Members.Cursor)
           return WebIDL.Interface_Members.Cursor is
      begin
         if Position.Index >= Self.Vector.Last_Index then
            return (Self.Vector.Last_Index + 1, null);
         else
            return (Position.Index + 1, Self.Vector (Position.Index + 1));
         end if;
      end Next;

      overriding procedure Append
        (Self : in out Member_Vector;
         Item : not null WebIDL.Interface_Members.Interface_Member_Access) is
      begin
         Self.Vector.Append (Item);
      end Append;

      type Member_Vector_C_Access is access constant Member_Vector;

      overriding function Members (Self : Interfase)
        return WebIDL.Interface_Members.Interface_Member_Iterator_Access
      is
         X : constant Member_Vector_C_Access := Self.Members'Unchecked_Access;
      begin
         return WebIDL.Interface_Members.Interface_Member_Iterator_Access (X);
      end Members;

   end Nodes;

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

   -----------------------
   -- Interface_Members --
   -----------------------

   overriding function Interface_Members (Self : in out Factory)
     return not null WebIDL.Factories.Interface_Member_Vector_Access
   is
      Result : constant Nodes.Member_Vector_Access := new Nodes.Member_Vector;
   begin
      return WebIDL.Factories.Interface_Member_Vector_Access (Result);
   end Interface_Members;

   -------------------
   -- New_Interface --
   -------------------

   overriding function New_Interface
     (Self    : in out Factory;
      Name    : League.Strings.Universal_String;
      Parent  : League.Strings.Universal_String;
      Members : not null WebIDL.Factories.Interface_Member_Vector_Access)
        return not null WebIDL.Interfaces.Interface_Access
   is
      Result : constant Nodes.Interface_Access := new Nodes.Interfase'
        (Name, Parent, Members => <>);
   begin
      Result.Members.Vector := Nodes.Member_Vector (Members.all).Vector;

      return WebIDL.Interfaces.Interface_Access (Result);
   end New_Interface;

end WebIDL.Simple_Factories;

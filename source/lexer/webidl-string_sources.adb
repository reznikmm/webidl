--  SPDX-FileCopyrightText: 2010-2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Characters.Wide_Wide_Latin_1;

package body WebIDL.String_Sources is

   --------------
   -- Get_Next --
   --------------

   overriding function Get_Next
     (Self : not null access String_Source)
      return WebIDL.Abstract_Sources.Code_Unit_32
   is
   begin
      if Self.Cursor.Has_Element then
         return Result : WebIDL.Abstract_Sources.Code_Unit_32 do
            Result := Wide_Wide_Character'Pos
              (Self.Cursor.Element);
            Self.Cursor.Next;
         end return;
      elsif Self.Index < Self.Vector.Length then
         Self.Index := Self.Index + 1;
         Self.Line := Self.Vector (Self.Index);
         Self.Cursor.First (Self.Line);

         return Wide_Wide_Character'Pos (Ada.Characters.Wide_Wide_Latin_1.LF);
      elsif Self.Index = Self.Vector.Length then
         Self.Index := Self.Index + 1;

         return Wide_Wide_Character'Pos (Ada.Characters.Wide_Wide_Latin_1.LF);
      else
         return WebIDL.Abstract_Sources.End_Of_Input;
      end if;
   end Get_Next;

   -----------------------
   -- Set_String_Vector --
   -----------------------

   procedure Set_String_Vector
     (Self  : out String_Source;
      Value : League.String_Vectors.Universal_String_Vector) is
   begin
      Self.Vector := Value;
      Self.Index := 1;
      Self.Line := Value (Self.Index);
      Self.Cursor.First (Self.Line);
   end Set_String_Vector;

end WebIDL.String_Sources;

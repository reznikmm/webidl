--  SPDX-FileCopyrightText: 2010-2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with WebIDL.Abstract_Sources;
with League.Strings;
with League.String_Vectors;
with League.Strings.Cursors.Characters;

package WebIDL.String_Sources is
   pragma Preelaborate;

   type String_Source is new WebIDL.Abstract_Sources.Abstract_Source
     with private;

   overriding function Get_Next
     (Self : not null access String_Source)
     return WebIDL.Abstract_Sources.Code_Unit_32;

   procedure Set_String_Vector
     (Self  : out String_Source;
      Value : League.String_Vectors.Universal_String_Vector);

private

   type String_Source is new WebIDL.Abstract_Sources.Abstract_Source with
   record
      Vector : League.String_Vectors.Universal_String_Vector;
      Index  : Positive;
      Line   : League.Strings.Universal_String;
      Cursor : League.Strings.Cursors.Characters.Character_Cursor;
   end record;

end WebIDL.String_Sources;

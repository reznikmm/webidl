--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Wide_Wide_Text_IO;

with League.String_Vectors;
with League.Strings;

with WebIDL.Scanners;
with WebIDL.String_Sources;
with WebIDL.Tokens;

procedure WebIDL.Run is
   Vector  : League.String_Vectors.Universal_String_Vector;
   Source  : aliased WebIDL.String_Sources.String_Source;
   Scanner : aliased WebIDL.Scanners.Scanner;
begin
   while not Ada.Wide_Wide_Text_IO.End_Of_File loop
      declare
         Line : constant Wide_Wide_String := Ada.Wide_Wide_Text_IO.Get_Line;
      begin
         Vector.Append (League.Strings.To_Universal_String (Line));
      end;
   end loop;

   Source.Set_String_Vector (Vector);
   Scanner.Set_Source (Source'Unchecked_Access);

   loop
      declare
         use all type WebIDL.Tokens.Token_Kind;
         Token : WebIDL.Tokens.Token;
      begin
         Scanner.Get_Token (Token);

         exit when Token.Kind = End_Of_Stream_Token;
      end;
   end loop;
end WebIDL.Run;

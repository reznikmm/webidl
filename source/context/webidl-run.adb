--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Wide_Wide_Text_IO;

with League.String_Vectors;
with League.Strings;

with WebIDL.Lexers;
with WebIDL.Parsers;
with WebIDL.Simple_Factories;

procedure WebIDL.Run is
   Vector  : League.String_Vectors.Universal_String_Vector;
   Lexer   : aliased WebIDL.Lexers.Lexer;
   Parser  : WebIDL.Parsers.Parser;
   Factory : WebIDL.Simple_Factories.Factory;
   Errors  : League.String_Vectors.Universal_String_Vector;
begin
   while not Ada.Wide_Wide_Text_IO.End_Of_File loop
      declare
         Line : constant Wide_Wide_String := Ada.Wide_Wide_Text_IO.Get_Line;
      begin
         Vector.Append (League.Strings.To_Universal_String (Line));
      end;
   end loop;

   Lexer.Initialize (Vector);
   WebIDL.Parsers.Parse (Parser, Lexer, Factory, Errors);

   for J in 1 .. Errors.Length loop
      Ada.Wide_Wide_Text_IO.Put_Line (Errors (J).To_Wide_Wide_String);
   end loop;
end WebIDL.Run;

--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with WebIDL.Scanners;
with WebIDL.Tokens;

procedure WebIDL.Run is
   Scanner : aliased WebIDL.Scanners.Scanner;
begin
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

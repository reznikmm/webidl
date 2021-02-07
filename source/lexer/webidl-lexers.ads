--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with League.String_Vectors;

with WebIDL.Parsers;
with WebIDL.Scanners;
with WebIDL.String_Sources;
with WebIDL.Token_Handlers;
with WebIDL.Tokens;

package WebIDL.Lexers is
   pragma Preelaborate;

   type Lexer is limited new WebIDL.Parsers.Abstract_Lexer with private;

   procedure Initialize
     (Self : in out Lexer'Class;
      Text : League.String_Vectors.Universal_String_Vector);

private

   type Lexer is limited new WebIDL.Parsers.Abstract_Lexer with record
      Vector  : League.String_Vectors.Universal_String_Vector;
      Source  : aliased WebIDL.String_Sources.String_Source;
      Scanner : aliased WebIDL.Scanners.Scanner;
      Handler : aliased WebIDL.Token_Handlers.Handler;
   end record;

   overriding procedure Next_Token
     (Self  : in out Lexer;
      Value : out WebIDL.Tokens.Token);

end WebIDL.Lexers;

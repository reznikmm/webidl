--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with WebIDL.Factories;
with WebIDL.Tokens;
with League.String_Vectors;

package WebIDL.Parsers is
   pragma Preelaborate;

   type Abstract_Lexer is limited interface;

   not overriding procedure Next_Token
     (Self  : in out Abstract_Lexer;
      Value : out WebIDL.Tokens.Token) is abstract;

   type Parser is tagged limited private;

   procedure Parse
     (Self    : in out Parser'Class;
      Lexer   : in out Abstract_Lexer'Class;
      Factory : in out WebIDL.Factories.Factory'Class;
      Errors  : out League.String_Vectors.Universal_String_Vector);

private

   type Parser is tagged limited null record;

end WebIDL.Parsers;

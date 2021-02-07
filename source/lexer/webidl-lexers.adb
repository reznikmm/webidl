--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

package body WebIDL.Lexers is

   procedure Initialize
     (Self : in out Lexer'Class;
      Text : League.String_Vectors.Universal_String_Vector) is
   begin
      Self.Handler.Initialize;
      Self.Source.Set_String_Vector (Text);
      Self.Scanner.Set_Source (Self.Source'Unchecked_Access);
      Self.Scanner.Set_Handler (Self.Handler'Unchecked_Access);
   end Initialize;

   ----------------
   -- Next_Token --
   ----------------

   overriding procedure Next_Token
     (Self  : in out Lexer;
      Value : out WebIDL.Tokens.Token)
   is
   begin
      Self.Scanner.Get_Token (Value);
   end Next_Token;

end WebIDL.Lexers;

--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Wide_Wide_Text_IO;

package body WebIDL.Token_Handlers is

   -------------
   -- Integer --
   -------------

   overriding procedure Integer
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean)
   is
      pragma Unreferenced (Skip);
   begin
      Token := WebIDL.Tokens.Integer_Token;
      Ada.Wide_Wide_Text_IO.Put_Line ("integer");
   end Integer;

end WebIDL.Token_Handlers;

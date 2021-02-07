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
   begin
      Token := WebIDL.Tokens.Integer_Token;
      Skip := False;
      Ada.Wide_Wide_Text_IO.Put_Line ("integer");
   end Integer;

   overriding procedure Decimal
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean)
   is
      pragma Unreferenced (Skip);
   begin
      Token := WebIDL.Tokens.Decimal_Token;
      Skip := False;
      Ada.Wide_Wide_Text_IO.Put_Line ("decimal");
   end Decimal;

   overriding procedure Identifier
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean)
   is
      pragma Unreferenced (Skip);
   begin
      Token := WebIDL.Tokens.Identifier_Token;
      Skip := False;
      Ada.Wide_Wide_Text_IO.Put_Line ("identifier");
   end Identifier;

   overriding procedure String
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean)
   is
      pragma Unreferenced (Skip);
   begin
      Token := WebIDL.Tokens.String_Token;
      Skip := False;
      Ada.Wide_Wide_Text_IO.Put_Line ("string");
   end String;

   overriding procedure Whitespace
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean)
   is
      pragma Unreferenced (Token);
   begin
      Skip := True;
   end Whitespace;

   overriding procedure Line_Comment
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean)
   is
      pragma Unreferenced (Token);
   begin
      Skip := True;
   end Line_Comment;

   overriding procedure Comment_Start
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean)
   is
      pragma Unreferenced (Token);
   begin
      Scanner.Set_Start_Condition (WebIDL.Scanner_Types.In_Comment);
      Skip := True;
   end Comment_Start;

   overriding procedure Comment_End
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean)
   is
      pragma Unreferenced (Token);
   begin
      Scanner.Set_Start_Condition (WebIDL.Scanner_Types.INITIAL);
      Skip := True;
   end Comment_End;

   overriding procedure Comment_Text
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean)
   is
      pragma Unreferenced (Token);
   begin
      Skip := True;
   end Comment_Text;

end WebIDL.Token_Handlers;

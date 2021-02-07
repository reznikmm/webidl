--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with League.Strings.Hash;
with Ada.Containers.Hashed_Maps;

with WebIDL.Scanner_Handlers;
with WebIDL.Scanners;
with WebIDL.Scanner_Types;
with WebIDL.Tokens;

package WebIDL.Token_Handlers is
   pragma Preelaborate;

   type Handler is limited new WebIDL.Scanner_Handlers.Handler with private;

   procedure Initialize (Self : in out Handler'Class);

   overriding procedure Delimiter
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean);

   overriding procedure Ellipsis
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean);

   overriding procedure Integer
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean);

   overriding procedure Decimal
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean);

   overriding procedure Identifier
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean);

   overriding procedure String
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean);

   overriding procedure Whitespace
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean);

   overriding procedure Line_Comment
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean);

   overriding procedure Comment_Start
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean);

   overriding procedure Comment_End
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean);

   overriding procedure Comment_Text
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean);

private

   package Keyword_Maps is new Ada.Containers.Hashed_Maps
     (Key_Type        => League.Strings.Universal_String,
      Element_Type    => WebIDL.Tokens.Token_Kind,
      Hash            => League.Strings.Hash,
      Equivalent_Keys => League.Strings."=",
      "="             => WebIDL.Tokens."=");

   type Handler is limited new WebIDL.Scanner_Handlers.Handler with record
      Map : Keyword_Maps.Map;
   end record;

end WebIDL.Token_Handlers;

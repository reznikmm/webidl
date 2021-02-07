--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with WebIDL.Scanner_Handlers;
with WebIDL.Scanners;
with WebIDL.Scanner_Types;
with WebIDL.Tokens;

package WebIDL.Token_Handlers is

   type Handler is new WebIDL.Scanner_Handlers.Handler with null record;

   overriding procedure Integer
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean);

end WebIDL.Token_Handlers;

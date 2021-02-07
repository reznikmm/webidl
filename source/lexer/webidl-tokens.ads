--  SPDX-FileCopyrightText: 2010-2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

package WebIDL.Tokens is
   pragma Preelaborate;

   type Token_Kind is
     (Integer_Token,
      Decimal_Token,
      Identifier_Token,
      String_Token,
      End_Of_Stream_Token,
      Error_Token);
   type Token (Kind : Token_Kind := End_Of_Stream_Token) is null record;

end WebIDL.Tokens;

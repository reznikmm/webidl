--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with League.String_Vectors;

package WebIDL.Contexts is
   pragma Preelaborate;

   type Context is tagged limited private;

private

   type Context is tagged limited record
      null;
   end record;

end WebIDL.Contexts;

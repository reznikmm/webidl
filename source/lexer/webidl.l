--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------
--  This is a lexer input file for the
--  [uaflex](https://forge.ada-ru.org/matreshka/wiki/uaflex)

%x In_Comment

%%

\-?([1-9][0-9]*|0[Xx][0-9A-Fa-f]+|0[0-7]*) {Integer}
\-?(([0-9]+\.[0-9]*|[0-9]*\.[0-9]+)([Ee][\+\-]?[0-9]+)?|[0-9]+[Ee][\+\-]?[0-9]+) {Decimal}
[_\-]?[A-Za-z][0-9A-Z_a-z\-]* {Identifier}
\"[^\"]*\"                    {String}
[\t\n\r ]+                    {Whitespace}
\/\/[^\n]*\n                  {Line_Comment}
\/\*                          {Comment_Start}
<In_Comment>\*\/              {Comment_End}
<In_Comment>.                 {Comment_Text}

%%

separate (WebIDL.Scanners)
procedure On_Accept
  (Self    : not null access WebIDL.Scanner_Handlers.Handler'Class;
   Scanner : not null access WebIDL.Scanners.Scanner'Class;
   Rule    : WebIDL.Scanner_Types.Rule_Index;
   Token   : out WebIDL.Tokens.Token_Kind;
   Skip    : in out Boolean) is
begin
   case Rule is
      when 1 =>
         Self.Integer (Scanner, Rule, Token, Skip);

      when 2 =>
         Self.Decimal (Scanner, Rule, Token, Skip);

      when 3 =>
         Self.Identifier (Scanner, Rule, Token, Skip);

      when 4 =>
         Self.String (Scanner, Rule, Token, Skip);

      when 5 =>
         Self.Whitespace (Scanner, Rule, Token, Skip);

      when 6 =>
         Self.Line_Comment (Scanner, Rule, Token, Skip);

      when 7 =>
         Self.Comment_Start (Scanner, Rule, Token, Skip);

      when 8 =>
         Self.Comment_End (Scanner, Rule, Token, Skip);

      when 9 =>
         Self.Comment_Text (Scanner, Rule, Token, Skip);

      when others =>
         raise Constraint_Error;
   end case;
end On_Accept;

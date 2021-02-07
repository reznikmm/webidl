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

      when others =>
         raise Constraint_Error;
   end case;
end On_Accept;

limited with WebIDL.Scanners;
with WebIDL.Tokens;
with WebIDL.Scanner_Types;

package WebIDL.Scanner_Handlers is
   pragma Preelaborate;

   type Handler is abstract tagged limited null record;

   procedure Integer
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean) is abstract;

   type Handler_Access is access all Handler'Class;

end WebIDL.Scanner_Handlers;

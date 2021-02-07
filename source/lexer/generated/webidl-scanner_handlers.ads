limited with WebIDL.Scanners;
with WebIDL.Tokens;
with WebIDL.Scanner_Types;

package WebIDL.Scanner_Handlers is
   pragma Preelaborate;

   type Handler is abstract tagged limited null record;

   procedure Delimiter
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean) is abstract;

   procedure Ellipsis
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean) is abstract;

   procedure Integer
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean) is abstract;

   procedure Decimal
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean) is abstract;

   procedure Identifier
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean) is abstract;

   procedure String
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean) is abstract;

   procedure Whitespace
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean) is abstract;

   procedure Line_Comment
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean) is abstract;

   procedure Comment_Start
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean) is abstract;

   procedure Comment_End
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean) is abstract;

   procedure Comment_Text
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean) is abstract;

   type Handler_Access is access all Handler'Class;

end WebIDL.Scanner_Handlers;

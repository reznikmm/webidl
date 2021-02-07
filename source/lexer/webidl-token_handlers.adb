--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with League.Strings;

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
   end Decimal;

   overriding procedure Delimiter
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean)
   is
      Text : constant League.Strings.Universal_String := Scanner.Get_Text;
   begin
      case Text (1).To_Wide_Wide_Character is
         when '(' =>
            Token := '(';
         when ')' =>
            Token := ')';
         when ',' =>
            Token := ',';
         when '-' =>
            Token := '-';
         when '.' =>
            Token := '.';
         when ':' =>
            Token := ':';
         when ';' =>
            Token := ';';
         when '<' =>
            Token := '<';
         when '=' =>
            Token := '=';
         when '>' =>
            Token := '>';
         when '?' =>
            Token := '?';
         when '[' =>
            Token := '[';
         when ']' =>
            Token := ']';
         when '{' =>
            Token := '{';
         when '}' =>
            Token := '}';
         when others =>
            raise Program_Error;
      end case;

      Skip := False;
   end Delimiter;

   overriding procedure Ellipsis
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean)
   is
      pragma Unreferenced (Skip);
   begin
      Token := WebIDL.Tokens.Ellipsis_Token;
      Skip := False;
   end Ellipsis;

   overriding procedure Identifier
     (Self    : not null access Handler;
      Scanner : not null access WebIDL.Scanners.Scanner'Class;
      Rule    : WebIDL.Scanner_Types.Rule_Index;
      Token   : out WebIDL.Tokens.Token_Kind;
      Skip    : in out Boolean)
   is
      pragma Unreferenced (Skip);

      Text  : constant League.Strings.Universal_String := Scanner.Get_Text;
      Found : constant Keyword_Maps.Cursor := Self.Map.Find (Text);
   begin
      if Keyword_Maps.Has_Element (Found) then
         Token := Keyword_Maps.Element (Found);
      else
         Token := WebIDL.Tokens.Identifier_Token;
      end if;

      Skip := False;
   end Identifier;

   procedure Initialize (Self : in out Handler'Class) is
      use all type WebIDL.Tokens.Token_Kind;

      function "+" (Text : Wide_Wide_String)
        return League.Strings.Universal_String
          renames League.Strings.To_Universal_String;

      Map : Keyword_Maps.Map renames Self.Map;
   begin
      Map.Insert (+"any", Any_Token);
      Map.Insert (+"async", Async_Token);
      Map.Insert (+"attribute", Attribute_Token);
      Map.Insert (+"bigint", Bigint_Token);
      Map.Insert (+"boolean", Boolean_Token);
      Map.Insert (+"byte", Byte_Token);
      Map.Insert (+"callback", Callback_Token);
      Map.Insert (+"const", Const_Token);
      Map.Insert (+"constructor", Constructor_Token);
      Map.Insert (+"deleter", Deleter_Token);
      Map.Insert (+"dictionary", Dictionary_Token);
      Map.Insert (+"double", Double_Token);
      Map.Insert (+"enum", Enum_Token);
      Map.Insert (+"false", False_Token);
      Map.Insert (+"float", Float_Token);
      Map.Insert (+"getter", Getter_Token);
      Map.Insert (+"includes", Includes_Token);
      Map.Insert (+"inherit", Inherit_Token);
      Map.Insert (+"interface", Interface_Token);
      Map.Insert (+"iterable", Iterable_Token);
      Map.Insert (+"long", Long_Token);
      Map.Insert (+"maplike", Maplike_Token);
      Map.Insert (+"mixin", Mixin_Token);
      Map.Insert (+"namespace", Namespace_Token);
      Map.Insert (+"null", Null_Token);
      Map.Insert (+"object", Object_Token);
      Map.Insert (+"octet", Octet_Token);
      Map.Insert (+"optional", Optional_Token);
      Map.Insert (+"or", Or_Token);
      Map.Insert (+"other", Other_Token);
      Map.Insert (+"partial", Partial_Token);
      Map.Insert (+"readonly", Readonly_Token);
      Map.Insert (+"record", Record_Token);
      Map.Insert (+"required", Required_Token);
      Map.Insert (+"sequence", Sequence_Token);
      Map.Insert (+"setlike", Setlike_Token);
      Map.Insert (+"setter", Setter_Token);
      Map.Insert (+"short", Short_Token);
      Map.Insert (+"static", Static_Token);
      Map.Insert (+"stringifier", Stringifier_Token);
      Map.Insert (+"symbol", Symbol_Token);
      Map.Insert (+"true", True_Token);
      Map.Insert (+"typedef", Typedef_Token);
      Map.Insert (+"undefined", Undefined_Token);
      Map.Insert (+"unrestricted", Unrestricted_Token);
      Map.Insert (+"unsigned", Unsigned_Token);

      Map.Insert (+"ArrayBuffer", ArrayBuffer_Token);
      Map.Insert (+"ByteString", ByteString_Token);
      Map.Insert (+"DataView", DataView_Token);
      Map.Insert (+"DOMString", DOMString_Token);
      Map.Insert (+"Float32Array", Float32Array_Token);
      Map.Insert (+"Float64Array", Float64Array_Token);
      Map.Insert (+"FrozenArray", FrozenArray_Token);
      Map.Insert (+"Infinity", Infinity_Token);
      Map.Insert (+"Int16Array", Int16Array_Token);
      Map.Insert (+"Int32Array", Int32Array_Token);
      Map.Insert (+"Int8Array", Int8Array_Token);
      Map.Insert (+"NaN", NaN_Token);
      Map.Insert (+"ObservableArray", ObservableArray_Token);
      Map.Insert (+"Promise", Promise_Token);
      Map.Insert (+"Uint16Array", Uint16Array_Token);
      Map.Insert (+"Uint32Array", Uint32Array_Token);
      Map.Insert (+"Uint8Array", Uint8Array_Token);
      Map.Insert (+"Uint8ClampedArray", Uint8ClampedArray_Token);
      Map.Insert (+"USVString", USVString_Token);

      null;
   end Initialize;

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

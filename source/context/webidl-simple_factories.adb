--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

package body WebIDL.Simple_Factories is

   package body Nodes is

      type Argument_Vector_C_Access is access constant Argument_Vector;

      overriding function Arguments (Self : Constructor)
        return not null WebIDL.Arguments.Argument_Iterator_Access
      is
         X : constant Argument_Vector_C_Access :=
           Self.Arguments'Unchecked_Access;
      begin
         return WebIDL.Arguments.Argument_Iterator_Access (X);
      end Arguments;

      overriding function First (Self : Member_Vector)
        return WebIDL.Interface_Members.Cursor is
      begin
         if Self.Vector.Is_Empty then
            return (1, null);
         else
            return (1, Self.Vector.First_Element);
         end if;
      end First;

      overriding function First (Self : Argument_Vector)
        return WebIDL.Arguments.Cursor is
      begin
         if Self.Vector.Is_Empty then
            return (1, null);
         else
            return (1, Self.Vector.First_Element);
         end if;
      end First;

      overriding function Next
        (Self     : Member_Vector;
         Position : WebIDL.Interface_Members.Cursor)
           return WebIDL.Interface_Members.Cursor is
      begin
         if Position.Index >= Self.Vector.Last_Index then
            return (Self.Vector.Last_Index + 1, null);
         else
            return (Position.Index + 1, Self.Vector (Position.Index + 1));
         end if;
      end Next;

      overriding function Next
        (Self     : Argument_Vector;
         Position : WebIDL.Arguments.Cursor)
           return WebIDL.Arguments.Cursor is
      begin
         if Position.Index >= Self.Vector.Last_Index then
            return (Self.Vector.Last_Index + 1, null);
         else
            return (Position.Index + 1, Self.Vector (Position.Index + 1));
         end if;
      end Next;

      overriding procedure Append
        (Self : in out Member_Vector;
         Item : not null WebIDL.Interface_Members.Interface_Member_Access) is
      begin
         Self.Vector.Append (Item);
      end Append;

      overriding procedure Append
        (Self : in out Argument_Vector;
         Item : not null WebIDL.Arguments.Argument_Access) is
      begin
         Self.Vector.Append (Item);
      end Append;

      type Member_Vector_C_Access is access constant Member_Vector;

      overriding function Members (Self : Interfase)
        return WebIDL.Interface_Members.Interface_Member_Iterator_Access
      is
         X : constant Member_Vector_C_Access := Self.Members'Unchecked_Access;
      begin
         return WebIDL.Interface_Members.Interface_Member_Iterator_Access (X);
      end Members;

   end Nodes;

   ---------
   -- Any --
   ---------

   overriding function Any (Self : in out Factory)
     return not null WebIDL.Types.Type_Access is
   begin
      return Types.Any'Access;
   end Any;

   --------------
   -- Argument --
   --------------

   overriding function Argument
     (Self         : in out Factory;
      Type_Def     : WebIDL.Types.Type_Access;
      Name         : League.Strings.Universal_String;
      Is_Optional  : Boolean;
      Has_Ellipsis : Boolean)
        return not null WebIDL.Arguments.Argument_Access
   is
      Result : constant Nodes.Argument_Access := new Nodes.Argument'
        (Name, Type_Def, Is_Optional, Has_Ellipsis);
   begin

      return WebIDL.Arguments.Argument_Access (Result);
   end Argument;

   ---------------
   -- Arguments --
   ---------------

   overriding function Arguments (Self : in out Factory)
     return not null WebIDL.Factories.Argument_Vector_Access
   is
      Result : constant Nodes.Argument_Vector_Access :=
        new Nodes.Argument_Vector;
   begin
      return WebIDL.Factories.Argument_Vector_Access (Result);
   end Arguments;

   ------------
   -- BigInt --
   ------------

   overriding function BigInt (Self : in out Factory)
     return not null WebIDL.Types.Type_Access is
   begin
      return Types.BigInt'Access;
   end BigInt;

   ----------
   -- Bool --
   ----------

   overriding function Bool (Self : in out Factory)
     return not null WebIDL.Types.Type_Access is
   begin
      return Types.Bool'Access;
   end Bool;

   ----------
   -- Byte --
   ----------

   overriding function Byte (Self : in out Factory)
     return not null WebIDL.Types.Type_Access is
   begin
      return Types.Byte'Access;
   end Byte;

   ----------------
   -- ByteString --
   ----------------

   overriding function ByteString (Self : in out Factory)
     return not null WebIDL.Types.Type_Access is
   begin
      return Types.ByteString'Access;
   end ByteString;

   -----------------
   -- Constructor --
   -----------------

   overriding function Constructor
     (Self : in out Factory;
      Args : not null WebIDL.Factories.Argument_Vector_Access)
        return not null WebIDL.Constructors.Constructor_Access
   is
      Result : constant Nodes.Constructor_Access := new Nodes.Constructor'
        (Arguments => <>);
   begin
      Result.Arguments.Vector := Nodes.Argument_Vector (Args.all).Vector;

      return WebIDL.Constructors.Constructor_Access (Result);
   end Constructor;

   ---------------
   -- DOMString --
   ---------------

   overriding function DOMString (Self : in out Factory)
     return not null WebIDL.Types.Type_Access is
   begin
      return Types.DOMString'Access;
   end DOMString;

   -----------------
   -- Enumeration --
   -----------------

   overriding function Enumeration
     (Self   : in out Factory; Name : League.Strings.Universal_String;
      Values : League.String_Vectors.Universal_String_Vector)
      return not null WebIDL.Enumerations.Enumeration_Access
   is
      Result : constant Nodes.Enumeration_Access := new Nodes.Enumeration'
        (Name, Values);
   begin
      return WebIDL.Enumerations.Enumeration_Access (Result);
   end Enumeration;

   -----------
   -- Float --
   -----------

   overriding function Float
     (Self       : in out Factory;
      Restricted : Boolean;
      Double     : Boolean)
        return not null WebIDL.Types.Type_Access is
   begin
      if Double then
         return Types.Double'Access;
      else
         return Types.Float'Access;
      end if;
   end Float;

   -------------
   -- Integer --
   -------------

   overriding function Integer
     (Self        : in out Factory;
      Is_Unsigned : Boolean;
      Long        : Natural)
        return not null WebIDL.Types.Type_Access is
   begin
      if Is_Unsigned then
         if Long = 0 then
            return Types.Unsigned_Short'Access;
         elsif Long = 1 then
            return Types.Unsigned_Long'Access;
         else
            return Types.Unsigned_Long_Long'Access;
         end if;
      elsif Long = 0 then
         return Types.Short'Access;
      elsif Long = 1 then
         return Types.Long'Access;
      else
         return Types.Long_Long'Access;
      end if;
   end Integer;

   -----------------------
   -- Interface_Members --
   -----------------------

   overriding function Interface_Members (Self : in out Factory)
     return not null WebIDL.Factories.Interface_Member_Vector_Access
   is
      Result : constant Nodes.Member_Vector_Access := new Nodes.Member_Vector;
   begin
      return WebIDL.Factories.Interface_Member_Vector_Access (Result);
   end Interface_Members;

   -------------------
   -- New_Interface --
   -------------------

   overriding function New_Interface
     (Self    : in out Factory;
      Name    : League.Strings.Universal_String;
      Parent  : League.Strings.Universal_String;
      Members : not null WebIDL.Factories.Interface_Member_Vector_Access)
        return not null WebIDL.Interfaces.Interface_Access
   is
      Result : constant Nodes.Interface_Access := new Nodes.Interfase'
        (Name, Parent, Members => <>);
   begin
      Result.Members.Vector := Nodes.Member_Vector (Members.all).Vector;

      return WebIDL.Interfaces.Interface_Access (Result);
   end New_Interface;

   ------------
   -- Object --
   ------------

   overriding function Object (Self : in out Factory)
     return not null WebIDL.Types.Type_Access is
   begin
      return Types.Object'Access;
   end Object;

   -----------
   -- Octet --
   -----------

   overriding function Octet (Self : in out Factory)
     return not null WebIDL.Types.Type_Access is
   begin
      return Types.Octet'Access;
   end Octet;

   ------------
   -- Symbol --
   ------------

   overriding function Symbol (Self : in out Factory)
     return not null WebIDL.Types.Type_Access is
   begin
      return Types.Symbol'Access;
   end Symbol;

   ---------------
   -- Undefined --
   ---------------

   overriding function Undefined (Self : in out Factory)
     return not null WebIDL.Types.Type_Access is
   begin
      return Types.Undefined'Access;
   end Undefined;

   ---------------
   -- USVString --
   ---------------

   overriding function USVString (Self : in out Factory)
     return not null WebIDL.Types.Type_Access is
   begin
      return Types.USVString'Access;
   end USVString;

end WebIDL.Simple_Factories;

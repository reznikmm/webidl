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

      overriding function First (Self : Union_Member_Vector)
        return WebIDL.Types.Cursor is
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

      overriding function Next
        (Self     : Union_Member_Vector;
         Position : WebIDL.Types.Cursor)
           return WebIDL.Types.Cursor is
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

      overriding procedure Append
        (Self : in out Union_Member_Vector;
         Item : not null WebIDL.Types.Type_Access) is
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

   package body Types is
      overriding function Name (Self : Union)
        return League.Strings.Universal_String
      is
         Result : League.Strings.Universal_String :=
           Self.Member.Vector.First_Element.Name;
      begin
         for J in 2 .. Self.Member.Vector.Last_Index loop
            Result.Append ("Or");
            Result.Append (Self.Member.Vector.Element (J).Name);
         end loop;

         return Result;
      end Name;

      type Type_Vector_C_Access is access constant Nodes.Union_Member_Vector;

      overriding function Members (Self : Union)
        return not null WebIDL.Types.Type_Iterator_Access
      is
         X : constant Type_Vector_C_Access :=
           Self.Member'Unchecked_Access;
      begin
         return WebIDL.Types.Type_Iterator_Access (X);
      end Members;
   end Types;

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

   -------------------------
   -- Buffer_Related_Type --
   -------------------------

   overriding function Buffer_Related_Type
     (Self : in out Factory;
      Name : League.Strings.Universal_String)
        return not null WebIDL.Types.Type_Access
   is
      Ok     : Boolean;
      Cursor : Type_Maps.Cursor := Self.Buffers.Find (Name);
      Result : Types.Buffer_Type_Access;
   begin
      if not Type_Maps.Has_Element (Cursor) then
         Result := new Types.Buffer_Type'(Name => Name);
         Self.Buffers.Insert
           (Name,
            WebIDL.Types.Type_Access (Result),
            Cursor,
            Ok);
      end if;

      return Type_Maps.Element (Cursor);
   end Buffer_Related_Type;

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

   ------------------
   -- Frozen_Array --
   ------------------

   overriding function Frozen_Array
     (Self : in out Factory;
      T    : not null WebIDL.Types.Type_Access)
        return not null WebIDL.Types.Type_Access
   is
      Ok     : Boolean;
      Name   : constant League.Strings.Universal_String := T.Name;
      Cursor : Type_Maps.Cursor := Self.Arrays.Find (Name);
      Result : Types.Frozen_Array_Access;
   begin
      if not Type_Maps.Has_Element (Cursor) then
         Result := new Types.Frozen_Array'(Element => T);
         Self.Arrays.Insert
           (Name,
            WebIDL.Types.Type_Access (Result),
            Cursor,
            Ok);
      end if;

      return Type_Maps.Element (Cursor);
   end Frozen_Array;

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

   --------------
   -- Nullable --
   --------------

   overriding function Nullable
     (Self : in out Factory;
      T    : not null WebIDL.Types.Type_Access)
        return not null WebIDL.Types.Type_Access
   is
      Ok     : Boolean;
      Name   : constant League.Strings.Universal_String := T.Name;
      Cursor : Type_Maps.Cursor := Self.Nullables.Find (Name);
      Result : Types.Nullable_Access;
   begin
      if not Type_Maps.Has_Element (Cursor) then
         Result := new Types.Nullable'(Inner => T);
         Self.Nullables.Insert
           (Name,
            WebIDL.Types.Type_Access (Result),
            Cursor,
            Ok);
      end if;

      return Type_Maps.Element (Cursor);
   end Nullable;

   ------------
   -- Object --
   ------------

   overriding function Object (Self : in out Factory)
     return not null WebIDL.Types.Type_Access is
   begin
      return Types.Object'Access;
   end Object;

   ----------------------
   -- Observable_Array --
   ----------------------

   overriding function Observable_Array
     (Self : in out Factory;
      T    : not null WebIDL.Types.Type_Access)
        return not null WebIDL.Types.Type_Access
   is
      Ok     : Boolean;
      Name   : constant League.Strings.Universal_String := T.Name;
      Cursor : Type_Maps.Cursor := Self.Observables.Find (Name);
      Result : Types.Observable_Array_Access;
   begin
      if not Type_Maps.Has_Element (Cursor) then
         Result := new Types.Observable_Array'(Element => T);
         Self.Observables.Insert
           (Name,
            WebIDL.Types.Type_Access (Result),
            Cursor,
            Ok);
      end if;

      return Type_Maps.Element (Cursor);
   end Observable_Array;

   -----------
   -- Octet --
   -----------

   overriding function Octet (Self : in out Factory)
     return not null WebIDL.Types.Type_Access is
   begin
      return Types.Octet'Access;
   end Octet;

   -------------
   -- Promise --
   -------------

   overriding function Promise
     (Self : in out Factory;
      T    : not null WebIDL.Types.Type_Access)
     return not null WebIDL.Types.Type_Access
   is
      Ok     : Boolean;
      Name   : constant League.Strings.Universal_String := T.Name;
      Cursor : Type_Maps.Cursor := Self.Promises.Find (Name);
      Result : Types.Promise_Access;
   begin
      if not Type_Maps.Has_Element (Cursor) then
         Result := new Types.Promise'(Element => T);
         Self.Promises.Insert
           (Name,
            WebIDL.Types.Type_Access (Result),
            Cursor,
            Ok);
      end if;

      return Type_Maps.Element (Cursor);
   end Promise;

   -----------------
   -- Record_Type --
   -----------------

   overriding function Record_Type
     (Self  : in out Factory;
      Key   : not null WebIDL.Types.Type_Access;
      Value : not null WebIDL.Types.Type_Access)
        return not null WebIDL.Types.Type_Access
   is
      use type League.Strings.Universal_String;
      Ok     : Boolean;
      Name   : constant League.Strings.Universal_String :=
        Key.Name & "/" & Value.Name;
      Cursor : Type_Maps.Cursor := Self.Records.Find (Name);
      Result : Types.Record_Type_Access;
   begin
      if not Type_Maps.Has_Element (Cursor) then
         Result := new Types.Record_Type'(Key, Value);
         Self.Records.Insert
           (Name,
            WebIDL.Types.Type_Access (Result),
            Cursor,
            Ok);
      end if;

      return Type_Maps.Element (Cursor);
   end Record_Type;

   --------------
   -- Sequence --
   --------------

   overriding function Sequence
     (Self : in out Factory;
      T    : not null WebIDL.Types.Type_Access)
        return not null WebIDL.Types.Type_Access
   is
      Ok     : Boolean;
      Name   : constant League.Strings.Universal_String := T.Name;
      Cursor : Type_Maps.Cursor := Self.Sequences.Find (Name);
      Result : Types.Sequence_Access;
   begin
      if not Type_Maps.Has_Element (Cursor) then
         Result := new Types.Sequence'(Element => T);
         Self.Sequences.Insert
           (Name,
            WebIDL.Types.Type_Access (Result),
            Cursor,
            Ok);
      end if;

      return Type_Maps.Element (Cursor);
   end Sequence;

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

   -----------
   -- Union --
   -----------

   overriding function Union
     (Self : in out Factory;
      T    : not null WebIDL.Factories.Union_Member_Vector_Access)
        return not null WebIDL.Types.Type_Access
   is
      Result : constant Types.Union_Access := new Types.Union'
        (Member => <>);
   begin
      Result.Member.Vector := Nodes.Union_Member_Vector (T.all).Vector;

      return WebIDL.Types.Type_Access (Result);
   end Union;

   -------------------
   -- Union_Members --
   -------------------

   overriding function Union_Members (Self : in out Factory)
     return not null WebIDL.Factories.Union_Member_Vector_Access
   is
      Result : constant Nodes.Union_Member_Vector_Access :=
        new Nodes.Union_Member_Vector;
   begin
      return WebIDL.Factories.Union_Member_Vector_Access (Result);
   end Union_Members;

   ---------------
   -- USVString --
   ---------------

   overriding function USVString (Self : in out Factory)
     return not null WebIDL.Types.Type_Access is
   begin
      return Types.USVString'Access;
   end USVString;

end WebIDL.Simple_Factories;

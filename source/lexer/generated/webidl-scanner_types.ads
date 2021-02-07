package WebIDL.Scanner_Types is
   pragma Preelaborate;

   type State is mod +32;
   subtype Looping_State is State range 0 .. 23;
   subtype Final_State is State range 13 .. State'Last - 1;

   Error_State : constant State := State'Last;

   INITIAL : constant State := 0;
   In_Comment : constant State := 12;

   type Character_Class is mod +19;

   type Rule_Index is range 0 .. 11;

end WebIDL.Scanner_Types;

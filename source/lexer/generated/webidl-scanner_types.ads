package WebIDL.Scanner_Types is
   pragma Preelaborate;

   type State is mod +27;
   subtype Looping_State is State range 0 .. 20;
   subtype Final_State is State range 12 .. State'Last - 1;

   Error_State : constant State := State'Last;

   INITIAL : constant State := 0;
   In_Comment : constant State := 11;

   type Character_Class is mod +18;

   type Rule_Index is range 0 .. 9;

end WebIDL.Scanner_Types;

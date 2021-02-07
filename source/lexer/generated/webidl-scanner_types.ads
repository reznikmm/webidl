package WebIDL.Scanner_Types is
   pragma Preelaborate;

   type State is mod +7;
   subtype Looping_State is State range 0 .. 5;
   subtype Final_State is State range 2 .. State'Last - 1;

   Error_State : constant State := State'Last;

   INITIAL : constant State := 0;

   type Character_Class is mod +7;

   type Rule_Index is range 0 .. 1;

end WebIDL.Scanner_Types;

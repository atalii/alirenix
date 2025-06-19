with Ada.Text_IO;
use Ada.Text_IO;

procedure Withgnat is

   --  Use a Gnat 15 feature to fail if the test case is wrong.
   pragma Extensions_Allowed (All_Extensions);

   Message : constant String with External_Initialization => "string";

begin

   Put_Line (Message);

end Withgnat;

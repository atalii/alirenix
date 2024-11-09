--  Configuration for withdeps generated by Alire
pragma Restrictions (No_Elaboration_Code);
pragma Style_Checks (Off);

package Withdeps_Config is
   pragma Pure;

   Crate_Version : constant String := "0.1.0-dev";
   Crate_Name : constant String := "withdeps";

   Alire_Host_OS : constant String := "linux";

   Alire_Host_Arch : constant String := "x86_64";

   Alire_Host_Distro : constant String := "fedora";

   type Build_Profile_Kind is (release, validation, development);
   Build_Profile : constant Build_Profile_Kind := development;

end Withdeps_Config;

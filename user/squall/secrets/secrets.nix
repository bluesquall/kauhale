let
  squall = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPQBa5IorQ6jJITsk43SDszWDbxM5MJ+BbVC1wHM5Up4";

  nimrod = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGZpIptG0YmoW0AOI5aCiWXA3XsJSpNcFq/ZgsRD9EID";
  systems = [ nimrod ];
in
{
  "hashedPassword.age".publicKeys = [ squall ] ++ systems;
}

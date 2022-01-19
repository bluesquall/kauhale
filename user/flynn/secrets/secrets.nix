let
  flynn = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKmKKwp+2Z1BZWihzaReNzwlE0bQrixs+iM750ov/C24";
in
{
  "password.age".publicKeys = [ flynn ];
}

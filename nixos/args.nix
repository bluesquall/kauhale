{config, pkgs, lib, ...}:

with lib; { options = {
  name = mkOption {
    default = "Kevin Flynn";
    type = with types; uniq string;
  };
  username = mkOption {
    default = "maker";
    type = with types; uniq string;
  };
  uid = mkOption {
    default = 1982;
    type = types.int;
  };
  email = mkOption {
    default = "flynn@en.com";
    type = with types; uniq string;
  };
  hostname = mkOption {
    default = "encom";
    type = with types; uniq string;
  };
  pubKeysUrl = mkOption {
    default = "https://en.com/flynn/pubkeys";
  };
}; }

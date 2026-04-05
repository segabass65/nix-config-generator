{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  
  outputs = { self, nixpkgs, ... }: let 
    inherit (nixpkgs) lib;

  in {
    lib = {
      toSxhkd = { keybindings, extraConfig ? "" }: let
        config = lib.mapAttrsToList (
          hotkey: command:
            lib.optionalString (command != null) ''
              ${hotkey}
                ${command}
            ''
        ) keybindings;

      in
        lib.concatStringsSep "\n" (config ++ [ extraConfig ]);
    };
  };
}

{
  outputs = { self, ... }: {
    lib = {
      toSxhkdKeybindings = { pkgs, keybindings }:
        pkgs.lib.concatStringsSep "\n" (
          pkgs.lib.mapAttrsToList (
            hotkey: command:
              pkgs.lib.optionalString (command != null) ''
                ${hotkey}
                  ${command}
              ''
          ) keybindings
        );
    };
  };
}

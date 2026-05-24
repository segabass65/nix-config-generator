{
  description = "Config Generator";
  
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  
  outputs = { self, nixpkgs, ... }: let 
    inherit (nixpkgs) lib;

  in {
    lib = {
      toSxhkd = { keybindings, extraConfig ? "" }: let
        keybindings' = lib.mapAttrsToList (
          hotkey: command:
            lib.optionalString (command != null) ''
              ${hotkey}
                ${command}
            ''
        ) keybindings;

      in
        lib.concatStringsSep "\n" (keybindings' ++ [ extraConfig ]);

      toPolybar = { config ? {}, settings ? {}, extraConfig ? "" }: let

        # Converts an attrset to INI text, quoting values as expected by polybar.
        # This does no more fancy conversion.  
        toPolybarIni = lib.generators.toINI {
          mkKeyValue = key: value: let
            value' = if lib.isBool value then
              if value then "true" else "false"

            else if 
              lib.isString value &&
              key != "include-file" &&
              (lib.hasPrefix " " value || lib.hasSuffix " " value)

            then
              ''"${value}"''
            else
              toString value;

          in
            "${key}=${value'}";
        };

        # Convert a key/value pair to the insane format that polybar uses.
        # Each input key/value pair may return several output key/value pairs.
        convertPolybarKeyVal = key: value:

          # Convert { foo = [ "a" "b" ]; }
          # to {
          #   foo-0 = "a";
          #   foo-1 = "b";
          # }
          if lib.isList value then
            lib.concatLists (
              lib.imap0 (i: convertPolybarKeyVal "${key}-${toString i}")
              value
            )

          # Convert {
          #   foo.text = "a";
          #   foo.font = 1;
          # } to {
          #   foo = "a";
          #   foo-font = 1;
          # }
          else if lib.isAttrs value && !lib.isDerivation value then
            lib.concatLists (
              lib.mapAttrsToList (
                k: convertPolybarKeyVal (
                  if k == "text" then key else "${key}-${k}"
                )
              )
              value
            )

          # Base case
          else
            [ (lib.nameValuePair key value) ];

        convertPolybarSection = _: attrs:
          lib.listToAttrs (
            lib.concatLists (lib.mapAttrsToList convertPolybarKeyVal attrs)
          );

      in if
        config != {} ||
        settings != {} ||
        extraConfig != ""

      then ''
        ${toPolybarIni config}
        ${toPolybarIni (lib.mapAttrs convertPolybarSection settings)}
        ${extraConfig}
      ''

      else
        null;

      toColoraddod = { settings ? { }, extraConfig ? "" }: let
        flatten = prefix: value:
          if builtins.typeOf value == "set" then
            builtins.concatLists (
              builtins.attrValues (
                builtins.mapAttrs (attrKey: attrValue:
                  flatten (prefix ++ [ attrKey ]) attrValue
                ) value
              )
            )

          else [ (builtins.toString (prefix ++ [ value ])) ];

      in
        builtins.concatStringsSep "\n" (
          (
            builtins.map
              (value: lib.escapeShellArgs (lib.strings.splitString " " value))
              (flatten [ "coloraddoctl config" ] settings)
          ) ++ [ extraConfig ]
        );
    };
  };
}

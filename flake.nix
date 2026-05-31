{
  description = "Config Generator";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }: {
    lib = import ./lib.nix { inherit (nixpkgs) lib; };
  };
}

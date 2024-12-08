{
  description = "bromanko's dictionary";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake
      {
        inherit inputs;
      }
      {
        systems = [
          "aarch64-darwin"
          "x86_64-linux"
          "aarch64-linux"
        ];
        perSystem =
          {
            pkgs,
            ...
          }:
          {
            packages = { };
            devShells.default = pkgs.mkShell {
              buildInputs = with pkgs; [ sqlite3 ];
            };
          };
      };
}

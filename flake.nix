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
              DICTIONARY_DB_PATH = "./priv/dictionary.db";

              buildInputs = with pkgs; [
                sqlite
                gleam
                erlang_27
                rebar3
                watchexec
              ];
            };
          };
      };
}

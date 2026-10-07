{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];
      perSystem =
        { lib, pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            packages =
              with pkgs;
              [
                gnumake
                zip
              ]
              ++ (with ocaml-ng.ocamlPackages_4_14; [
                dune_3
                menhir
                num
                ocaml
                ocaml-lsp
                ocamlformat_0_26_1
                utop
              ]);

            TARGET_CC = lib.getExe (
              if pkgs.stdenv.hostPlatform.isDarwin then pkgs.pkgsx86_64Darwin.clang else pkgs.clang
            );
          };
        };
    };
}

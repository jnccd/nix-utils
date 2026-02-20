{
  description = "Nix code I reuse across projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let mkUnfrozenDotnetShell = import ./mkUnfrozenDotnetShell.nix;
    in (inputs.utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ]
      (system: {
        devShells = rec {
          dotnet9AndroidDevShell = mkUnfrozenDotnetShell {
            inherit system nixpkgs;
            dotnetVersion = "9.0";
          };
          dotnet10AndroidDevShell = mkUnfrozenDotnetShell {
            inherit system nixpkgs;
            dotnetVersion = "10.0";
          };
          default = dotnet10AndroidDevShell;
        };
      })) // {
        lib = { inherit mkUnfrozenDotnetShell; };
      };
}

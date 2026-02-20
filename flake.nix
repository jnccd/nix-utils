{
  description = "Nix code I reuse across projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let createDotnetAndroidDevShell = import ./createDotnetAndroidDevShell.nix;
    in (inputs.utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ]
      (system: {
        devShells = rec {
          dotnet9AndroidDevShell =
            createDotnetAndroidDevShell system "9.0" nixpkgs;
          dotnet10AndroidDevShell =
            createDotnetAndroidDevShell system "10.0" nixpkgs;
          default = dotnet10AndroidDevShell;
        };
      })) // {
        lib = { inherit createDotnetAndroidDevShell; };
      };
}

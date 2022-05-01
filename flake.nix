{
  description = "A very basic flake";

  inputs = {
    haskellNix.url = "github:input-output-hk/haskell.nix";
    nixpkgs.follows = "haskellNix/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, haskellNix }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ] (system:
      let
        overlays = [ haskellNix.overlay ];
        pkgs = import nixpkgs { inherit system overlays; inherit (haskellNix) config; };
      in
      {
        defaultPackage =
          ((pkgs.haskell-nix.stackProject {
            src = ./.;
            # modules = [{ reinstallableLibGhc = true; }];
          }).flake { }).packages."foo:exe:foo";
      }
    );
}

{
  description = "profile config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    rust-overlay.url = "github:oxalica/rust-overlay";
    nil.url = "github:oxalica/nil";
  };

  outputs = { self, nixpkgs, rust-overlay, nil }:
    let
      system = "x86_64-linux";
      # Apply the rust-overlay to nixpkgs
      overlays = [ (import rust-overlay) ];
      pkgs = import nixpkgs {
        inherit system overlays;
      };
    in
    {
      packages.${system}.default = pkgs.buildEnv {
        name = "home-profile";
        paths = [
          # --- NIX PACKAGE MANAGER ---
          # This ensures 'nix' updates when you update the flake
          pkgs.nix

          # --- RUST TOOLCHAIN ---
          # This gives you the latest stable rustc, cargo, etc.
          (pkgs.rust-bin.stable.latest.default.override {
            extensions = [ "rust-src" "rust-analyzer" ];
          })

          # --- DEV TOOLS ---
          pkgs.btop
          pkgs.carapace
          pkgs.clang-tools
          pkgs.devenv
          pkgs.direnv
          pkgs.helix
          pkgs.starship
          pkgs.nushell
          pkgs.yazi
          pkgs.nixpkgs-fmt
          nil.packages.${system}.default

          # --- NUSHELL PLUGINS ---
          pkgs.nushellPlugins.formats
          pkgs.nushellPlugins.gstat
          pkgs.nushellPlugins.polars
          pkgs.nushellPlugins.query

          # --- FIX FOR BROKEN PACKAGES ---
          # If dotenvx fails, we use 'pname' to find it safely or skip
          pkgs.dotenvx
        ];
      };
    };
}

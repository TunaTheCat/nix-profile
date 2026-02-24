{
  description = "profile config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOs/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    nil.url = "github:oxalica/nil";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, rust-overlay, nil }:
    let
      system = "x86_64-linux";
      # Apply the rust-overlay to nixpkgs
      overlays = [ (import rust-overlay) ];
      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      packages.${system}.default = pkgs.buildEnv {
        name = "home-profile";
        paths = [
          pkgs.nix

          (pkgs.rust-bin.stable.latest.default.override {
            extensions = [ "rust-src" "rust-analyzer" ];
          })

          unstable.claude-code

          pkgs.wl-clipboard
          pkgs.apostrophe
          pkgs.neofetch
          pkgs.frogmouth
          pkgs.glow
          pkgs.fastfetch
          pkgs.nodejs_24
          pkgs.btop
          pkgs.ghc
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

          pkgs.nushellPlugins.formats
          pkgs.nushellPlugins.gstat
          pkgs.nushellPlugins.polars
          pkgs.nushellPlugins.query

          pkgs.dotenvx
        ];
      };
    };
}

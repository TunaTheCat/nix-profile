{
  description = "profile config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOs/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-overlay = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, rust-overlay, claude-overlay, nil, zen }:
    let
      system = "x86_64-linux";
      # Apply the rust-overlay to nixpkgs
      overlays = [
        rust-overlay.overlays.default
        claude-overlay.overlays.default
      ];
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

          pkgs.claude-code
          pkgs.nh

          pkgs.wl-clipboard
          pkgs.ncdu
          pkgs.neofetch
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
          pkgs.lazygit
          pkgs.delta
          pkgs.secretspec
          pkgs.filezilla

          zen.packages.${system}.default
        ];
      };
    };
}

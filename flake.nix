{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          # Disable all Nix hardening flags to prevent interference with Cargo builds.
          # These flags are designed for C/C++ and can cause issues with:
          # - MUSL builds (fortify adds glibc-specific functions)
          # - Crates that vendor C libraries (e.g., git2 vendoring libgit2)
          # Rust already provides memory safety, so these hardening flags provide
          # minimal benefit while causing build problems.
          hardeningDisable = [ "all" ];

          buildInputs = [
            # Shell scripts.
            pkgs.shfmt
            pkgs.shellcheck
            # GitHub Action Workflows.
            pkgs.yamlfmt
            pkgs.actionlint
            # End to end tests.
            pkgs.zsh
            pkgs.python313
            pkgs.python313Packages.pexpect
            pkgs.python313Packages.autopep8
            # Deploying.
            pkgs.gh
          ];
        };
      }
    );
}

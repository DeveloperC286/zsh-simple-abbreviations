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

        zsh-simple-abbreviations = pkgs.stdenvNoCC.mkDerivation {
          name = "zsh-simple-abbreviations";

          src = self;

          strictDeps = true;
          dontConfigure = true;
          dontBuild = true;

          installPhase = ''
            runHook preInstall

            install -Dm644 zsh-simple-abbreviations.zsh \
              "$out/share/zsh-simple-abbreviations/zsh-simple-abbreviations.zsh"
            cp -R src "$out/share/zsh-simple-abbreviations/"

            runHook postInstall
          '';

          meta = {
            description = "Simple manager for abbreviations in Z shell (Zsh)";
            homepage = "https://github.com/DeveloperC286/zsh-simple-abbreviations";
            license = pkgs.lib.licenses.agpl3Only;
            platforms = pkgs.lib.platforms.unix;
          };
        };
      in
      {
        packages.default = zsh-simple-abbreviations;
        packages.zsh-simple-abbreviations = zsh-simple-abbreviations;

        devShells.default = pkgs.mkShell {
          # Disable all Nix hardening flags to prevent interference with Cargo builds.
          # These flags are designed for C/C++ and can cause issues with:
          # - MUSL builds (fortify adds glibc-specific functions)
          # - Crates that vendor C libraries (e.g., git2 vendoring libgit2)
          # Rust already provides memory safety, so these hardening flags provide
          # minimal benefit while causing build problems.
          hardeningDisable = [ "all" ];

          buildInputs = [
            # Python formatting.
            pkgs.python313Packages.autopep8
            # YAML formatting.
            pkgs.yamlfmt
            # Python linting.
            pkgs.python313Packages.ruff
            # GitHub Actions workflows linting.
            pkgs.actionlint
            # End to end tests.
            pkgs.zsh
            pkgs.python313
            pkgs.python313Packages.pexpect
            # Deploying.
            pkgs.gh
          ];
        };
      }
    );
}

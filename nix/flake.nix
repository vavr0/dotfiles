{
  description = "H3ny-MacbookPro";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = with pkgs; [
            bat
            btop
            coreutils
            eza
            fastfetch
            fd
            fzf
            gh
            git
            htop
            jq
            lazygit
            nmap
            pandoc
            # LaTeX for vimtex: pdflatex/xelatex/lualatex + latexmk + chktex.
            (texlive.combine {
              inherit (texlive) scheme-small latexmk chktex;
            })
            texlab
            ripgrep
            stow
            tmux
            tree
            vesktop
            wget
            yazi
            yt-dlp
            zoxide
            neovim
            bear
            cmake
            black
            clang-tools
            cppcheck
            shfmt
            stylua
            tree-sitter
            typst
            zig
            nixfmt
            ffmpeg
            go
            llvm
            imagemagick
            pkg-config
            luarocks
            emacs
            lftp
            jujutsu
          ];

          homebrew = {
            enable = true;
            taps = [
              "nikitabobko/tap"
            ];
            casks = [
              "sf-symbols"
              "aerospace"
              "visual-studio-code"
              "wolfram-engine"
              "ghostty"
              "raycast"
              "karabiner-elements"
              "helium-browser"
              "vial"
              "zotero"
              "sioyek"
            ];
            brews = [
              "pi-coding-agent"
              "gmp"
              "spotify_player"
            ];
            onActivation.cleanup = "zap";
            onActivation.autoUpdate = true;
            onActivation.upgrade = true;
            onActivation.extraFlags = [ "--force-cleanup" ];
          };

          system.defaults = {
            dock = {
              autohide = true;
              autohide-delay = 1000.0;
              show-recents = false;
              tilesize = 43;
              orientation = "bottom";
            };

            NSGlobalDomain = {
              _HIHideMenuBar = true;
              ApplePressAndHoldEnabled = false;
              AppleShowAllExtensions = true;
            };

            finder = {
              ShowPathbar = true;
              ShowStatusBar = true;
              FXPreferredViewStyle = "glyv";
            };
            screencapture = {
              location = "/Users/vavro/personal/screenshots/";
            };
          };

          services.tailscale.enable = true;

          programs.zsh = {
            enable = true;
            enableCompletion = true;
            enableAutosuggestions = true;
            enableSyntaxHighlighting = true;
          };

          fonts.packages = [
            pkgs.nerd-fonts.sauce-code-pro
          ];

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
          system.primaryUser = "vavro";
          users.users.vavro.home = "/Users/vavro";

        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
        modules = [ configuration ];
      };
    };
}

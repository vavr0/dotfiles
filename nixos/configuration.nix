# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Bratislava";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sk_SK.UTF-8";
    LC_IDENTIFICATION = "sk_SK.UTF-8";
    LC_MEASUREMENT = "sk_SK.UTF-8";
    LC_MONETARY = "sk_SK.UTF-8";
    LC_NAME = "sk_SK.UTF-8";
    LC_NUMERIC = "sk_SK.UTF-8";
    LC_PAPER = "sk_SK.UTF-8";
    LC_TELEPHONE = "sk_SK.UTF-8";
    LC_TIME = "sk_SK.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."vavr0" = {
    isNormalUser = true;
    description = "vavr0";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  nix.settings.experimental-features = [
	  "nix-command"
		  "flakes"
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

   services.udev.packages = [
     (pkgs.writeTextDir "lib/udev/rules.d/59-vial.rules" ''
       KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess"
     '')
   ];

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
  	btop
	eza
	fd
	ripgrep
	zoxide
	fzf
	  wget
	  fastfetch
	  lf
	  zip
	  unzip
	  chafa
	  kew
	  man-pages


	  librewolf
	  firefox
	  foot
	  tmux
	  neovim 
	  git
	  gh
	  jujutsu
	  pi-coding-agent
	  vis

	  vesktop
	  codex
	  vial
	  nicotine-plus
	  (sioyek.overrideAttrs (old: {
				 postPatch = (old.postPatch or "") + ''
				 substituteInPlace \
				 pdf_viewer/main.cpp \
				 pdf_viewer/pdf_view_opengl_widget.cpp \
				 --replace-fail 'format.setVersion(3, 3);' \
				 'format.setVersion(3, 3); format.setRenderableType(QSurfaceFormat::OpenGL);'
				 '';
				 }))

	  wlr-randr
	  wl-clipboard
	  wl-clip-persist
	  mako
	  swaybg
	  fuzzel

	  # tooling
	cmake
	   gcc
   gnumake
   tree-sitter
   clang-tools
	bear
	     lua-language-server
	     nixd
	     rustc
	     cargo
	     rust-analyzer
	     rustfmt
	     python3
	     uv
	  typst
	     clippy
	     basedpyright
	     ruff
	     bash-language-server
	     shellcheck
	     shfmt
	     vscode-langservers-extracted
	     typescript-language-server
	     typescript
	     lldb


	     nodejs
  ];


  programs.starship.enable = true;
  programs.steam.enable = true;
  programs.mango.enable = true;
  programs.zsh = {
	  enable = true;
	  enableCompletion=true;
	  autosuggestions.enable = true;
	  syntaxHighlighting.enable = true;
  };
  	

  

  hardware.graphics = {
	enable = true;
	enable32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
  	modesetting.enable = true;
	open = true;
  };

  

  
fonts.packages = with pkgs; [
  source-code-pro
  nerd-fonts.sauce-code-pro
  noto-fonts
];

   security.rtkit.enable = true;

   services.pipewire = {
     enable = true;
     alsa.enable = true;
     pulse.enable = true;
   };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.openFirewall = false;

  services.tailscale.enable = true;
  services.tailscale.openFirewall = true;

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}

{ config, pkgs, ... }:

let
  uhome            = builtins.getEnv "HOME";
  uname            = builtins.getEnv "USER";
  tmpdir          = "/tmp";
in {
  imports = [ <home-manager/nix-darwin> ];

  # Use a custom darwin-configuration location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin-configuration.nix
  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin-configuration.nix";

  # List of Binary Caches for Cardano
  nix.trustedBinaryCaches = [ "https://hydra.iohk.io" 
                              "https://cache.nixos.org/"
                              "https://cache.iog.io"
                            ];
  
  nix.binaryCachePublicKeys = [ 
                                "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
                                "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" 
                              ];

  # nix.binaryCaches = [
  #                       "https://cache.iog.io"
  #                    ];

  # Enable experimental nix command and flakes
  # nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
    system = x86_64-darwin
  '';

  programs.nix-index.enable = true;
  programs.zsh.enable = true;  # default shell on catalina

  # Add ability to used TouchID for sudo authentication
  # security.pam.enableSudoTouchIdAuth = true;  

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [ 
      #cachix
      #coreutils
      #gnupg
      #spacevim
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Homebrew Setup and installation
  # homebrew.enable = false;
  # homebrew.brews = [ 
  #                  "ghcup"
  #                  "haskell-stack"
  #                  "syntaqx/tap/serve"
  #                 ];

  users.users.${uname} = {
     name = uname;
     home = uhome;
  };

  home-manager.useGlobalPkgs = false;
  home-manager.users.${uname} = import ./home.nix;

  # Yubikey GPG SSH. Diverting the OSX ssh-agent to use gpg-agent
  # GPG Config
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Setup needed environment variables.
  environment.loginShell = "${pkgs.zsh}/bin/zsh -l";
  environment.variables.SHELL = "${pkgs.zsh}/bin/zsh";

  # Environment Variables and Aliases
  environment.systemPath = ["$HOME/bin"];
  environment.variables.LANG = "en_UK.UTF-8";

  # Makesure there are no duplicate entries in the PATH and put usr paths first.
  environment.extraInit = ''
    typeset -U PATH path  
  '';

  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    inconsolata
    fira-code
    fira-mono
    nerdfonts
  ];

  time.timeZone = "Europe/London";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}

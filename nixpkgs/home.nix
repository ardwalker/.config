{ config, pkgs, lib, ... }:
let
  #git_username    = "";
  #git_useremail   = "";
  pkgsUnstable    = import <nixpkgs-unstable> {};
in {
  # Home Manager needs a bit of information about you and the paths it should manage.
  programs.home-manager.enable = true;
  home.username="andrew";
  home.homeDirectory="/Users/andrew";
  home.stateVersion = "22.05";

  # Raw configuration files
  #home.file.".zshrc".source = ./zshrc;
  home.file.".p10k.zsh".source = ./p10k.zsh;

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    asciidoctor
    bat
    bottom
    broot
    curl
    duf
    exa
    fd
    fzf
    git
    gh
    gnupg
    gping
    gtop
    htop
    httpie
    iterm2
    jdk11
    jq
    lsd
    m-cli #useful macOS CLI commands
    mongodb
    nix-direnv
    niv
    ripgrep
    spacevim
    sbt
    zsh-powerlevel10k
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    history = {
      path = "$HOME/.config/zsh/.zsh_history";
      size = 50000;
      save = 50000;
    };
    shellAliases = {
      l      = "${pkgs.exa}/bin/exa -galF";
      ls     = "${pkgs.exa}/bin/exa -galF --git";
      lst    = "${pkgs.exa}/bin/exa -glTF --git --git-ignore";
      vi     = "${pkgs.vim}/bin/vim";
      vim    = "${pkgs.spacevim}/bin/spacevim";
      ds     = "darwin-rebuild switch";
      gc     = "nix-collect-garbage -d";
      gs     = "${pkgs.git}/bin/git status";
      sbt11  = "${pkgs.sbt} --java-home ${pkgs.jdk11}";
      java11 = "export JAVA_HOME=`/usr/libexec/java_home -v11`";
    };
    sessionVariables = {
      cfg       = "$HOME/.config/nix/darwin-configuration.nix";
      darwin    = "$HOME/.nix-defexpr/darwin";
      nixpkgs   = "$HOME/.nix-defexpr/nixpkgs";
      LC_CTYPE  = "en_US.UTF-8";
      LC_ALL    = "en_US.UTF-8";
      NIXPKGS_ALLOW_BROKEN = "1";
    };

    initExtra = ''
      autoload -U promptinit && promptinit

      ulimit -n 8196

      # Integrate the prompt with git
      autoload -Uz vcs_info
      precmd_vcs_info() { vcs_info }
      precmd_functions+=( precmd_vcs_info )
      setopt prompt_subst

      # Default prompt
      #PROMPT='%F{green}%2~%f %# '
      #RPROMPT=\$vcs_info_msg_0_

      DEFAULT_USER prompt_context(){}

      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # Set the Right-handside prompt with git info
      #zstyle ':vcs_info:git:*' formats '%F{240}(%b)%r%f'
      #zstyle ':vcs_info:*' enable git

      source ~/.p10k.zsh

      export JAVA_HOME=`/usr/libexec/java_home -v11`
    '';
  };

  # Direnv, load and unload environment variables depending on the current directory.
  # https://direnv.net
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}

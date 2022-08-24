{ config, pkgs, lib, ... }:
let
  #git_username    = "";
  #git_useremail   = "";
  pkgsUnstable    = import <nixpkgs-unstable> {};
in {
  # Home Manager needs a bit of information about you and the paths it should manage.
  programs.home-manager.enable = true;
  home.stateVersion = "22.05";

  # Raw configuration files
  home.file.".zshrc".source = ./zshrc;
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
    #maven
    nix-direnv
    niv
    oh-my-zsh
    #procs
    #pinentry
    #redis
    ripgrep
    spacevim
    sbt
    zsh-powerlevel10k
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    # enableAutosuggestions = true;
    history = {
      path = "$HOME/.config/zsh/.zsh_history";
      size = 50000;
      save = 50000;
    };


    oh-my-zsh = {
      enable = true;
      theme = "powerlevel10k/powerlevel10k";
    };

    sessionVariables = {
      cfg       = "$HOME/.config/nix/darwin-configuration.nix";
      darwin    = "$HOME/.nix-defexpr/darwin";
      nixpkgs   = "$HOME/.nix-defexpr/nixpkgs";
      LC_CTYPE  = "en_US.UTF-8";
      LC_ALL    = "en_US.UTF-8";
      NIXPKGS_ALLOW_BROKEN = "1";
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
    };

    profileExtra = ''
      #eval "$(zoxide init zsh)"
      #export TERM=linux
      #export PATH="/nix/store/8ppz45l6hghxfc66i24zbwsaxx1rqmxp-stack-2.7.5/bin:$PATH"
    '';

    initExtra = ''
      #autoload -U promptinit && promptinit

      # Integrate the prompt with git
      #autoload -Uz vcs_info
      #precmd_vcs_info() { vcs_info }
      #precmd_functions+=( precmd_vcs_info )
      #setopt prompt_subst

      # Default prompt
      #PROMPT='%F{green}%2~%f %# '
      #RPROMPT=\$vcs_info_msg_0_

      DEFAULT_USER prompt_context(){}

      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme;

      # Set the Right-handside prompt with git info
      #zstyle ':vcs_info:git:*' formats '%F{240}(%b)%r%f'
      #zstyle ':vcs_info:*' enable git
    '';

  };

  # Direnv, load and unload environment variables depending on the current directory.
  # https://direnv.net
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Configure the dotfiles for GPG under $HOME/.gnupg/
  #programs.gpg.enable = true;
  # Configures the Yubikey and scdamon when NOT using GPGTools/MacGPG2. The 23 Nixpkgs build
  # is broken, therefore disable-ccid is needed. See:
  #
  # 1. pkgs.gnupg https://github.com/NixOS/nixpkgs/issues/155629
  # 2. OSX BigSur: https://www.chrisdeluca.me/article/fixing-gpg-yubikey-macos-big-sur/
  # 3. For PIN Entry: https://github.com/NixOS/nixpkgs/issues/145392
  #
  #programs.gpg.scdaemonSettings = {
  #  disable-ccid = true;
  #  reader-port = "Yubico YubiKey OTP+FIDO+CCID";
  #};

  # programs.direnv.enableZshIntegration = true;

  #programs.git = {
  #  enable = true;
  #  userName = git_username;
  #  userEmail = git_useremail;
  #  signing.gpgPath = "/usr/local/MacGPG2/bin/gpg2";
  #  ignores = [ ".envrc" ".DS_Store" ];
  #  attributes = [];
  #  aliases = {
  #    amend      = "commit --amend -C HEAD";
  #    authors    = "!\"${pkgs.git}/bin/git log --pretty=format:%aN"
  #               + " | ${pkgs.coreutils}/bin/sort"
  #               + " | ${pkgs.coreutils}/bin/uniq -c"
  #               + " | ${pkgs.coreutils}/bin/sort -rn\"";
      # b          = "branch --color -v";
  #    cm          = "commit -m";
  #    lg          = "log --graph";
  #    ls           = "log --oneline";
      # st         = "status";
   # };

    # lfs.enable = true;
    # lfs.skipSmudge = true;

    # NOTE: LFS settings in pkgs.git default to these:
    #
    #  filter.lfs = {
    #    clean = "git-lfs clean -- %f";
    #    smudge = "git-lfs smudge -- %f";
    #    process = "git-lfs filter-process";
    #    required = true;
    #  };
    #

    #diff-so-fancy.enable = true;

    #extraConfig = {
    #  init = { defaultBranch = "main";};
    #  rebase = { autosquash = true; };
    #  core = { editor = "code --wait"; };
    #  url = { "git@github.com:" = { insteadOf = "https://github.com/"; }; };
    #  pull = { rebase = true; };
    #  color = { status = "always"; };
    #  github.user = git_username;
    #  credential.helper = "osxkeychain";
    #};
  #};


}

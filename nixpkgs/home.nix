{ config, pkgs, lib, ... }:
let
  #git_username    = "parduseidolon";
  #git_useremail   = "38515818+PardusEidolon@users.noreply.github.com";
  #git_signing_key = "913D70FC69A16089";
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
      # g      = "${pkgs.git}/bin/git log --pretty=color -32";
      # gb     = "${pkgs.git}/bin/git branch";
      # gc     = "${pkgs.git}/bin/git checkout";
      # gcb    = "${pkgs.git}/bin/git checkout -B";
      # gd     = "${pkgs.git}/bin/git diff --minimal --patch";
      # gf     = "${pkgs.git}/bin/git fetch";
      # ga     = "${pkgs.git}/bin/git log --pretty=color --all";
      # gg     = "${pkgs.git}/bin/git log --pretty=color --graph";
      # gl     = "${pkgs.git}/bin/git log --pretty=nocolor";
      # grh    = "${pkgs.git}/bin/git reset --hard";

      # good   = "${pkgs.git}/bin/git bisect good";
      # bad    = "${pkgs.git}/bin/git bisect bad";
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

  # Git configuration see https://rycee.gitlab.io/home-manager/options.html#opt-programs.git.enable
  #programs.git = {
  #  enable = true;
  #  userName = git_username;
  #  userEmail = git_useremail;
  #  signing.key = git_signing_key;
  #  signing.signByDefault = true;
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
      # ca         = "commit --amend";
      # changes    = "diff --name-status -r";
      # clone      = "clone --recursive";
  #    cb         = "checkout -b";
  #    cob         = "checkout --orphan -b";
  #    pf          = "push -f";
      # cp         = "cherry-pick";
      # dc         = "diff --cached";
      # dh         = "diff HEAD";
      # ds         = "diff --staged";
      # from       = "!${pkgs.git}/bin/git bisect start && ${pkgs.git}/bin/git bisect bad HEAD && ${pkgs.git}/bin/git bisect good";
      # ls-ignored = "ls-files --exclude-standard --ignored --others";
      # rc         = "rebase --continue";
      # rh         = "reset --hard";
      # ri         = "rebase --interactive";
      # rs         = "rebase --skip";
      # ru         = "remote update --prune";
      # snap       = "!${pkgs.git}/bin/git stash"
      #            + " && ${pkgs.git}/bin/git stash apply";
      # snaplog    = "!${pkgs.git}/bin/git log refs/snapshots/refs/heads/"
      #            + "\$(${pkgs.git}/bin/git rev-parse HEAD)";
      # spull      = "!${pkgs.git}/bin/git stash"
      #            + " && ${pkgs.git}/bin/git pull"
      #            + " && ${pkgs.git}/bin/git stash pop";
      # st         = "status";
      # su         = "submodule update --init --recursive";
      # undo       = "reset --soft HEAD^";
      # w          = "status -sb";
      # wdiff      = "diff --color-words";
      # l          = "log --graph --pretty=format:'%Cred%h%Creset"
      #            + " —%Cblue%d%Creset %s %Cgreen(%cr)%Creset'"
                #  + " --abbrev-commit --date=relative --show-notes=*";
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

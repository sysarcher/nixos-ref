{ config, pkgs, unstable, ... }:

let
  unstablePkgs = import unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  home.username = "taimoor";
  home.homeDirectory = "/home/taimoor";
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    htop
    nodejs_24
    rustup
    ripgrep
    neovim
    clang
    jujutsu
    tree
    bottom
    pass
    dig
    unzip
    mongodb-compass
    ghostscript
    groff
    pandoc
    tldr
    ngrok
    tmux
    unixtools.net-tools
    pwgen
  ];

  home.sessionVariables = {
    PYENV_ROOT = "$HOME/.pyenv";
    CPPFLAGS = "-I${pkgs.zlib.dev}/include -I${pkgs.libffi.dev}/include -I${pkgs.readline.dev}/include -I${pkgs.bzip2.dev}/include -I${pkgs.openssl.dev}/include -I${pkgs.xz.dev}/include";
    CXXFLAGS = "-I${pkgs.zlib.dev}/include -I${pkgs.libffi.dev}/include -I${pkgs.readline.dev}/include -I${pkgs.bzip2.dev}/include -I${pkgs.openssl.dev}/include -I${pkgs.xz.dev}/include";
    CFLAGS = "-I${pkgs.openssl.dev}/include";
    LDFLAGS = "-L${pkgs.zlib.out}/lib -L${pkgs.libffi.out}/lib -L${pkgs.readline.out}/lib -L${pkgs.bzip2.out}/lib -L${pkgs.openssl.out}/lib -L${pkgs.xz.out}";
    CONFIGURE_OPTS = "-with-openssl=${pkgs.openssl.dev}";
  };

  programs.git = {
    enable = true;
    settings.user.name = "T";
    settings.user.email = "sysarcher@users.noreply.github.com";
  };

  programs.vim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      gruvbox
      vim-airline
    ];
    extraConfig = "colorscheme desert";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      k = "kubectl";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "docker-compose" "docker" "direnv" ];
      theme = "dst";
    };

    initContent = ''
      bindkey '^f' autosuggest-accept
      alias fa='flox activate'
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "FantasqueSansM Nerd Font Mono";
      size = 14;
    };
    themeFile = "Catppuccin-Macchiato";
    settings.enable_audio_bell = false;
  };

  programs.vscode = {
    enable = true;
    package = unstablePkgs.vscode;
  };
}


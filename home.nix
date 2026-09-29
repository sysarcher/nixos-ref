{ config, pkgs, unstable, hermes, nix-openclaw, ... }:

let
  unstablePkgs = import unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  imports = [
    hermes.homeManagerModules.default
    nix-openclaw.homeManagerModules.openclaw
  ];

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
    ghostscript
    groff
    pandoc
    tldr
    ngrok
    tmux
    unixtools.net-tools
    pwgen
    element-desktop
    lsof
    appimage-run
    bitwarden-cli
    bc
    gws
    unstablePkgs.opencode-desktop
    unstablePkgs.zeroclaw
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

  programs.hermes-agent = {
    enable = true;
  };

  services.hermes-agent = {
    enable = true;
    settings.model = {
      provider = "deepseek";
      default = "deepseek-flash";
    };
    environmentFiles = [ "/home/taimoor/.config/hermes/hermes.env" ];
  };

  # Declarative OpenClaw install (nix-openclaw, first-party flake).
  # Runtime state stays outside the store at stateDir below.
  # package: taken from nix-openclaw's own flake output, which builds against the
  # nixpkgs it pins. The overlay build (pkgs.openclaw) compiles against nixpkgs
  # 26.05, whose nodejs 24.21.0 bundles SQLite 3.51.2 -- openclaw 2026.9.5 refuses
  # to start on that ("not WAL-reset-safe"). The pinned build uses nodejs 24.20.0
  # with SQLite 3.53.3 and starts cleanly.
  # Model providers / channels / secrets: add under programs.openclaw.config and
  # programs.openclaw.environment (see the "Secrets" example in the nix-openclaw README).
  programs.openclaw = {
    enable = true;
    package = nix-openclaw.packages.${pkgs.stdenv.hostPlatform.system}.openclaw;
    stateDir = "/home/taimoor/.openclaw";
  };

  # nix-openclaw's module writes ~/.config/systemd/user/openclaw-gateway.service
  # but emits no [Install] section, so the unit is merely "linked" and never
  # enabled -- it stays inactive. This makes it start with the user manager.
  systemd.user.services.openclaw-gateway.Install.WantedBy = [ "default.target" ];

  programs.kitty = {
    enable = true;
    font = {
      name = "FantasqueSansM Nerd Font Mono";
      size = 14;
    };
    themeFile = "Catppuccin-Macchiato";
    settings = {
      enable_audio_bell = false;
      shell_integration = "no-rc";
    };
    keybindings = {
      "ctrl+shift+t" = "launch --cwd=current --type=tab";
    };
  };

  programs.vscode = {
    enable = true;
    package = unstablePkgs.vscode;
  };
}

{ config, pkgs, ... }:

{
  home-manager.users.taimoor = { pkgs, ... }: {
    nixpkgs.config.allowUnfree = true;
    home.stateVersion = "24.05";
    home.packages = with pkgs; [
      htop
      #atop
      #gh
      #kubectl
      #fluxcd
      nodejs_24
      rustup
      ripgrep
      neovim
      clang # for nvim (nvchad plugin requires cc)
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
    ];
    home.sessionVariables = {
      PYENV_ROOT="$HOME/.pyenv";
      # pyenv flags to be able to install Python
      CPPFLAGS="-I${pkgs.zlib.dev}/include -I${pkgs.libffi.dev}/include -I${pkgs.readline.dev}/include -I${pkgs.bzip2.dev}/include -I${pkgs.openssl.dev}/include -I${pkgs.xz.dev}/include";
      CXXFLAGS="-I${pkgs.zlib.dev}/include -I${pkgs.libffi.dev}/include -I${pkgs.readline.dev}/include -I${pkgs.bzip2.dev}/include -I${pkgs.openssl.dev}/include -I${pkgs.xz.dev}/include";
      CFLAGS="-I${pkgs.openssl.dev}/include";
      LDFLAGS="-L${pkgs.zlib.out}/lib -L${pkgs.libffi.out}/lib -L${pkgs.readline.out}/lib -L${pkgs.bzip2.out}/lib -L${pkgs.openssl.out}/lib -L${pkgs.xz.out}";
      CONFIGURE_OPTS="-with-openssl=${pkgs.openssl.dev}";
      #PYENV_VIRTUALENV_DISABLE_PROMPT="1";
    };
    programs.gh = {
      # enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };
    programs.git.enable = true;
    programs.git = {
      userName = "T";
      userEmail = "sysarcher@users.noreply.github.com";
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
    #programs.neovim = {
    #    enable = true;
    #    #defaultEditor = true;
    #    vimAlias = true;
    #    plugins = [
    #      pkgs.vimPlugins.vim-nix
    #      pkgs.vimPlugins.gruvbox
    #    ];
    #    extraConfig = "colorscheme gruvbox";
    #};
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
      settings = {
        enable_audio_bell = false;
      };
    };
  };
}


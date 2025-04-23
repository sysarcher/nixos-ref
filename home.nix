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
      #nodejs_20
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
    ];
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
        plugins = [ "docker-compose" "docker" ];
        theme = "dst";
      };
      initContent = ''
        bindkey '^f' autosuggest-accept
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


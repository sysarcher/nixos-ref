{ config, pkgs, ... }:

{
  home.username = "intel";
  home.homeDirectory = "/home/intel";
  home.stateVersion = "22.11";
  #home.stateVersion = "23.05";

  home.packages = with pkgs; [
    atop
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "docker-compose" "docker" ];
      theme = "dst";
    };
    initExtra = ''
      bindkey '^f' autosuggest-accept
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.vim = {
    enable = true;
    #defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      gruvbox
      vim-airline
    ];
    extraConfig = "colorscheme desert";
  };

  programs.neovim = {
      enable = true;
      #defaultEditor = true;
      #vimAlias = true;
      plugins = [
        pkgs.vimPlugins.vim-nix
        pkgs.vimPlugins.gruvbox
      ];
      extraConfig = "colorscheme gruvbox";
  };
  programs.home-manager.enable = true;
}

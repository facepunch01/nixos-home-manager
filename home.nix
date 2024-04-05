{ config, pkgs, ... }:

{
	# BASIC ENV

	# Setup nixpkgs
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };
  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jake";
  home.homeDirectory = "/home/jake";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Install packages
  home.packages = [

		# For editors
    pkgs.nerdfonts
    pkgs.fd
    pkgs.ripgrep
		
		# Terminal and utils
    pkgs.alacritty
    pkgs.gh
		pkgs.thefuck
		pkgs.eza
		pkgs.bat
		pkgs.shadowsocks-rust
		(pkgs.writeShellScriptBin "shadowself" ''
			sslocal --config shadow.json
		'')
		pkgs.nodejs
		pkgs.corepack

		# Music
		pkgs.flac2all
		pkgs.strawberry
		pkgs.tidal-dl
		pkgs.tidal-hifi
		pkgs.rhythmbox

		# 3D
    pkgs.blender
  ];
	
	# Generic shell setup
  home.sessionVariables = {
    EDITOR = "nvim";
  };
	home.sessionPath = [ "~/.config/emacs/bin" ];

	# PORTING CONFIGS
  
	# Neovim
	programs.neovim.enable = true;
  home.file."${config.xdg.configHome}/nvim" = {
     source = ./nvim;
     recursive = true;
  };

  # Doom
  programs.emacs.enable = true;
  home.file."${config.xdg.configHome}/doom" = {
     source = ./doom;
     recursive = true;
  };

	# ALL NEW CONFIGS

  # Firefox
  programs.firefox = {
    enable = true;
    profiles = {
       jake = {
          id = 0;
          name = "jake";
          settings = {
            "general.smoothScroll" = true;};
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            bitwarden
            tampermonkey
						plasma-integration
						grammarly
          ];
       };
    };
  };

	# Tmux
	programs.tmux = {
		enable = true;
    plugins = with pkgs;
      [
        tmuxPlugins.catppuccin
      ];
	};

	# ZSH
	programs.zsh = {
  	enable = true;
  	enableCompletion = true;
  	enableAutosuggestions = true;
  	syntaxHighlighting.enable = true;

  	shellAliases = {
    	ll = "ls -l";
    	update = "sudo nixos-rebuild switch";
  	};

		initExtra = "eval $(thefuck --alias)";

  	history.size = 10000;
  	history.path = "${config.xdg.dataHome}/zsh/history";
		oh-my-zsh = {
    	enable = true;
    	plugins = [ "git" "thefuck" ];
    	theme = "agnoster";
  	};
	};
	
	# Zoxide
	programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

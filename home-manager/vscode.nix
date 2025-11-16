{ config, pkgs, lib, ... }:

{
  programs.vscode = {
    enable = true;
    userSettings = {
    	"editor.fontFamily" = "Fira Code";
    	"editor.fontLigatures" = true;
    	"editor.fontWeight" = "400";
      "editor.tabSize" = 3;
      "editor.wordWrap" = "on";
      "editor.cursorBlinking" = "expand";
      "editor.linkedEditing" = true;

      "workbench.colorTheme" = "Atomize";
    	"workbench.iconTheme" = "vscode-icons";

      "window.zoomLevel" = 1;
      "explorer.confirmDragAndDrop" = false;
    	"explorer.confirmDelete" = false;
    	"css.lint.unknownAtRules" = "ignore";

      # "vim.camelCaseMotion.enable" = true;
      # "vim.easymotion" = true;
      # "vim.foldfix" = true;
      # "vim.enableNeovim" = true;
      # "vim.useSystemClipboard" = true;

      "svelte.enable-ts-plugin" = true;
    	"svelte.plugin.svelte.format.config.singleQuote" = true;
    	"svelte.plugin.svelte.format.config.svelteAllowShorthand" = false;
    	"editor.defaultFormatter" = "esbenp.prettier-vscode";
    	"[svelte]" = {
    		"editor.defaultFormatter" = "svelte.svelte-vscode";
    	};

    	"prettier.singleQuote" = true;
    	"prettier.tabWidth" = 3;
    	"prettier.useTabs" = true;
      "prettier.semi" = false;

    	"emmet.triggerExpansionOnTab" = true;
    	"emmet.useInlineCompletions" = true;

      "files.autoSave" = "afterDelay";
    	"files.associations" = { "*html" = "html"; };
      "files.exclude" = {
        "node_modules" = true;
      };
    };
    keybindings = [
      {
        key = "cmd+c";
        command = "editor.action.clipboardCopyAction";
        when = "textInputFocus";
      }
    ];
    extensions = with pkgs.vscode-extensions; [
      # lang
      ms-python.python
      ms-python.vscode-pylance # separately install?
      svelte.svelte-vscode
      astro-build.astro-vscode
      rust-lang.rust-analyzer
      bradlc.vscode-tailwindcss
      davidanson.vscode-markdownlint

      # tools
      ms-vscode.live-server
      esbenp.prettier-vscode
      formulahendry.auto-rename-tag
      naumovs.color-highlight
      # dbaeumer.vscode-eslint
      # ms-vsliveshare.vsliveshare
      # vscodevim.vim

      # emroussel.atomize-atom-one-dark-theme
      # vscode-icons-team.vscode-icons

      # git
      eamodio.gitlens
      github.copilot
      github.copilot-chat # careful
    ];
  };
}

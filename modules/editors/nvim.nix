# Configuration for nvim
{config, lib, system, pkgs, stable, ... }:

let 
	# Create the danish keymappings
	movementMappings = [
	  { from = "j"; to = "h"; }
	  { from = "k"; to = "j"; }
	  { from = "l"; to = "k"; }
	  { from = "æ"; to = "l"; }
	];

	modes = [ "n" "v" "o" ];

	# wrap the keymappings
	keymaps_func = builtins.concatLists (builtins.map
		(mode: builtins.map
			(mapping: {
				inherit mode;
				key = mapping.from;
				action = mapping.to;
				options = { noremap = true; silent = true; };
			})
			movementMappings)
		modes);
in
{
  environment = {
    systemPackages = with pkgs; [
      ripgrep
      (python3.withPackages (ps: with ps; [
        pip
      ]))
    ];
  };

  programs.nixvim = {
    enable = true;
    enableMan = false;
    viAlias = true;
    vimAlias = true;
    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 4;
      tabstop = 4;
      autoindent = true;
      fileencoding = "utf-8";
      cursorline = false;
      spelllang = [ "en" "dk" ];
	  smartindent = true;
	  wrap = false;
	  swapfile = false;
	  backup = false;
	  undofile = true;
	  hlsearch = false;
	  incsearch = true;
	  termguicolors = true;
	  scrolloff = 8;
	  signcolumn = "yes";
	  updatetime = 50;
	  colorcolumn = "80";
	  # textwidth = 80;
    };

    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };

	globals = {
		mapleader = " ";
		maplocalleader = " ";
	};

	

	keymaps = keymaps_func ++ 
	[
		{
			key = "<leader>e";
			action = ":Ex<CR>";
		}
		{ # allows us to move lines up and down in visual mode with J and K
			mode = "v";
			key = "K";
			action = ":m '>+1<CR>gv=gv"; 
		}
		{ # allows us to move lines up and down in visual mode with J and K
			mode = "v";
			key = "L";
			action = ":m '>-2<CR>gv=gv"; 
		}
		{ # makes J ergonomic
			key = "J";
			action = "mzJ`z"; 
		}
		{ # keeps us centered when we do page up and down
			key = "<C-d>";
			action = "<C-d>zz"; 
		}
		{ # keeps us centered when we do page up and down
			key = "<c-u>";
			action = "<c-u>zz"; 
		}
		{ # keeps us centered when we search
			key = "N";
			action = "Nzzzv"; 
		}
		{ # keeps us centered when we search
			key = "N";
			action = "nzzzv"; 
		}
		{ # apparently this makes me a n00b
			key = "<C-c>";
			action = "<Esc>l"; 
			mode = "i";
		}
		{ # search and replace current word
			key = "<leader>s";
			action = "[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]"; 
		}
		{ # search and replace current word and down
			key = "<leader>sd";
			action = "[[:.,$s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]"; 
		}
		{ # search and replace current word and down
			key = "<leader>su";
			action = "[[:0,.$s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]"; 
		}
		{ # search and replace current word and down
			key = "<leader>w";
			action = ":w<CR>"; 
		}
		{ # search and replace current word and down
			key = "<leader>q";
			action = ":q<CR>"; 
		}
		{
			key = "<C-w>j";
			action = "<C-w>h";
		}
		{
			key = "<C-w>k";
			action = "<C-w>j";
		}
		{
			key = "<C-w>l";
			action = "<C-w>k";
		}
		{
			key = "<C-w>æ";
			action = "<C-w>l";
		}
		{
			mode = "i";
			key = "<C-j>";
			action = "<BS>";
		}
		{
			mode = "i";
			key = "<C-k>";
			action = "<NL>";
		}
		{
			mode = "i";
			key = "<C-l>";
			action = "<C-o>O";
		}
		{
			mode = "i";
			key = "<C-æ>";
			action = "<Del>";
		}
	];

	plugins = {
		harpoon = {
			enable = true;
		};
	};

  extraConfigLua = ''
		local harpoon = require("harpoon")
		harpoon:setup()

		
		vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
		vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

		vim.keymap.set("n", "<C-j>", function() harpoon:list():select(1) end)
		vim.keymap.set("n", "<C-k>", function() harpoon:list():select(2) end)
		vim.keymap.set("n", "<C-l>", function() harpoon:list():select(3) end)
		vim.keymap.set("n", "<C-æ>", function() harpoon:list():select(4) end)
  '';
  };

}

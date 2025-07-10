# Configuration for nvim
{config, lib, system, pkgs, stable, ... }:

{
  environment.systemPackages = with pkgs; [
      ripgrep
      (python3.withPackages (ps: with ps; [
        pip
      ]))
  ];

  programs.nixvim = {
	colorschemes.catppuccin = {
		enable = true;
		settings.transparent_background = true;
	};
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
      spelllang = [ "en" ];
	  smartindent = true;
	  wrap = false;
	  swapfile = true;
	  backup = false;
	  undofile = true;
	  hlsearch = false;
	  incsearch = true;
	  termguicolors = true;
	  scrolloff = 8;
	  signcolumn = "yes";
	  breakindent = true;
	  updatetime = 50;
	  colorcolumn = "80";
	  # textwidth = 80;
    };

    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };

	diagnostic.settings = {
		virtual_text = true;
		signs = true;
		underline = true;
		update_in_insert = true;
	};

	globals = {
		mapleader = " ";
		maplocalleader = " ";
	};

	

	keymaps = 
	[
		{
			key = "<leader>e";
			action = ":Ex<CR>";
		}
		{
			key = "<leader>cp";
			action = ":lua require('copilot.suggestion').toggle_auto_trigger()<CR>";
		}
		/* {  in order for our cursor to move with the line as we indent it we 
		   must do >>^^
			mode = "n";
			key = "<S-tab>";
			action = "<<^^";
		}
		{  in order for our cursor to move with the line as we indent it we 
		   must do >>^^
			mode = "n";
			key = "<tab>";
			action = ">>^^";
		} */
		{
			mode = "v";
			key = "<S-tab>";
			action = "<gv";
		}
		{
			mode = "v";
			key = "<tab>";
			action = ">gv";
		}
		{
			key = "½";
			action = ":split v<cr>";
		}
		{ # allows us to move lines up and down in visual mode with j and k
			mode = "v";
			key = "J";
			action = ":m '>+1<CR>gv=gv"; 
		}
		{ # allows us to move lines up and down in visual mode with J and K
			mode = "v";
			key = "K";
			action = ":m '<-2<CR>gv=gv"; 
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
		{ # search and replace current word and up
			key = "<leader>su";
			action = "[[:0,.$s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]"; 
		}
		{ 
			key = "<leader>w";
			action = ":w<CR>"; 
		}
		{ 
			key = "<leader>q";
			action = ":q<CR>"; 
		}
		{
			mode = "i";
			key = "<C-k>";
			action = "<C-o>O";
		}
		{
			mode = "i";
			key = "<C-l>";
			action = "<Del>";
		}
	];

	plugins = {
		# Red lines and stuff
		lsp = {
			enable = true;
			servers = {
				ts_ls.enable = true;
			};
		};
		# Autocomplete
		cmp = {
			enable = true;
			autoEnableSources = true;
			settings = { 
				sources = [ 
					{ name = "nvim_lsp"; }
					{ name = "path"; }
					{ name = "buffer"; }
				];
			};
		};
		conform-nvim = {
			enable = true;
			settings = {
				formatters_by_ft = {
					typescript = [ "prettierd" ];
					javascript = [ "prettierd" ];
					python = [ "isort" "black" ];
					nix = [ "nixpkgs-fmt" ];
				};
				format_on_save = ''
					function(bufnr)
						if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
							return
						end
							return { timeout_ms = 1000, lsp_fallback = true }, on_format
						end
				'';
			};
		};
		lint = {
			enable = true;
			lintersByFt = {
				javascript = [ "eslint_d" ];
				typescript = [ "eslint_d" ];
				python = [ "pylint" ];
			};
		};
		
		toggleterm = {
			enable = true;
			settings = {
				autoScroll = true;
				closeOnExit = true;
				direction = "horizontal";
				persistMode = true;
				startInInsert = true;
				open_mapping = "[[<C-t>]]";
			};
		};

		copilot-lua = {
			enable = true;
			settings = {
				suggestions = {
				enabled = true;
				keymap.accept = "<M-l>";
				};
				panel = {
					enabled = false;
					auto_refresh = false;
				};
				filetypes.markdown = true;
				# filetypes.pluginDefault.markdown = true;
			};
		};
		
		telescope = {
			enable = true;
			settings = {
				pickers.find_files = {
					hidden = true;
				};
			};
			keymaps = {
				"<leader>ff" = {
					action = "find_files";
					options = {
						desc = "Find File";
					};
				};
				"<leader>fg" = {
					action = "live_grep";
					options = {
						desc = "Find Via Grep";
					};
				};
				"<leader>fb" = {
					action = "buffers";
					options = {
						desc = "Find Buffers";
					};
				};
			};
		};
		nvim-autopairs.enable = true;
		lualine.enable = true;
		comment.enable = true;
		treesitter.enable = true; # used for code highlighting
		web-devicons.enable = true; # This is needed for telescope apparently
		harpoon.enable = true;
		fugitive.enable = true;
	};

    extraConfigLua = ''
		-- Textwrap 
		vim.api.nvim_create_autocmd("FileType", {
		  pattern = { "markdown", "text", "tex", "plaintex" },
		  callback = function()
		  	-- vim.cmd("setlocal spell spelllang=en_us")
			vim.keymap.set("n", "j", "gj", { buffer = true })
			vim.keymap.set("n", "k", "gk", { buffer = true })
			vim.opt_local.wrap = true
			vim.opt_local.linebreak = true
			vim.opt_local.list = false
		  end,
		})

		-- Harpoon shit
	  	local harpoon = require("harpoon")
		harpoon:setup()
		vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
		vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
		vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
		vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end)
		vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end)
		vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end)


		-- This is chatgpt shit, it sets up <leader>r to run the current file
		-- It also figures out what command to run
		function RunFile()
		  local filetype = vim.bo.filetype
		  local filename = vim.fn.expand("%")
		  local cmd = ""

		  if filetype == "python" then
			cmd = "python3 " .. filename
		  elseif filetype == "tex" then
			cmd = "xelatex " .. filename
		  elseif filetype == "plaintex" then
			cmd = "xelatex " .. filename
		  elseif filetype == "c" then
			cmd = "gcc " .. filename .. " -o output && ./output"
		  else
			print("No run command defined for " .. filetype)
			return
		  end

		  -- Create a new terminal buffer
		  vim.cmd("!" .. cmd)
		end

		vim.keymap.set("n", "<leader>r", RunFile, { noremap = true, silent = true })


  '';
  };

}

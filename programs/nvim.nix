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
      spelllang = [ "en" "dk" ];
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
			key = "K";
			action = ":m '>+1<CR>gv=gv"; 
		}
		{ # allows us to move lines up and down in visual mode with J and K
			mode = "v";
			key = "L";
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
		#lua require("copilot.suggestion").toggle_auto_trigger()
		
		lualine.enable = true;
		comment.enable = true;
		treesitter.enable = true; # used for code highlighting
		telescope.enable = true;
		web-devicons.enable = true; # This is needed for telescope apparently
		harpoon.enable = true;
		fugitive.enable = true;
	};

    extraConfigLua = ''

		-- Telescope configs
		-- These allows us to move up and down in normal mode during find_files
		local actions = require("telescope.actions")
		require("telescope").setup({
		  defaults = {
			mappings = {
			  n = { -- normal mode
				["k"] = actions.move_selection_next,
				["l"] = actions.move_selection_previous,
			  },
			},
		  },
		})
		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
		vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
		vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
		vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })


		-- Harpoon shit
	  	local harpoon = require("harpoon")
		harpoon:setup()
		vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
		vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
		vim.keymap.set("n", "<C-j>", function() harpoon:list():select(1) end)
		vim.keymap.set("n", "<C-k>", function() harpoon:list():select(2) end)
		vim.keymap.set("n", "<C-l>", function() harpoon:list():select(3) end)
		vim.keymap.set("n", "<C-æ>", function() harpoon:list():select(4) end)


		-- This is chatgpt shit, it sets up <leader>r to run the current file
		-- It also figures out what command to run
		function RunFile()
		  local filetype = vim.bo.filetype
		  local filename = vim.fn.expand("%")
		  local cmd = ""

		  if filetype == "python" then
			cmd = "python3 " .. filename
		  elseif filetype == "tex" then
			local output_pdf = filename:gsub("%.tex$", ".pdf")
			cmd = "xelatex " .. filename .. " && (xdg-open " .. output_pdf .. " &)"
			-- For macOS, replace with: open <file>.pdf
		  elseif filetype == "c" then
			cmd = "gcc " .. filename .. " -o output && ./output"
		  else
			print("No run command defined for " .. filetype)
			return
		  end

		  -- Check if terminal already exists
		  if runner_bufnr and vim.api.nvim_buf_is_valid(runner_bufnr) then
			vim.api.nvim_chan_send(vim.b.terminal_job_id, cmd .. "\n")
		  else
			vim.cmd("belowright split | terminal")
			runner_bufnr = vim.api.nvim_get_current_buf()
			vim.b.terminal_job_id = vim.b.terminal_job_id or vim.fn.jobstart("/bin/bash", {detach = true})
			vim.api.nvim_chan_send(vim.b.terminal_job_id, cmd .. "\n")
		  end
		end

		vim.keymap.set("n", "<leader>r", ":lua RunFile()<CR>")

  '';
  };

}

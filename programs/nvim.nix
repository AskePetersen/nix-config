# Configuration for nvim
{ config, lib, system, pkgs, stable, ... }:

{
  environment.systemPackages = with pkgs; [
    ripgrep
    nixpkgs-fmt
    # WAKE ME UP WHEN SEPTEMBER ENDS
    # (python3.withPackages (ps: with ps; [
    #	 pip
    # ]))
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
      sidescrolloff = 20; # horizontally allignment
      expandtab = false;
      softtabstop = 2;
      smartindent = true;
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      autoindent = true;
      fileencoding = "utf-8";
      cursorline = false;
      spelllang = [ "en" ];
      wrap = false;
      swapfile = true;
      backup = false;
      undofile = true;
      hlsearch = true;
      incsearch = false; # Neovim jumps to the first match immediately
      termguicolors = true;
      scrolloff = 8;
      signcolumn = "yes";
      breakindent = true;
      updatetime = 50;
      colorcolumn = "80";
      # textwidth = 80;
      foldenable = true;
      guicursor = "i:block";
    };

    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    # Red squiggly lines
    virtual_text = true;
    diagnostic.settings = {
      signs = true;
      underline = true;
      update_in_insert = true;
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>u";
        action = ":UndotreeToggle<CR>";
      }
      {
        mode = "i";
        key = "<C-h>";
        action = "<BS>";
      }
      {
        key = "<leader>n";
        action = "<CMD>Neotree toggle<CR>";
        options.desc = "Toggle NeoTree";
      }
      {
        key = "<leader>cp";
        action = ":lua require('copilot.suggestion').toggle_auto_trigger()<CR>";
      }
      {
        mode = "n";
        key = "gd";
        action = "<CMD>lua vim.lsp.buf.hover()<CR>zz";
        options.desc = "Show lsp definition in floating window";
      }
      {
        mode = "n";
        key = "gD";
        action = "<CMD>lua vim.lsp.buf.definition()<CR>";
        options.desc = "Load lsp definition in new buffer";
      }
      {
        mode = "n";
        key = "gr";
        action = "<CMD>lua vim.lsp.buf.references()<CR>";
        options.desc = "Show lsp references";
      }
      {
        mode = "n";
        key = "ge";
        action = "<CMD>lua vim.diagnostic.open_float()<CR>";
        options.desc = "Show lsp diagnostic in floating window";
      }
      {
        mode = "n";
        key = "<leader>rn";
        action = "<CMD>lua vim.lsp.buf.rename()<CR>";
        options.desc = "Rename variable, function etc. across entire project";
      }
      {
        mode = "n";
        key = "<leader>ca";
        action = "<CMD>lua vim.lsp.buf.code_action()<CR>";
        options.desc = "vim.lsp.buf.code_action() opens a menu showing available code actions at the current cursor position.";
      }
      {
        mode = "n";
        key = "<leader>k";
        action = "<CMD>lua vim.diagnostic.goto_prev()<CR>";
        options.desc = "jump to previous error";
      }
      {
        mode = "n";
        key = "<leader>j";
        action = "<CMD>lua vim.diagnostic.goto_next()<CR>";
        options.desc = "jump to next error";
      }
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
      {
        # allows us to move lines up and down in visual mode with j and k
        mode = "x";
        key = "J";
        action = ":m '>+1<CR>gv=gv";
        options = {
          silent = true;
          noremap = true;
        };
      }
      {
        # allows us to move lines up and down in visual mode with J and K
        mode = "x";
        key = "K";
        action = ":m '<-2<CR>gv=gv";
        options = {
          silent = true;
          noremap = true;
        };
      }
      # { # makes J ergonomic
      # 	key = "J";
      # 	action = "mzJ`z"; 
      # }
      {
        # keeps us centered when we do jump back
        key = "<C-o>";
        action = "<C-o>zz";
      }
      {
        # keeps us centered when we do jump ahead
        key = "<C-i>";
        action = "<C-i>zz";
      }
      {
        # keeps us centered when we do page up and down
        key = "<C-d>";
        action = "<C-d>zz";
      }
      {
        # keeps us centered when we do page up and down
        key = "<c-u>";
        action = "<c-u>zz";
      }
      {
        # keeps us centered when we search
        key = "N";
        action = "Nzzzv";
      }
      {
        # keeps us centered when we search
        key = "n";
        action = "nzzzv";
      }
      {
        # keeps us centered when we search
        key = "[";
        action = "[zzzv";
      }
      {
        # keeps us centered when we search
        key = "]";
        action = "]zzzv";
      }
      {
        # keeps us centered when we search
        key = "{";
        action = "{zzzv";
      }
      {
        # keeps us centered when we search
        key = "}";
        action = "}zzzv";
      }
      {
        # keeps us centered when we search
        key = "[m";
        action = "[mzzzv";
      }
      {
        # keeps us centered when we search
        key = "]m";
        action = "]mzzzv";
      }
      {
        # apparently this makes me a n00b
        key = "<C-c>";
        action = "<Nop>";
        mode = "i";
      }
      {
        key = "<Esc>";
        action = "<Esc>l";
        mode = "i";
      }
      {
        mode = "v";
        key = "/";
        action = ''"zy/<C-r>z'';
        options.desc = "Search for visual selection (no auto-execute)";
      }
      {
        mode = "v";
        key = "?";
        action = ''"zy?<C-r>z'';
        options.desc = "Reverse search for visual selection (no auto-execute)";
      }
      {
        # Better paste in visual mode - doesn't overwrite the paste register
        mode = "v";
        key = "p";
        action = ''"_dP'';
        options.desc = "Paste without overwriting register";
      }
      {
        # Better paste in visual mode - doesn't overwrite the paste register
        mode = "v";
        key = "P";
        action = ''"_dp'';
        options.desc = "Paste without overwriting register";
      }
      {
        # search and replace current word
        key = "<leader>s";
        action = ":%s/<C-r><C-w>//gI<Left><Left><Left>";
      }
      {
        # search and replace current word and down
        key = "<leader>sd";
        action = ":.,$s/<C-r><C-w>//gI<Left><Left><Left>";
      }
      {
        # search and replace current word and up
        key = "<leader>su";
        action = ":0,.$s/<C-r><C-w>//gI<Left><Left><Left>";
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
        # We want to disable default C-n in order to use nvim-cmp instead
        mode = "i";
        key = "<C-n>";
        action = "<Nop>";
      }
      {
        # We want to disable default C-n in order to use nvim-cmp instead
        mode = "i";
        key = "<C-p>";
        action = "<Nop>";
      }
      {
        mode = "i";
        key = "<C-l>";
        action = "<Del>";
      }
      {
        # Display current file in bufer?
        mode = "n";
        key = "<leader>fp";
        action = "<CMD>let @+ = expand('%:p')<CR><CMD>echo expand('%:p')<CR>";
      }
      {
        key = "<leader>rv";
        action = "<CMD>Neotree reveal<CR>";
        options.desc = "Reveal NeoTree";
      }
      {
        mode = "n";
        key = "<leader>gg";
        action = "<CMD>:LazyGit<CR>";
        options.desc = "Lazygit open";
      }
      {
        mode = "i";
        key = "<Up>";
        action = "<Nop>";
      }
      {
        mode = "n";
        key = "<S-Up>";
        action = "<Nop>";
      }
      {
        mode = "n";
        key = "<S-Down>";
        action = "<Nop>";
      }
      {
        mode = "i";
        key = "<S-Up>";
        action = "<Nop>";
      }
      {
        mode = "i";
        key = "<S-Down>";
        action = "<Nop>";
      }
      {
        mode = "i";
        key = "<Down>";
        action = "<Nop>";
      }
    ];

    plugins = {
      # vertical lines when indenting
      indent-blankline = {
        enable = true;
        settings = {
          scope.enabled = false;
          # indent.highlight = "ibl-lines";
        };
      };
      # The sweet sweet coconut oil LSP
      lsp = {
        enable = true;
        servers = {
          ts_ls.enable = true; # lsp server for typescript
          pyright.enable = true; # lsp server for python
          intelephense = {
            # lsp server for python
            enable = true;
            package = null;
          };
        };
      };
      # AI - at some point when i get an api key
      # avante = {
      #	 enable = true;
      # };
      # Autocomplete
      render-markdown = {
        enable = true;
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          mapping = {
            "<C-n>" = "cmp.mapping.select_next_item()";
            "<C-p>" = "cmp.mapping.select_prev_item()";
          };
        };
      };
      # View a file explorer
      neo-tree = {
        enable = true;
        settings = {
          window.width = 35;
          close_if_last_window = true;
          extraOptions = {
            filesystem = {
              filtered_items = {
                visible = true;
              };
            };
          };
        };
      };
      # Linters for neovim
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            typescript = [ "prettier" ];
            scss = [ "prettier" ];
            htmlangular = [ "prettier" ];
            html = [ "prettier" ];
            javascript = [ "prettier" ];
            python = [ "isort" "black" ];
            nix = [ "nixpkgs_fmt" ];
          };
          format_on_save = {
            timeout_ms = 2000;
            lsp_fallback = true;
          };
        };
      };
      lint = {
        enable = true;
        lintersByFt = {
          javascript = [ "eslint" ];
          typescript = [ "eslint" ];
          python = [ "pylint" ];
        };
      };

      copilot-lua = {
        enable = true;
        settings = {
          panel.enable = false; # don't show suggestions like cmp does.
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
      lazygit.enable = true;
      fugitive.enable = true;
      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add = { text = "+"; };
            change = { text = "~"; };
            delete = { text = "-"; };
            topdelete = { text = "-"; };
            changedelete = { text = "~"; };
            untracked = { text = "x"; };
          };
          signs_staged = {
            add = { text = "+"; };
            change = { text = "~"; };
            delete = { text = "-"; };
            topdelete = { text = "-"; };
            changedelete = { text = "~"; };
            untracked = { text = "x"; };
          };
        };
      };

      telescope = {
        enable = true;
        settings = {
          defaults = {
            path_display = [ "absolute" ];
          };
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
      nvim-autopairs = {
        enable = true;
        settings = {
          enable_check_bracket_line = false;
          map_c_h = true; # Make C-h also delete pairs like backspace
        };
      };
      lualine = {
        enable = true;
      };
      comment.enable = true;
      treesitter.enable = true; # used for code highlighting
      web-devicons.enable = true; # This is needed for telescope apparently
      harpoon.enable = true;
      undotree.enable = true;
    };

    extraConfigLua = ''
            			-- Lualine config
            			require('lualine').setup({
            			options = {
            			disabled_filetypes = {
            			statusline = { 'neo-tree' }
            			},
            			},
            			sections = {
            			lualine_x = {},
            			},
            			})

            			-- Automatically input what i've selected and insert it in telescope.
            			vim.keymap.set('v', '<leader>fg', function()
            			local text = vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.'), {type = vim.fn.mode()})
            			require('telescope.builtin').live_grep({ default_text = table.concat(text, '\n') })
            			end, { desc = "Grep for visual selection" })

            			vim.keymap.set('v', '<leader>ff', function()
            			local text = vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.'), {type = vim.fn.mode()})
            			require('telescope.builtin').find_files({ default_text = table.concat(text, '\n') })
            			end, { desc = "Find files with visual selection" })


            			-- Textwrap 
            			vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
      							pattern = { "*.md", "*.txt", "*.tex", "*.log" },
      							callback = function()
      								-- vim.cmd("setlocal spell spelllang=en_us")
      								vim.opt_local.wrap = true
      								vim.opt_local.linebreak = true
      								vim.opt_local.list = false
      							end,
            			})

            			-- Random keybindings
            			vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })

            			-- Harpoon shit
            			local harpoon = require("harpoon")
            			harpoon:setup()
            			vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
            			vim.keymap.set("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
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



            			vim.treesitter.language.register("html", "htmlangular")
            			vim.o.foldmethod = "indent"
            			vim.o.foldenable = true
            			vim.o.foldlevel = 99
            			vim.o.foldlevelstart = 99
            			'';
  };

}

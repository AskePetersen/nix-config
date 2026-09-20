# Configuration for nvim
{ config, lib, system, pkgs, inputs, ... }:

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
    # We deliberately pin nixvim to our own nixpkgs (inputs.nixvim.inputs.nixpkgs.follows
    # in flake.nix); stating it here suppresses nixvim's "affected by follows" warning.
    nixpkgs.source = inputs.nixpkgs;

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
    diagnostic.settings = {
      virtual_text = true;
      signs = true;
      underline = true;
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>gb";
        action = "<CMD>Gitsigns blame_line<CR>";
        options.desc = "Git blame line (popup)";
      }
      {
        mode = "n";
        key = "<leader>gB";
        action = "<CMD>Gitsigns blame<CR>";
        options.desc = "Git blame file";
      }
      {
        mode = "n";
        key = "<leader>u";
        action = ":UndotreeToggle<CR>";
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
        action = "<CMD>lua vim.lsp.buf.definition()<CR>zz";
        options.desc = "Load lsp definition in new buffer";
      }
      {
        mode = "n";
        key = "gI";
        action = "<CMD>lua vim.lsp.buf.implementation()<CR>";
        options.desc = "Implementation";
      }
      {
        mode = "n";
        key = "<leader>D";
        action = "<CMD>lua vim.lsp.buf.type_definition()<CR>";
        options.desc = "Type definition";
      }
      {
        mode = "n";
        key = "gD";
        action = "<CMD>lua vim.lsp.buf.hover()<CR>";
        options.desc = "open lsp definition in floating window";
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
        # search and replace current word (\\< \\> = whole-word boundaries)
        key = "<leader>s";
        action = ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI";
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
      # Window navigation (<C-hjkl>) is provided by vim-tmux-navigator,
      # which crosses seamlessly between nvim splits and tmux panes.
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
      tmux-navigator.enable = true; # move between windows with <c-hjkl> tmux and nvim windows
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
          nixd = {
            enable = true; # for nix files
            settings.nixd.formatting.command = [ "nixpkgs-fmt" ];
          };
          vtsls = {
            enable = true; # lsp server for typescript
            settings.typescript.inlayHints = {
              parameterNames.enabled = "all";
              variableTypes.enabled = true;
              functionLikeReturnTypes.enabled = true;
            };
          };
          angularls = {
            enable = true;
          };
        };
      };

      # Autocomplete
      render-markdown = {
        enable = true;
      };

      # autoclose html tags
      ts-autotag = {
        enable = true;
      };

      # To do daa to delete around a parameter a dif to delete in a function
      treesitter-textobjects = {
        autoLoad = true;
        enable = true;
        settings = {
          move = {
            enable = true;
            set_jumps = true; # push jumps to the jumplist so <C-o>/<C-i> come back
            goto_next_start = {
              "]f" = "@function.outer";
              "]a" = "@parameter.inner";
            };
            goto_previous_start = {
              "[f" = "@function.outer";
              "[a" = "@parameter.inner";
            };
          };
          select =
            {
              enable = true;
              keymaps = {
                "if" = "@function.inner";
                "af" = "@function.outer";
                "ia" = "@parameter.inner";
                "aa" = "@parameter.outer";
              };
            };
        };
      };

      # used in cmp
      luasnip = {
        enable = true;
        fromVscode = [ ];
      };

      # autocomplete 
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
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
          filesystem = {
            hijack_netrw_behavior = "disabled";
            filtered_items = {
              visible = true;
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

      copilot-lua = {
        enable = true;
        settings = {
          # `enabled`, not `enable` - this is passed straight through to
          # copilot.lua's setup(), which ignores keys it doesn't know.
          panel.enabled = false; # don't show suggestions like cmp does.
          suggestion = {
            enabled = true;
            keymap.accept = "<M-l>";
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

    extraConfigLua =
      ''-- Lualine config
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

				-- Harpoon shit
				local harpoon = require("harpoon")
				harpoon:setup()
				for i = 1, 4 do -- set harpoon to <alt-1/2/3/4> such that we have c-h/j/k/l for window navigation
					vim.keymap.set("n", "<M-" .. i .. ">", function()
						harpoon:list():select(i)
					end, { desc = "Harpoon file " .. i })
				end
				vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
				vim.keymap.set("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
				vim.treesitter.language.register("html", "htmlangular") -- used to tell the editor that when the file is htmlangular you do html linting'';
  };
}

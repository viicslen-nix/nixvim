{
  pkgs,
  lib,
  laravel-nvim,
  worktrees-nvim,
  neotest-pest,
  mcphub-nvim,
  mcp-hub,
  phpantom-lsp,
  ...
}: {
  # Import keybinds module
  imports = [
    ./keybinds.nix
  ];

  # Core Neovim options
  opts = {
    number = true;
    relativenumber = true;
    shiftwidth = 4;
    tabstop = 4;
    expandtab = true;
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
    mouse = "a";
    clipboard = "unnamedplus";
    cursorline = true;
    splitbelow = true;
    splitright = true;
  };

  # Global settings
  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };

  # Autocommands
  autoGroups = {
    eslint_fix = {clear = true;};
  };

  autoCmd = [
    {
      group = "eslint_fix";
      event = ["BufWritePre"];
      pattern = ["*.js" "*.jsx" "*.ts" "*.tsx" "*.vue"];
      callback.__raw = ''
        function()
          -- Only run EslintFixAll if the command exists (ESLint LSP is attached)
          if vim.fn.exists(":EslintFixAll") > 0 then
            vim.cmd("EslintFixAll")
          end
        end
      '';
    }
  ];

  # Colorscheme - OneDark darker with transparency
  colorschemes = {
    onedark = {
      enable = true;
      settings = {
        style = "darker";
        transparent = true;
        term_colors = true;
        ending_tildes = false;
        cmp_itemkind_reverse = false;
        code_style = {
          comments = "italic";
          keywords = "none";
          functions = "none";
          strings = "none";
          variables = "none";
        };
        lualine = {
          transparent = true;
        };
        diagnostics = {
          darker = true;
          undercurl = true;
          background = true;
        };
      };
    };
  };

  # ===== LSP Configuration (native vim.lsp API) =====
  lsp.servers = {
    # Nix
    nil_ls = {
      enable = true;
      config.settings.nil.formatting.command = ["alejandra"];
    };

    # TypeScript/JavaScript
    ts_ls = {
      enable = true;
      config = {
        filetypes = [
          "javascript"
          "javascriptreact"
          "javascript.jsx"
          "typescript"
          "typescriptreact"
          "typescript.tsx"
          "vue"
        ];
        init_options.plugins = [
          {
            name = "@vue/typescript-plugin";
            location = "${pkgs.vue-language-server}/lib/language-tools/packages/typescript-plugin";
            languages = ["javascript" "typescript" "vue"];
          }
        ];
      };
    };

    # Vue - always hybrid mode since v3.0.0 (no hybridMode option needed)
    # vue_ls handles CSS/HTML, ts_ls + @vue/typescript-plugin handles TypeScript
    vue_ls = {
      enable = true;
      config.filetypes = ["vue"];
    };

    # Python
    pyright.enable = true;

    # Go
    gopls.enable = true;

    # Lua
    lua_ls = {
      enable = true;
      config.settings.Lua = {
        diagnostics.globals = ["vim"];
        workspace.checkThirdParty = false;
        telemetry.enable = false;
      };
    };

    # Bash
    bashls.enable = true;

    # HTML
    html.enable = true;

    # CSS
    cssls.enable = true;

    # Tailwind CSS
    tailwindcss.enable = true;

    # ESLint (diagnostics and autofix)
    eslint = {
      enable = true;
      config.settings = {
        workingDirectories = {mode = "auto";};
        codeActionOnSave = {
          enable = true;
          mode = "all";
        };
      };
    };

    # Terraform/HCL
    terraformls.enable = true;

    # Markdown
    marksman.enable = true;

    # SQL
    sqls.enable = true;

    # C/C++
    clangd.enable = true;

    # Zig
    zls.enable = true;
  };

  # All plugins configuration
  plugins = {
    # ===== Syntax & Parsing =====

    # TreeSitter
    treesitter = {
      enable = true;
      settings = {
        auto_install = true;
        ensure_installed = [
          "bash"
          "c"
          "cpp"
          "css"
          "dockerfile"
          "go"
          "hcl"
          "html"
          "javascript"
          "json"
          "lua"
          "markdown"
          "markdown_inline"
          "nix"
          "php"
          "python"
          "rust"
          "sql"
          "terraform"
          "tsx"
          "typescript"
          "vim"
          "vimdoc"
          "vue"
          "yaml"
          "zig"
        ];
        highlight = {
          enable = true;
          additional_vim_regex_highlighting = false;
        };
        indent = {
          enable = true;
        };
      };
    };

    treesitter-context.enable = true;

    # ===== Language Server Protocol (LSP) =====

    # Default configuration for LSP servers
    lspconfig.enable = true;

    # Lspsaga
    lspsaga = {
      enable = true;
      settings.ui.border = "rounded";
    };

    # ===== Navigation & Search =====

    # Telescope
    telescope = {
      enable = true;
      settings = {
        defaults = {
          file_ignore_patterns = [
            "node_modules"
            ".git/"
            "vendor/"
          ];
          layout_config = {
            horizontal = {
              preview_width = 0.55;
            };
          };
        };
        pickers = {
          find_files = {
            hidden = true;
            no_ignore = false;
          };
        };
      };
      extensions = {
        fzf-native.enable = true;
      };
    };

    # ===== UI Components =====

    # Bufferline
    bufferline = {
      enable = true;
      settings = {
        options = {
          mode = "buffers";
          diagnostics = "nvim_lsp";
          separator_style = "slant";
          show_buffer_close_icons = true;
          show_close_icon = false;
          always_show_bufferline = true;
          offsets = [];
        };
      };
    };

    # Lualine
    lualine = {
      enable = true;
      settings = {
        options = {
          theme = "onedark";
          globalstatus = true;
          component_separators = {
            left = "|";
            right = "|";
          };
          section_separators = {
            left = "";
            right = "";
          };
        };
        sections = {
          lualine_a = ["mode"];
          lualine_b = ["branch" "diff" "diagnostics"];
          lualine_c = ["filename"];
          lualine_x = [
            "lsp_status"
            "encoding"
            "fileformat"
            "filetype"
          ];
          lualine_y = ["progress"];
          lualine_z = ["location"];
        };
      };
    };

    # Alpha dashboard
    alpha = {
      enable = true;
      theme = "dashboard";
    };

    # Which-key
    which-key = {
      enable = true;
      settings = {
        preset = "helix";
      };
    };

    # Notify
    notify = {
      enable = true;
      settings = {
        background_colour = "#000000";
        render = "compact";
        stages = "fade";
        timeout = 3000;
      };
    };

    # Indent blankline
    indent-blankline.enable = true;

    # Web devicons
    web-devicons.enable = true;

    # Illuminate (highlight word under cursor)
    illuminate.enable = true;

    # Colorizer (color preview)
    colorizer.enable = true;

    # Trouble (diagnostics list)
    trouble.enable = true;

    # ===== Editing Enhancements =====

    # Comment
    comment.enable = true;

    # Autopairs
    nvim-autopairs.enable = true;

    # Leap (motion)
    leap.enable = true;

    # Surround
    nvim-surround.enable = true;

    # ===== Git Integration =====

    # Gitsigns
    gitsigns = {
      enable = true;
      settings = {
        current_line_blame = false;
        signs = {
          add = {text = "│";};
          change = {text = "│";};
          delete = {text = "_";};
          topdelete = {text = "‾";};
          changedelete = {text = "~";};
        };
      };
    };

    # Fugitive
    fugitive.enable = true;

    # Git conflict
    git-conflict.enable = true;

    # Gitlinker
    gitlinker.enable = true;

    # ===== Completion =====

    # nvim-cmp
    cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        window = {
          completion = {
            border = "rounded";
          };
          documentation = {
            border = "rounded";
          };
        };
        sources = [
          {name = "nvim_lsp";}
          {name = "path";}
          {name = "buffer";}
          {name = "luasnip";}
          {name = "copilot";}
        ];
        snippet = {
          expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        };
      };
    };

    # LuaSnip
    luasnip.enable = true;

    # ===== AI Assistance =====

    # Copilot
    copilot-lua = {
      enable = true;
      settings = {
        suggestion = {
          enabled = false;
        };
        panel = {
          enabled = false;
        };
      };
    };

    # Avante (AI assistant)
    avante = {
      enable = true;
      settings = {
        provider = "copilot";
        cursor_applying_provider = "copilot";
        auto_suggestions_provider = "copilot";
        behaviour = {
          auto_suggestions = false;
        };
      };
    };

    # ===== Debugging =====

    # DAP
    dap.enable = true;

    # DAP UI
    dap-ui.enable = true;

    # DAP Virtual Text
    dap-virtual-text.enable = true;

    # ===== Terminal =====

    # Toggleterm
    toggleterm = {
      enable = true;
      settings = {
        direction = "float";
        float_opts = {
          border = "curved";
        };
      };
    };
  };

  # Custom plugins via extraPlugins
  extraPlugins = with pkgs.vimPlugins; [
    # Laravel
    laravel-nvim

    # Worktrees
    worktrees-nvim

    # Neotest with Pest adapter
    neotest
    neotest-pest

    # MCPHub
    mcphub-nvim

    # Dependencies
    plenary-nvim
    nui-nvim
    promise-async
    vim-dotenv
    snacks-nvim
  ];

  # Extra packages (CLI tools)
  extraPackages = with pkgs; [
    # MCP Hub CLI
    mcp-hub

    # PHP LSP
    phpantom-lsp

    # Formatters
    alejandra
    nodePackages.prettier
    stylua

    # LSP extras
    ripgrep
    fd
    lazygit
  ];

  # Lua configuration for custom plugins
  extraConfigLua = ''
    -- Global border configuration for diagnostics and LSP handlers
    vim.diagnostic.config({
      float = { border = "rounded" },
    })

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover,
      { border = "rounded" }
    )

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.signature_help,
      { border = "rounded" }
    )

    -- PHPantom LSP setup
    vim.lsp.config['phpantom'] = {
      cmd = { 'phpantom_lsp' },
      filetypes = { 'php' },
      root_markers = { 'composer.json', '.git' },
    }
    vim.lsp.enable('phpantom')

    -- Laravel setup
    require('laravel').setup({
      lsp_server = "phpantom",
    })

    -- Worktrees setup
    require('worktrees').setup({})

    -- Register worktrees telescope extension
    pcall(function()
      require('telescope').load_extension('worktrees')
    end)

    -- Neotest setup with Pest adapter
    require('neotest').setup({
      adapters = {
        require('neotest-pest'),
      },
    })

    -- MCPHub setup
    require('mcphub').setup({
      workspace = {
        enabled = true,
        look_for = {".mcphub/servers.json", ".vscode/mcp.json", ".cursor/mcp.json"},
        reload_on_dir_changed = true,
        port_range = {
          min = 40000,
          max = 41000,
        },
      },
      extensions = {
        avante = {
          make_slash_commands = true,
        },
      },
    })

    -- Override Avante config for MCPHub integration
    pcall(function()
      local avante_config = require('avante.config')
      avante_config.override({
        system_prompt = function()
          local hub = require("mcphub").get_hub_instance()
          return hub and hub:get_active_servers_prompt() or ""
        end,
        custom_tools = function()
          return {
            require("mcphub.extensions.avante").mcp_tool(),
          }
        end,
      })
    end)

    -- Snacks.nvim setup for lazygit and explorer
    require('snacks').setup({
      lazygit = { configure = true },
      explorer = { replace_netrw = true },
      picker = {
        sources = {
          explorer = {
            auto_close = true,
            layout = {
              preset = "vertical",
              layout = {
                min_height = 5,
              },
            },
          },
        },
      },
    })
  '';
}

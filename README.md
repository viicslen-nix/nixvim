<div align="center">

# NixVim

**A standalone Neovim, configured with [NixVim](https://github.com/nix-community/nixvim) and built as a single package.**

[![NixOS unstable](https://img.shields.io/badge/nixpkgs-unstable-5277C3?style=flat-square&logo=nixos&logoColor=white)](https://nixos.org)
[![NixVim](https://img.shields.io/badge/built_with-NixVim-7EBAE4?style=flat-square&logo=neovim&logoColor=white)](https://github.com/nix-community/nixvim)
[![flake-parts](https://img.shields.io/badge/flake-parts-7EBAE4?style=flat-square&logo=nixos&logoColor=white)](https://flake.parts)

</div>

> [!NOTE]
> A personal editor config, tuned for PHP/Laravel and TypeScript/Vue work.
> It is a submodule of [viicslen-nix/nixos](https://github.com/viicslen-nix/nixos),
> where the `personal` preset installs it.

## Outputs

Only `x86_64-linux` is built.

| Output | What it is |
| --- | --- |
| `packages.default` | The configured Neovim (`bin/nvim`), built with `makeNixvimWithModule` on an unfree-enabled nixpkgs |
| `packages.<plugin>` | Re-exports of the custom pieces it bundles: `laravel-nvim`, `worktrees-nvim`, `neotest-pest`, `mcphub-nvim`, `mcp-hub`, `phpantom-lsp`, `laravel-lsp` |
| `apps.default` | Runs `packages.default` |
| `devShells.default` | `nix-output-monitor` and `alejandra` |
| `formatter` | treefmt: deadnix → statix → alejandra |
| `checks` | `treefmt`, `statix` (fails on lints `statix fix` cannot fix), `nix-fmt` (alejandra check) |

The custom plugins and language servers come from
[`viicslen-nix/packages`](https://github.com/viicslen-nix/packages) (`nvim.*`,
`php.*`) and [`ravitemer/mcphub.nvim`](https://github.com/ravitemer/mcphub.nvim).

## Usage

Run it without installing:

```bash
nix run github:viicslen-nix/nixvim
```

Or consume it as a flake input:

```nix
{
  inputs.nixvim.url = "github:viicslen-nix/nixvim";

  outputs = {nixpkgs, nixvim, ...}: {
    nixosConfigurations.host = nixpkgs.lib.nixosSystem {
      modules = [
        ({pkgs, ...}: {
          environment.systemPackages = [
            nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default
          ];
        })
      ];
    };
  };
}
```

### Options

The config declares one option of its own; everything else is stock NixVim.

| Option | Default | Effect |
| --- | --- | --- |
| `phpantom.enable` | `false` | Adds the PHPantom PHP language server and points laravel.nvim at it |

Set it by extending the built package (NixVim's standalone `extend`):

```nix
nixvim.packages.${system}.default.extend {phpantom.enable = true;}
```

## What's inside

| Area | Pieces |
| --- | --- |
| **LSP** | intelephense, nil (alejandra formatting), ts_ls + `@vue/typescript-plugin`, vue_ls, pyright, gopls, lua_ls, bashls, html, cssls, tailwindcss, eslint (fix on save), terraformls, marksman, sqls, clangd, zls — plus `laravel_lsp`, started only where an `artisan` file exists |
| **Syntax** | Treesitter (highlight, indent, context) |
| **UI** | OneDark *darker* (transparent), lualine, bufferline, alpha, which-key (helix preset), notify, indent-blankline, illuminate, colorizer, trouble, lspsaga |
| **Navigation** | Telescope (fzf-native), snacks.nvim explorer, leap, toggleterm |
| **Editing** | comment, nvim-autopairs, nvim-surround, nvim-cmp + LuaSnip |
| **Git** | gitsigns, fugitive, git-conflict, gitlinker, worktrees.nvim, lazygit via snacks |
| **Testing / debug** | neotest + neotest-pest, nvim-dap, dap-ui, dap-virtual-text |
| **AI** | Supermaven inline completion; Avante on the `claude-code` provider (ACP via `claude-agent-acp`, reuses the Claude Code login) with MCPHub tools and slash commands |
| **Laravel** | laravel.nvim, laravel-lsp, neotest-pest |

## Keybindings

Leader and local leader are both <kbd>Space</kbd>. Press it and wait for
which-key to list the rest.

<details>
<summary><b>Full reference</b></summary>

**Editing and buffers**

| Key | Mode | Action |
| --- | --- | --- |
| `<C-s>` | n, v, i | Save file |
| `<leader>cf` | n | Copy relative file path |
| `<leader>;` / `<leader>,` | n | Append `;` / `,` to the line |
| `>` / `<` | v | Indent / unindent, keep selection |
| `<C-/>` | n, v | Toggle comment |
| `jk` | i | Exit insert mode |
| `<Esc>` | n | Clear search highlight |
| `<Tab>` / `<S-Tab>` | n | Next / previous buffer |
| `<leader>q` | n | Close buffer |
| `<C-h/j/k/l>` | n | Move between windows |
| `<leader>e` | n | Snacks explorer |
| `<C-\>` | n | Floating terminal |

**Find (Telescope)**

| Key | Action |
| --- | --- |
| `<leader>ff` | Files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>fr` | Recent files |
| `<leader>fc` | Commands |
| `<leader>fd` | Diagnostics |

**LSP**

| Key | Mode | Action |
| --- | --- | --- |
| `gd` / `<leader>gd` | n | Go to definition |
| `<leader>gD` | n | Go to declaration |
| `gD` | n | References |
| `gt` / `<leader>gt` | n | Type definition |
| `gi` / `<leader>gi` | n | Implementations |
| `K` / `<leader>h` | n | Hover documentation |
| `<leader>pd` | n | Peek definition |
| `<leader>gr` | n | Lspsaga finder |
| `<leader>ca` | n, v | Code action |
| `<leader>rn` | n | Rename symbol |
| `<leader>j` / `<leader>k` | n | Next / previous diagnostic |
| `<leader>ls` / `<leader>lx` / `<leader>lr` | n | Start / stop / restart LSP |

**Git**

| Key | Action |
| --- | --- |
| `<leader>gg` | Lazygit |
| `<leader>gs` | Fugitive status |
| `<leader>gl` | Copy git link |
| `<leader>gws` | Worktrees picker |
| `<leader>gwc` | New worktree |
| `<leader>gwa` | Worktree for an existing branch |

**Laravel, tests, debugging**

| Key | Action |
| --- | --- |
| `<leader>lla` / `<leader>llr` / `<leader>llm` | Artisan / routes / related |
| `<leader>tt` / `<leader>tf` | Run nearest test / file |
| `<leader>to` | Toggle test output |
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue / start debugging |
| `<leader>di` / `<leader>do` | Step into / over |
| `<leader>du` | Toggle DAP UI |

**Diagnostics (Trouble)**

| Key | Action |
| --- | --- |
| `<leader>xx` | All diagnostics |
| `<leader>xd` | Current buffer diagnostics |
| `<leader>xq` / `<leader>xl` | Quickfix / location list |
| `<leader>xs` | Symbols |
| `<leader>xL` | LSP definitions, references, … |

**Completion and AI (insert mode)**

| Key | Action |
| --- | --- |
| `<C-Space>` | Open completion |
| `<Tab>` / `<S-Tab>` | Next / previous item |
| `<CR>` | Confirm |
| `<C-e>` | Close |
| `<C-d>` / `<C-f>` | Scroll docs |
| `<M-L>` / `<M-l>` | Accept Supermaven suggestion / word |
| `<M-]>` | Clear Supermaven suggestion |

</details>

<details>
<summary><b>Keymap conventions</b></summary>

The bindings share a vocabulary with the niri and Hyprland configs in the
parent repo, so muscle memory carries between editor and window manager:

- **Namespaces by leader prefix:** `g` git/LSP navigation, `gw` worktrees,
  `ll` Laravel, `t` tests, `d` debugging, `x` diagnostics, `f` find.
- **H/J/K/L for direction:** `Ctrl` moves between Neovim splits, `Super`
  between WM windows.
- **Mnemonic pairs:** `<leader>q` closes a buffer as `Super+Q` closes a window;
  `<leader>e` opens the explorer as `Super+E` opens the file manager.

</details>

## Layout

```text
.
├── flake.nix        # inputs, packages, checks, devShell
├── apps.nix         # apps.default
├── treefmt.nix      # formatter / checks.treefmt
└── config/
    ├── default.nix  # options, LSP, plugins, extra Lua
    ├── keybinds.nix # keymaps
    └── phpantom.nix # phpantom.enable
```

## Development

```bash
nix build            # ./result/bin/nvim
nix run              # try it in place
nix develop          # nom + alejandra
nix fmt              # deadnix, statix, alejandra via treefmt
nix flake check      # formatting and statix gates
```

> [!IMPORTANT]
> Before adding a plugin or feature, read [AGENTS.md](./AGENTS.md): check the
> NixVim and plugin docs and prefer a built-in option over custom Lua.

Inside Neovim, `:checkhealth vim.lsp` shows which servers attached.

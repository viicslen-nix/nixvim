# NixVim Neovim Configuration

A standalone Neovim configuration using the NixVim framework, providing feature parity with the nvf-based configuration.

## Features

- **Full LSP Support**: 17 language servers including Nix, PHP (Intelephense), TypeScript, Python, Go, Lua, Bash, HTML, CSS, Tailwind, Terraform, HCL, Markdown, SQL, C/C++, and Zig
- **TreeSitter**: Syntax highlighting and code folding for all supported languages
- **OneDark Theme**: Darker variant with transparency support
- **Productivity Plugins**: Telescope, nvim-tree, bufferline, lualine, alpha dashboard, which-key
- **Git Integration**: Gitsigns, vim-fugitive, git-conflict, gitlinker, worktrees.nvim
- **AI Assistance**: GitHub Copilot, Avante with MCPHub integration
- **Custom Plugins**: laravel.nvim, worktrees.nvim, neotest-pest, mcphub.nvim

## Quick Start

### Build and Run

```bash
# Navigate to the flake directory
cd flakes/nixvim

# Build the Neovim package
nix build .#default

# Run Neovim directly
nix run .#default

# Or run the built result
./result/bin/nvim
```

### Development Shell

```bash
# Enter the development shell
nix develop

# This provides:
# - nix-output-monitor (nom) for better build output
# - alejandra for Nix formatting
```

### Build with Enhanced Output

```bash
# Use nix-output-monitor for better build visibility
nom build .#default
```

## Directory Structure

```text
flakes/nixvim/
├── flake.nix           # Flake definition with inputs and outputs
├── flake.lock          # Locked dependency versions
├── README.md           # This file
├── apps.nix            # App output definitions
├── packages.nix        # Package output definitions
├── config/
│   ├── default.nix     # Main NixVim configuration
│   └── keybinds.nix    # Keybind definitions
└── pkgs/
    ├── laravel-nvim.nix    # Laravel.nvim plugin
    ├── worktrees-nvim.nix  # Worktrees.nvim plugin
    ├── neotest-pest.nix    # Neotest Pest adapter
    └── mcp-hub.nix         # MCPHub plugin and CLI
```

## Keybindings Reference

This configuration follows a **unified keymap philosophy** shared with the window managers (Hyprland/Niri) to maximize muscle memory and minimize cognitive overhead. See the **Unified Keymap Philosophy** section below for details.

### Leader Key
- `<leader>` = `Space`
- `<localleader>` = `Space`

### Core Keybinds

**File Operations**
| Keybind | Mode | Action |
|---------|------|--------|
| `Ctrl + S` | n, v, i | Save file |
| `<leader>;` | n | Append semicolon |
| `<leader>,` | n | Append comma |

**Buffer Management**
| Keybind | Mode | Action |
|---------|------|--------|
| `Tab` | n | Next buffer |
| `Shift + Tab` | n | Previous buffer |
| `<leader>q` | n | Close buffer |

**Window Navigation (Vim-style)**
| Keybind | Mode | Action |
|---------|------|--------|
| `Ctrl + H` | n | Move to left window |
| `Ctrl + J` | n | Move to bottom window |
| `Ctrl + K` | n | Move to top window |
| `Ctrl + L` | n | Move to right window |

**Visual Mode**
| Keybind | Mode | Action |
|---------|------|--------|
| `>` | v | Indent selection (stay in visual) |
| `<` | v | Unindent selection (stay in visual) |

**File Tree**
| Keybind | Mode | Action |
|---------|------|--------|
| `<leader>e` | n | Toggle NvimTree |

**Comments**
| Keybind | Mode | Action |
|---------|------|--------|
| `Ctrl + /` | n | Toggle line comment |
| `Ctrl + /` | v | Toggle selection comment |

**Insert Mode**
| Keybind | Mode | Action |
|---------|------|--------|
| `jk` | i | Exit to normal mode |

**Search**
| Keybind | Mode | Action |
|---------|------|--------|
| `ESC` | n | Clear search highlight |

### LSP Keybinds (Leader + G)

| Keybind | Mode | Action |
|---------|------|--------|
| `<leader>gD` | n | Go to declaration |
| `<leader>gd` | n | Go to definition |
| `<leader>gt` | n | Go to type definition |
| `<leader>h` | n | Hover documentation |
| `<leader>gi` | n | List implementations |
| `<leader>gr` | n | List references |

### Git Operations (Leader + G)

**General Git**
| Keybind | Mode | Action |
|---------|------|--------|
| `<leader>gg` | n | Open Lazygit |
| `<leader>gs` | n | Git status (Fugitive) |
| `<leader>gl` | n | Copy git link (GitLinker) |

**Git Worktrees** (`<leader>gw`)
| Keybind | Mode | Action |
|---------|------|--------|
| `<leader>gws` | n | Worktrees picker |
| `<leader>gwc` | n | Create new worktree |
| `<leader>gwa` | n | Worktree for existing branch |

### Laravel Operations (Leader + LL)

| Keybind | Mode | Action |
|---------|------|--------|
| `<leader>lla` | n | Laravel Artisan |
| `<leader>llr` | n | Laravel Routes |
| `<leader>llm` | n | Laravel Related |

### Testing (Leader + T)

| Keybind | Mode | Action |
|---------|------|--------|
| `<leader>tt` | n | Run nearest test |
| `<leader>tf` | n | Run file tests |
| `<leader>to` | n | Toggle test output |

### Debugging (Leader + D)

| Keybind | Mode | Action |
|---------|------|--------|
| `<leader>db` | n | Toggle breakpoint |
| `<leader>dc` | n | Continue/Start debugging |
| `<leader>di` | n | Step into |
| `<leader>do` | n | Step over |
| `<leader>du` | n | Toggle DAP UI |

### Diagnostics (Leader + X)

| Keybind | Mode | Action |
|---------|------|--------|
| `<leader>xx` | n | Toggle diagnostics |
| `<leader>xw` | n | Workspace diagnostics |
| `<leader>xd` | n | Document diagnostics |

### Unified Keymap Philosophy

This configuration is part of a **cross-system keymap standardization** that spans both editors (Neovim/Nixvim) and window managers (Hyprland/Niri).

**Design Principles:**
1. **Leader-based namespacing**: Logical grouping of related actions (`<leader>g*` for git, `<leader>ll*` for Laravel, etc.)
2. **Vim-style navigation**: H/J/K/L everywhere for directional movement
3. **Consistent modifiers**: Ctrl for window navigation, matching WM patterns
4. **Mnemonic keys**: Q for quit, E for explorer, G for git, etc.
5. **Cross-system harmony**: Editor keybinds mirror window manager patterns

**Cross-System Consistency:**
- **Close/Quit**: `<leader>q` (buffer), `SUPER+Q` (window in WMs)
- **Explorer/Files**: `<leader>e` (file tree), `SUPER+E` (file manager in WMs)
- **Window Navigation**: `Ctrl+H/J/K/L` (Neovim splits), `SUPER+H/J/K/L` (WM windows)
- **Namespacing**: Leader key grouping mirrors WM application menus (`SUPER+A`)

**Namespace Organization:**
- `<leader>g*` - Git operations (general)
- `<leader>gw*` - Git worktrees (sub-namespace)
- `<leader>ll*` - Laravel operations
- `<leader>t*` - Testing
- `<leader>d*` - Debugging (DAP)
- `<leader>x*` - Diagnostics (trouble)

This structured approach reduces cognitive load and makes muscle memory transferable between your editor and window manager.

See the Hyprland, Niri, and Neovim READMEs for their implementations of this unified system.

## Verification

### Check LSP Status

```vim
:LspInfo
```

### Check Loaded Plugins

```vim
:Lazy
```

### Check Keybinds

Press `<leader>` and wait for which-key popup.

## Comparison with nvf

This configuration is designed to be feature-equivalent with the nvf-based Neovim configuration in `flakes/neovim/`. The main differences are:

1. **Framework**: Uses NixVim instead of nvf
2. **Configuration Style**: NixVim module options instead of nvf's vim.* options
3. **Plugin Loading**: Uses NixVim's native plugin modules where available

## License

Same as the parent repository.

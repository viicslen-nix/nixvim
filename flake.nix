{
  description = "NixVim-based Neovim configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    packages = {
      url = "github:viicslen-nix/packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mcphub-nvim = {
      url = "github:ravitemer/mcphub.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    flake-parts,
    self,
    nixvim,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        ./apps.nix
      ];

      systems = ["x86_64-linux"];

      perSystem = {
        config,
        pkgs,
        system,
        ...
      }: let
        sharedPackages = inputs.packages.packages.${system};
        laravel-nvim = sharedPackages.nvim.laravel-nvim;
        worktrees-nvim = sharedPackages.nvim.worktrees-nvim;
        neotest-pest = sharedPackages.nvim.neotest-pest;
        mcp-hub = sharedPackages.nvim.mcp-hub;
        mcphub-nvim = inputs.mcphub-nvim.packages.${system}.default;
        phpantom-lsp = sharedPackages.php.phpantom-lsp;

        # Build NixVim with our configuration
        nixvimLib = nixvim.lib.${system};
        nixvimModule = {
          inherit pkgs;
          module = import ./config {
            inherit pkgs laravel-nvim worktrees-nvim neotest-pest mcphub-nvim mcp-hub phpantom-lsp;
            inherit (pkgs) lib;
          };
        };
      in {
        # Default package is the configured Neovim
        packages = {
          default = nixvim.legacyPackages.${system}.makeNixvimWithModule {
            inherit pkgs;
            module = import ./config {
              inherit pkgs laravel-nvim worktrees-nvim neotest-pest mcphub-nvim mcp-hub phpantom-lsp;
              inherit (pkgs) lib;
            };
          };

          # Expose custom packages
          inherit laravel-nvim worktrees-nvim neotest-pest mcphub-nvim mcp-hub phpantom-lsp;
        };

        # Provide the default formatter
        formatter = pkgs.alejandra;

        # Check if codebase is properly formatted
        checks = {
          nix-fmt = pkgs.runCommand "nix-fmt-check" {nativeBuildInputs = [pkgs.alejandra];} ''
            alejandra --check ${self} < /dev/null | tee $out
          '';
        };

        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nix-output-monitor
            alejandra
          ];
          shellHook = ''
            echo "NixVim development shell"
            echo "Use 'nom build' or 'nom run' for better build output"
          '';
        };
      };
    };
}

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
      # Track the unstable branch to match nixpkgs (nixos-unstable / 26.11); the
      # nixos-26.05 branch's nixos-render-docs patch doesn't apply to 26.11.
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
        pkgs,
        system,
        ...
      }: let
        pkgsUnfree = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        sharedPackages = inputs.packages.packages.${system};
        laravel-nvim = sharedPackages.nvim.laravel-nvim;
        worktrees-nvim = sharedPackages.nvim.worktrees-nvim;
        neotest-pest = sharedPackages.nvim.neotest-pest;
        mcp-hub = sharedPackages.nvim.mcp-hub;
        mcphub-nvim = inputs.mcphub-nvim.packages.${system}.default;
        phpantom-lsp = sharedPackages.php.phpantom-lsp;
        laravel-lsp = sharedPackages.php.laravel-lsp;
      in {
        # Default package is the configured Neovim
        packages = {
          default = nixvim.legacyPackages.${system}.makeNixvimWithModule {
            pkgs = pkgsUnfree;
            module = ./config;
            extraSpecialArgs = {
              inherit laravel-nvim worktrees-nvim neotest-pest mcphub-nvim mcp-hub phpantom-lsp laravel-lsp;
            };
          };

          # Expose custom packages
          inherit laravel-nvim worktrees-nvim neotest-pest mcphub-nvim mcp-hub phpantom-lsp laravel-lsp;
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

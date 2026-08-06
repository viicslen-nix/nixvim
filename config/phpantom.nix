# PHPantom LSP, behind an opt-in flag.
{
  lib,
  config,
  phpantom-lsp,
  ...
}: {
  options.phpantom.enable = lib.mkEnableOption "the phpantom PHP language server";

  config = lib.mkIf config.phpantom.enable {
    extraPackages = [phpantom-lsp];

    extraConfigLua = ''
      -- PHPantom LSP setup
      vim.lsp.config['phpantom'] = {
        cmd = { 'phpantom_lsp' },
        filetypes = { 'php' },
        root_markers = { 'composer.json', '.git' },
      }
      vim.lsp.enable('phpantom')
    '';
  };
}

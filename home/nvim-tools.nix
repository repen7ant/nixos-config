{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --- LSP servers ---
    lua-language-server                # lua_ls
    basedpyright                       # basedpyright
    clang-tools                        # clangd
    intelephense                       # intelephense (PHP LSP, unfree but free to use)
    php                                # PHP runtime (needed by composer + artisan)
    phpPackages.composer               # composer (run `composer install` for vendor/)
    ruff                               # ruff (LSP + formatter)
    vscode-langservers-extracted       # jsonls + html + eslint
    sqls                               # sqls (Go SQL LSP)
    yaml-language-server               # yamlls
    bash-language-server               # bashls
    dockerfile-language-server         # dockerls
    docker-compose-language-service    # docker_compose_language_service
    nil                                # nix LSP (nil_ls)

    # --- formatters / linters ---
    stylua                             # lua format
    prettierd                          # js/ts/json/yaml/md/html format
    shfmt                              # shell format
    checkmake                          # Makefile lint

    # --- treesitter runtime build deps ---
    gcc                                # compiles parsers (auto_install)
    tree-sitter                        # CLI needed by nvim-treesitter `main` branch

    gnumake
  ];
}

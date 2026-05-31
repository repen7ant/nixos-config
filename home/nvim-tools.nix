{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --- LSP servers ---
    lua-language-server                # lua_ls
    basedpyright                       # basedpyright
    clang-tools                        # clangd
    phpactor                           # phpactor (PHP LSP, open-source)
    ruff                               # ruff (LSP + formatter)
    vscode-langservers-extracted       # jsonls + html
    sqls                               # sqls (Go SQL LSP)
    terraform-ls                       # terraformls
    yaml-language-server               # yamlls
    bash-language-server               # bashls
    dockerfile-language-server-nodejs  # dockerls
    docker-compose-language-service    # docker_compose_language_service
    nil                                # nix LSP (nil_ls)

    # --- formatters / linters ---
    stylua                             # lua format
    prettierd                          # js/ts/json/yaml/md/html format
    eslint_d                           # js/ts lint
    shfmt                              # shell format
    checkmake                          # Makefile lint
    terraform                          # `terraform fmt`

    # --- treesitter runtime build deps ---
    gcc                                # compiles parsers (auto_install)
    tree-sitter                        # CLI needed by nvim-treesitter `main` branch
  ];
}

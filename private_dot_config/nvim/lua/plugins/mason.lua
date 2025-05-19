return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "stylua",
      "shellcheck",
      "shfmt",
      -- python
      "flake8",
      "mypy",
      "ruff",
      "pyright",
      -- Go
      "goimports",
      "gofumpt",
    },
  },
}

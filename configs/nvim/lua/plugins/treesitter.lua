return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = { "c", "cpp", "lua", "python", "javascript", "powershell" },
      highlight = { enable = true },
      indent = { enable = true },
    }
  end,
}

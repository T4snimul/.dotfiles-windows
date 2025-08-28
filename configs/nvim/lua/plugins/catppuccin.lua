return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "frappe",
      background = { light = "frappe", dark = "macchiato" },
      transparent_background = true,
      term_colors = true,
      integrations = { treesitter = true, lsp_trouble = true, cmp = true, gitsigns = true, telescope = true, notify = true },
    })
    vim.cmd.colorscheme("catppuccin")

    -- Make cursor line transparent
    vim.cmd [[
      hi CursorLine guibg=#363a4f
    ]]
  end,
}


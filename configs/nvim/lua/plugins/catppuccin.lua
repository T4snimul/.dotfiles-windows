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
    local colors = require("catppuccin.palettes").get_palette()

    vim.cmd(string.format("hi CursorLine guibg=%s ctermbg=NONE", colors.surface0))
    vim.cmd(string.format("hi CursorLineNr guibg=%s ctermbg=NONE guifg=%s", colors.surface0, colors.text))
  end,
}


return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("nvim-tree").setup({
      disable_netrw = true,
      hijack_netrw = true,
      view = { width = 25, side = "left", adaptive_size = true },
      renderer = { icons = { show = { file = true, folder = true, folder_arrow = true, git = true } } },
      git = { enable = true },
      actions = { open_file = { quit_on_open = true } },
    })
    vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
  end,
}


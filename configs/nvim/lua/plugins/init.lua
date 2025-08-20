-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load Plugins
require("lazy").setup({
  { "neovim/nvim-lspconfig", config = function() require("plugins.lsp") end },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = function() require("plugins.treesitter") end },

  -- Catppuccin theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "frappe",
        background = { light = "frappe", dark = "macchiato" },
        transparent_background = true,
        term_colors = true,
        integrations = {
          treesitter = true,
          lsp_trouble = true,
          cmp = true,
          gitsigns = true,
          telescope = true,
          notify = true,
        },
      })
      vim.cmd.colorscheme("catppuccin")

      -- Ensure transparency
      vim.cmd [[
        hi Normal guibg=NONE ctermbg=NONE
        hi NormalNC guibg=NONE ctermbg=NONE
        hi VertSplit guibg=NONE ctermbg=NONE
        hi StatusLine guibg=NONE ctermbg=NONE
        hi LineNr guibg=NONE ctermbg=NONE
        hi CursorLine guibg=NONE ctermbg=NONE
        hi Pmenu guibg=NONE ctermbg=NONE
        hi PmenuSel guibg=#5c5f77 guifg=#f5e0dc
        hi PMenuThumb guibg=#44475a
        hi TelescopeNormal guibg=NONE
        hi CursorLineNr guifg=#f5e0dc guibg=NONE gui=bold
      ]]
    end
  },

  -- Autocomplete engine
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",   -- LSP source
      "hrsh7th/cmp-buffer",     -- buffer words
      "hrsh7th/cmp-path",       -- file paths
      "saadparwaiz1/cmp_luasnip", -- snippets
      "L3MON4D3/LuaSnip",       -- snippet engine
      "windwp/nvim-autopairs",  -- autopairs integration
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })

      -- autopairs integration
      cmp.event:on(
        "confirm_done",
        cmp_autopairs.on_confirm_done()
      )

      -- setup autopairs for normal typing
      require("nvim-autopairs").setup({
        check_ts = true,
        fast_wrap = {},
        disable_filetype = { "TelescopePrompt", "vim" },
      })
    end
  },

  -- Commenting
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup({
        -- Toggle comment with gcc (normal mode) or gc (visual mode)
        toggler = {
          line = "gcc",
          block = "gbc",
        },
        opleader = {
          line = "gc",
          block = "gb",
        },
        -- Optional keybindings, language-specific configs are auto-detected
        pre_hook = nil,
        post_hook = nil,
      })
    end
  }
})

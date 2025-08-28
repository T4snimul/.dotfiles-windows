-- Core Settings
require("core.options")
require("core.keymaps")
require("core.filetypes")

-- Plugins
require("plugins")

-- Reload Config with `:ReloadConfig`
function ReloadConfig()
  for name,_ in pairs(package.loaded) do
    if name:match("^core") or name:match("^plugins") then
      package.loaded[name] = nil
    end
  end
  require("init")  -- reload main init.lua
  print("Config reloaded!")
end

vim.cmd([[command! ReloadConfig lua ReloadConfig()]])

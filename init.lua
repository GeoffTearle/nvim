require("config.nix")

local optsMgr = require("config.options")
optsMgr.apply()

local pluginMgr = require("config.plugins")
pluginMgr.ensureInstalled()
pluginMgr.load()

local keybindMgr = require("config.keymap")
keybindMgr.general()

-- Move to setup
keybindMgr.telescope()

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

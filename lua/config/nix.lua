local grammersPath = vim.fn.stdpath("data") .. "/nix-treesitter-grammers"
vim.opt.rtp:prepend(grammersPath)

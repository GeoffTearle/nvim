return {
  {
    "LZDQ/nvim-autocenter",
    version = "*",
    opts = {
      -- auto center only when the cursor is not within this range vertically
      ratio_top = 1 / 3,
      ratio_bot = 2 / 3,
      -- When to call `autozz`. Choose between 'always', 'empty', and 'never'.
      -- 'always' means to always do autozz when buffer text changes.
      -- 'empty'  means to do autozz only when the current line contains whitespaces.
      -- 'never'  means do not autozz. If you choose never, you should enable autopairs.
      when = "empty",
      -- plugin support
      plugins = {
        -- auto center when pressing enter inside specific brackets
        autopairs = {
          enabled = true,
          -- These are rules to auto center when pressing enter after it.
          -- Each item is the lhs of the rule.
          rules_with_cr = {
            "{",
            "'''",
            '"""',
          },
        },
      },
    },
  },
}

-- ~/.config/nvim/lua/plugins/snacks_bigfile.lua
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false, -- <— important: load early
  opts = {
    -- simplest fix: just turn Bigfile off
    bigfile = { enabled = false },

    -- or keep it on, but raise the limit high enough
  --   bigfile = {
  --     enabled = true,
  --     size = 10 * 1024 * 1024, -- 10 MB
  --     notify = true,
  --     -- Newer Snacks also considers very long lines (avg line length).
  --     -- If your JSON is minified/1-line, bump this threshold too:
  --     average_line_length = 900000, -- generous for minified JSON
  --   },
  --   notifier = { enabled = true }, -- so you see the popup
  },
}

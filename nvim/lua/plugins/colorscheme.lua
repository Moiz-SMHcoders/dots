return {
  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    lazy = false,
    priority = 1000,
    opts = {
      compile = false,
      theme = "dragon", -- use the Dragon variant
      transparent = false, -- solid background (no transparency)
      dimInactive = false,
      terminalColors = true,
      background = {
        dark = "dragon",
        light = "lotus",
      },
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
            },
          },
        },
      },
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd.colorscheme("kanagawa-dragon")

      -- Keep normal backgrounds solid
      for _, g in ipairs({
        "Normal", "NormalNC", "NormalFloat", "FloatBorder", "SignColumn",
        "StatusLine", "StatusLineNC", "WinSeparator",
      }) do
        vim.api.nvim_set_hl(0, g, { bg = "none" })
      end
    end,
  },
}

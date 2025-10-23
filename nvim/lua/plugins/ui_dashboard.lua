-- ~/.config/nvim/lua/plugins/ui_dashboard.lua
return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        -- keep Snacks defaults; just give it a custom header + transparent bg
        preset = {
          header = [[
 ██████   █████                   █████   █████  ███                 
░░██████ ░░███                   ░░███   ░░███  ░░░                  
 ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████  
 ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███ 
 ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███ 
 ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███ 
 █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████
░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░ 
          ]],
        },
        win = { wo = { winhl = "Normal:Normal,FloatBorder:FloatBorder" } },
      },
    },
    config = function(_, opts)
      require("snacks").setup(opts)

      -- Transparent background so Ghostty shows through
      for _, grp in ipairs({
        "Normal", "NormalNC", "NormalFloat",
        "SnacksDashboard", -- main buffer group
      }) do
        pcall(vim.api.nvim_set_hl, 0, grp, { bg = "none" })
      end

      -- Recolor built-in dashboard groups (names provided by Snacks)
      -- If a group doesn't exist in your version, pcall keeps it harmless.
      pcall(vim.api.nvim_set_hl, 0, "SnacksDashboardHeader", { fg = "#bea3c7", bg = "none", bold = true }) -- mauve
      pcall(vim.api.nvim_set_hl, 0, "SnacksDashboardKey",    { fg = "#f0dfaf", bg = "none", bold = true }) -- zenburn yellow
      pcall(vim.api.nvim_set_hl, 0, "SnacksDashboardIcon",   { fg = "#8cd0d3", bg = "none" })              -- zenburn cyan
      pcall(vim.api.nvim_set_hl, 0, "SnacksDashboardDesc",   { fg = "#dcdccc", bg = "none" })              -- zenburn fg
      pcall(vim.api.nvim_set_hl, 0, "SnacksDashboardFooter", { fg = "#7f9f7f", bg = "none", italic = true })-- zenburn green
    end,
  },
}

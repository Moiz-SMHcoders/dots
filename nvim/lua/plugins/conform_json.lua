return {
  "stevearc/conform.nvim",
  optional = true,
  opts = function()
    local opts = require("lazy.core.plugin").values("conform.nvim", "opts") or {}
    opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
      json = { "prettier", "jq" }, -- tries prettier first, then jq
      jsonc = { "prettier" },
    })
    -- allow falling back to LSP (jsonls) if no CLI formatter is available
    opts.lsp_fallback = true
    return opts
  end,
}

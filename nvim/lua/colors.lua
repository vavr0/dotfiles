local M = {}

local headings = {
  Headline1Bg = "#c4a7e7",
  Headline2Bg = "#ebbcba",
  Headline3Bg = "#f6c177",
  Headline4Bg = "#9ccfd8",
  Headline5Bg = "#31748f",
  Headline6Bg = "#908caa",
}

function M.setup()
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none", fg = "#e0def4" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })

  vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#2a273f", fg = "#e0def4" })
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none", fg = "#e0def4" })
  vim.api.nvim_set_hl(0, "Pmenu", { bg = "#191724", fg = "#cdd6f4" })

  vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { bg = "#191724", fg = "#e0def4" })
  vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { bg = "#191724", fg = "#e0def4" })
  vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { bg = "#191724", fg = "#e0def4" })
  vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { bg = "#191724", fg = "#e0def4" })

  vim.api.nvim_set_hl(0, "MarkSignHL", { fg = "#6a329f", ctermfg = "magenta" })
  vim.api.nvim_set_hl(0, "MarkVirtTextHL", { fg = "#00FF00", ctermfg = "green" })
  vim.api.nvim_set_hl(0, "CursorLine", { bg = "#f6c177", fg = "#191724" })

  vim.api.nvim_set_hl(0, "RenderMarkdownQuote", { fg = "#6e6a86", bg = "#1f1d2e" })
  vim.api.nvim_set_hl(0, "RenderMarkdownBullet", { fg = "#ebbcba" })
  vim.api.nvim_set_hl(0, "RenderMarkdownLink", { fg = "#9a6cff", bold = true })
  vim.api.nvim_set_hl(0, "RenderMarkdownWikiLink", { fg = "#b072ff", bold = true })
  vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "RenderMarkdownCodeBlock", { bg = "NONE" })

  for name, bg in pairs(headings) do
    vim.api.nvim_set_hl(0, name, { fg = "#191724", bg = bg })
  end

  vim.api.nvim_set_hl(0, "WhichKeyNormal", { link = "Normal" })
  vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#d6b36a", fg = "#191724" })

  vim.api.nvim_set_hl(0, "StatusModeVisual", { fg = "#c4a7e7", bg = "NONE", bold = true })
  vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "WinBar", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "WinBarNC", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "TabLine", { bg = "none", fg = "#908caa" })
  vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none", fg = "#6e6a86" })
  vim.api.nvim_set_hl(0, "TabLineSel", {
    bg = "none",
    fg = "#ebbcba",
    underline = true,
    bold = true,
  })
end

return M

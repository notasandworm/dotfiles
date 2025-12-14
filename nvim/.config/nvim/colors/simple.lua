-- Name: simple
-- Author: Matt Lucero (notasandworm@gmail.com)
-- Inspiration: zanshin/nvim-fourcolor-theme
-- Place this file at ~/.config/nvim/colors/simple.vim or as a lua colorscheme

local colors = {
  bg = "#121212", -- Dark background
  fg = "#acacac", -- White foreground
  white = "#cccccc",
  comment = "#656565", -- Comments
  ghost = "#414141", -- Hints (lsp, autocompletions)
  green = "#66cc85", -- Comments
  purple = "#cc6699", -- Constants
  yellow = "#ccb866", -- Strings
  lightblue = "#6699cc", -- Top level definitions
  orange = "#a36a52", -- Warnings
}

-- Set background
vim.cmd("set background=dark")

-- Clear existing highlights
vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "simple"

-- Helper function to set highlights
local function hi(group, fg, bg, attr)
  local cmd = "highlight " .. group
  if fg then
    cmd = cmd .. " guifg=" .. fg
  end
  if bg then
    cmd = cmd .. " guibg=" .. bg
  end
  if attr then
    cmd = cmd .. " gui=" .. attr
  end
  vim.cmd(cmd)
end

-- Basic UI
hi("Normal", colors.fg, colors.bg)
hi("NonText", colors.fg, colors.bg)
hi("LineNr", "#888888", colors.bg)
hi("CursorLineNr", colors.fg, colors.bg, "bold")
hi("CursorLine", nil, "#2a2a2a")
hi("CursorColumn", nil, "#2a2a2a")
hi("VertSplit", "#444444", colors.bg)
hi("StatusLine", colors.green, colors.bg)
hi("StatusLineNC", "#888888", "#1a1a1a")
hi("Pmenu", colors.fg, "#2a2a2a")
hi("PmenuSel", colors.bg, colors.lightblue)

-- Syntax highlighting
hi("Comment", colors.comment, nil, "italic")
hi("String", colors.yellow)
hi("Character", colors.green)
hi("Number", colors.purple)
hi("Boolean", colors.purple)
hi("Float", colors.purple)
hi("Constant", colors.purple)

-- Keywords and definitions
hi("Function", colors.green)
hi("Identifier", colors.fg, nil, "italic")
hi("Type", colors.lightblue)
hi("TypeDef", colors.lightblue)
hi("Keyword", colors.fg)
hi("Statement", colors.fg)

-- Other elements
hi("Operator", colors.fg)
hi("Delimiter", colors.fg)
hi("Conditional", colors.fg)
hi("Repeat", colors.fg)
hi("Label", colors.fg)

-- Search and selection
hi("Search", colors.bg, colors.yellow)
hi("IncSearch", colors.bg, colors.yellow, "bold")
hi("Visual", nil, "#444444")

-- Diagnostics
hi("DiagnosticError", "#ff6b6b", colors.bg)
hi("DiagnosticInfo", colors.lightblue, colors.bg)
hi("DiagnosticHint", colors.yellow, colors.bg)
hi("DiagnosticWarn", colors.orange, colors.bg, "italic")

-- LSP Highlights
hi("LspInlayHint", colors.ghost)

-- changes hl bg color for markdown code blocks
hi("RenderMarkdownCode", nil, "#282828")

-- Personal Misc
hi("@markup.heading", colors.lightblue, nil, "bold")
hi("@lsp.type.comment.rust", colors.fg)
hi("DiagnosticUnnecessary", colors.orange, nil, "italic")
hi("RenderMarkdownCodeInline", colors.green)
hi("Special", colors.green)
hi("@label.markdown", colors.white)

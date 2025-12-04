-- Name: simple
-- Author: Matt Lucero (notasandworm@gmail.com)
-- Inspiration: zanshin/nvim-fourcolor-theme
-- Place this file at ~/.config/nvim/colors/simple.vim or as a lua colorscheme

local colors = {
  bg = "#1a1a1a", -- Dark background
  fg = "#bfbfbf", -- White foreground
  lightgray = "#747474", -- Light gray
  green = "#66cc85", -- Strings
  purple = "#cc6699", -- Constants
  yellow = "#ccb866", -- Comments
  lightblue = "#6699cc", -- Top level definitions
  orange = "#cc8566", -- Warnings
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
hi("StatusLine", colors.fg, "#2a2a2a")
hi("StatusLineNC", "#888888", "#1a1a1a")
hi("Pmenu", colors.fg, "#2a2a2a")
hi("PmenuSel", colors.bg, colors.lightblue)

-- Syntax highlighting
hi("Comment", colors.green)
hi("String", colors.yellow)
hi("Character", colors.green)
hi("Number", colors.purple)
hi("Boolean", colors.purple)
hi("Float", colors.purple)
hi("Constant", colors.purple)

-- Keywords and definitions
hi("Function", colors.fg, nil, "italic")
hi("Identifier", colors.fg, nil, "bold")
hi("Type", colors.lightblue, nil, "bold")
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
hi("DiagnosticWarn", colors.yellow, colors.bg)
hi("DiagnosticInfo", colors.lightblue, colors.bg)
hi("DiagnosticHint", colors.orange, colors.bg)

-- LSP Highlights
hi("LspInlayHint", colors.lightgray)

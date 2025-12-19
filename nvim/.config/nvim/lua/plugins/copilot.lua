return {
  "github/copilot.vim",
  init = function()
    -- This MUST be set before the plugin loads
    vim.g.copilot_no_tab_map = true
  end,
  config = function()
    -- Map <Tab> to accept suggestions
    -- The second argument is what to send if there is NO suggestion (usually a real Tab)
    vim.keymap.set("i", "<Tab>", 'copilot#Accept("\\<Tab>")', {
      expr = true,
      replace_keycodes = false,
    })
  end,
}


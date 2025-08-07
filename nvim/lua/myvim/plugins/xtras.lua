local extras = {
  -- "myvim.plugins.extras.coding.yanky",
  -- "myvim.plugins.extras.editor.leap",
  "myvim.plugins.extras.editor.snacks_explorer",
  "myvim.plugins.extras.editor.snacks_picker",
  "myvim.plugins.extras.coding.blink",
  -- "myvim.plugins.extras.lang.python",
  "myvim.plugins.extras.lang.rust",
  "myvim.plugins.extras.lang.java",
  -- "myvim.plugins.extras.lang.clangd",
  -- "myvim.plugins.extras.lang.cmake",
  -- "myvim.plugins.extras.formatting.prettier",
  -- "myvim.plugins.extras.test.core",
  -- "myvim.plugins.extras.dap.core",
}

if vim.g.vscode then
  table.insert(extras, 1, "myvim.plugins.extras.vscode")
end

---@param extra string
return vim.tbl_map(function(extra)
  return { import = extra }
end, extras)

return {
  'danymat/neogen',
  -- Uncomment next line if you want to follow only stable versions
  version = '*',
  opts = {
    snippet_engine = 'luasnip',
    enabled = true,
    vim.api.nvim_set_keymap('n', 'gd', ":lua require('neogen').generate()<CR>", { noremap = true, silent = true, desc = '[G]enerate [d]osctring' }),
  },
}

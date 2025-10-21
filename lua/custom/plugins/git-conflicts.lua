return {
  'sindrets/diffview.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    { '<C-g>', '<CMD>DiffviewOpen<CR>', mode = { 'n', 'i', 'v' } },
  },
  config = {
    keymaps = {
      view = {
        ['<C-g>'] = '<CMD>DiffviewClose<CR>',
      },
      file_panel = {
        ['<C-g>'] = '<CMD>DiffviewClose<CR>',
      },
    },
  },
}

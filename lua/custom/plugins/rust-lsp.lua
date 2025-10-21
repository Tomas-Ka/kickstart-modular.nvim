return {
  'mrcjkb/rustaceanvim',
  version = '^6', -- Recommended
  lazy = false, -- This plugin is already lazy
  config = function(self, opts)
    vim.g.rustaceanvim = vim.tbl_deep_extend('force', {}, {
      server = {
        on_attach = function(_, bufnr)
          -- Hover actions
          vim.keymap.set('n', 'K', function()
            vim.cmd.RustLsp { 'hover', 'actions' }
          end, { silent = true, buffer = bufnr })
          -- Code action groups
          vim.keymap.set('n', '<Leader>c', function()
            vim.cmd.RustLsp 'codeAction'
          end, { silent = true, buffer = bufnr })
        end,
      },
    })
  end,
}

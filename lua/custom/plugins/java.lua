return {
  'nvim-java/nvim-java',
  ft = 'java',
  dependencies = {
    'neovim/nvim-lspconfig',
  },
  config = function()
    require('java').setup {
      -- jdtls = { version = 'v1.46.1' },
      -- Your custom jdtls settings goes here
      jdk = {
        auto_install = false,
      },
      spring_boot_tools = {
        enable = false,
        version = '1.59.0',
      },
      java_test = {
        version = '0.43.1',
      },
    }

    require('lspconfig').jdtls.setup {
      -- Your custom nvim-java configuration goes here
      -- other jdtls settings...

      -- on_attach = function(_, bufnr)
      --   vim.keymap.set('n', 'gro', function()
      --     vim.lsp.buf.code_action {
      --       context = {
      --         only = { 'source.organizeImports' },
      --         triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Automatic,
      --       },
      --       apply = true,
      --     }
      --   end, { buffer = bufnr, desc = 'Organize imports' })
      --
      --   -- Example: Organize imports
      --   -- vim.keymap.set('n', '<leader>oi', function()
      --   --   vim.cmd 'JavaOrganizeImports'
      --   -- end, { buffer = bufnr, desc = 'Organize imports' })
      -- end,
      lazy = true,

      settings = {
        java = {
          configuration = {
            runtimes = {
              {
                name = 'JavaSE-21',
                path = '/usr/bin/java',
                default = true,
              },
            },
          },
        },
      },
    }
  end,
}

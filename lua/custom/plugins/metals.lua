local map = vim.keymap.set

return {
  'scalameta/nvim-metals',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'j-hui/fidget.nvim',
      opts = {},
    },
    {
      'mfussenegger/nvim-dap',
      config = function(self, opts)
        -- Debug settings if you're using nvim-dap
        local dap = require 'dap'

        dap.configurations.scala = {
          {
            type = 'scala',
            request = 'launch',
            name = 'RunOrTest',
            metals = {
              runType = 'runOrTestFile',
              --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
            },
          },
          {
            type = 'scala',
            request = 'launch',
            name = 'Test Target',
            metals = {
              runType = 'testTarget',
            },
          },
        }
      end,
    },
  },
  ft = { 'scala', 'sbt', 'java' },
  opts = function()
    local metals_config = require('metals').bare_config()

    -- Example of settings
    metals_config.settings = {
      showImplicitArguments = true,
      excludedPackages = { 'akka.actor.typed.javadsl', 'com.github.swagger.akka.javadsl' },
    }

    -- *READ THIS*
    -- I *highly* recommend setting statusBarProvider to either "off" or "on"
    --
    -- "off" will enable LSP progress notifications by Metals and you'll need
    -- to ensure you have a plugin like fidget.nvim installed to handle them.
    --
    -- "on" will enable the custom Metals status extension and you *have* to have
    -- a have settings to capture this in your statusline or else you'll not see
    -- any messages from metals. There is more info in the help docs about this
    metals_config.init_options.statusBarProvider = 'on'
    -- Example if you are using cmp how to make sure the correct capabilities for snippets are set
    metals_config.capabilities = require('cmp_nvim_lsp').default_capabilities()

    metals_config.on_attach = function(client, bufnr)
      require('metals').setup_dap()

      -- LSP mappings
      map('n', 'M', vim.lsp.buf.definition, { desc = 'Jumps to Definition' })
      map('n', 'K', vim.lsp.buf.hover, { desc = 'Peek at symbol info' })
      map('n', 'gi', vim.lsp.buf.implementation, { desc = 'Lists all symbol implementations' })
      map('n', 'gr', vim.lsp.buf.references, { desc = 'Lists all references to symbol' })
      map('n', 'gds', vim.lsp.buf.document_symbol, { desc = 'Lists all symbols in current buffer' })
      map('n', '<leader>cl', vim.lsp.codelens.run, { desc = 'Run the code lens' })
      map('n', '<leader>sh', vim.lsp.buf.signature_help, { desc = 'Show symbol signature info' })
      map('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename all references' })
      map('n', '<leader>f', vim.lsp.buf.format, { desc = 'Formats buffer' })
      map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Select code action' })

      map('n', '<leader>ws', function()
        require('metals').hover_worksheet()
      end, { desc = 'Expand decoration' })

      -- all workspace diagnostics
      map('n', '<leader>aa', vim.diagnostic.setqflist, { desc = 'Add diagnostics to quickfick list' })

      -- all workspace errors
      map('n', '<leader>ae', function()
        vim.diagnostic.setqflist { severity = vim.diagnostic.severity.ERROR }
      end, { desc = 'Add errors to quickfix list' })

      -- all workspace warnings
      map('n', '<leader>aw', function()
        vim.diagnostic.setqflist { severity = vim.diagnostic.severity.WARN }
      end, { desc = 'Add warnings to quickfix list' })

      -- buffer diagnostics only
      map('n', '<leader>d', vim.diagnostic.setloclist, { desc = 'Add buffer diagnostics to location list' })

      -- Example mappings for usage with nvim-dap. If you don't use that, you can
      -- skip these
      map('n', '<leader>dc', function()
        require('dap').continue()
      end)

      map('n', '<leader>dr', function()
        require('dap').repl.toggle()
      end)

      map('n', '<leader>dK', function()
        require('dap.ui.widgets').hover()
      end)

      map('n', '<leader>dt', function()
        require('dap').toggle_breakpoint()
      end)

      map('n', '<leader>dso', function()
        require('dap').step_over()
      end)

      map('n', '<leader>dsi', function()
        require('dap').step_into()
      end)

      map('n', '<leader>dl', function()
        require('dap').run_last()
      end)
    end

    return metals_config
  end,
  config = function(self, metals_config)
    local nvim_metals_group = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      pattern = self.ft,
      callback = function()
        require('metals').initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
  end,
}

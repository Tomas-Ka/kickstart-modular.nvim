return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { 'clj-kondo' },
      --   dockerfile = { 'hadolint' },
      --   inko = { 'inko' },
      --   janet = { 'janet' },
      --   json = { 'jsonlint' },
      --   markdown = { 'markdownlint-cli2', 'vale' },
      --   rst = { 'vale' },
      --   ruby = { 'ruby' },
      --   terraform = { 'tflint' },
      --   text = { 'vale' },
      --   python = { 'pflake8' },
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      lint.linters_by_ft['clojure'] = nil
      lint.linters_by_ft['dockerfile'] = { 'hadolint' }
      lint.linters_by_ft['inko'] = nil
      lint.linters_by_ft['janet'] = nil
      lint.linters_by_ft['json'] = { 'jsonlint' }
      lint.linters_by_ft['markdown'] = { 'markdownlint-cli2' } -- , 'vale' }
      lint.linters_by_ft['rst'] = nil
      lint.linters_by_ft['ruby'] = nil
      lint.linters_by_ft['terraform'] = nil
      lint.linters_by_ft['text'] = nil
      lint.linters_by_ft['python'] = { 'flake8' }
      lint.linters_by_ft['go'] = { 'golangcilint' }
      lint.linters_by_ft['java'] = { 'checkstyle' }

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- Only run the linter in buffers that you can modify in order to
          -- avoid superfluous noise, notably within the handy LSP pop-ups that
          -- describe the hovered symbol using Markdown.
          if vim.bo.modifiable then
            lint.try_lint()
          end
        end,
      })

      -- Hyprlang LSP
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter', 'InsertLeave' }, {
        pattern = { '*.hl', 'hypr*.conf' },
        callback = function(event)
          if vim.opt_local.modifiable:get() then
            -- print(string.format('starting hyprls for %s', vim.inspect(event)))
            vim.lsp.start {
              name = 'hyprlang',
              cmd = { 'hyprls' },
              root_dir = vim.fn.getcwd(),
            }
          end
        end,
      })

      local markdownlint = require 'lint.linters.markdownlint-cli2'
      -- markdownlint.args = {
      --   '--config',
      --   '/home/tom/.config/markdownlint/.markdownlint-cli2.yaml',
      --   '--',
      -- }
      local flake8 = require 'lint.linters.flake8'
      table.insert(flake8.args, '--max-line-length ')
      table.insert(flake8.args, '100')
    end,
  },
}

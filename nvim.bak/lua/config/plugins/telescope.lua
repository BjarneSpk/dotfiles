return {
  {
	  'nvim-telescope/telescope.nvim',
      version = '0.1.6',
	  dependencies = {
          {'nvim-lua/plenary.nvim'},
          {'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font},
      },
      config = function()
          local builtin = require('telescope.builtin')

          vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
          vim.keymap.set('n', '<C-p>', builtin.git_files, {})
          vim.keymap.set('n', '<leader>ps', function()
              builtin.grep_string({ search = vim.fn.input("Grep > ") })
          end)
          vim.keymap.set('n', '<leader>pg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      end
  },
}

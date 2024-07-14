return {
  {
	  'nvim-telescope/telescope.nvim', 
      version = '0.1.6',
	  dependencies = { {'nvim-lua/plenary.nvim'} }
  },
  { 'numToStr/Comment.nvim', opts = {} },
  {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate'
  },
  'nvim-lua/plenary.nvim',
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { {'nvim-lua/plenary.nvim'} }
  },
  'mbbill/undotree',

  'neovim/nvim-lspconfig',
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'hrsh7th/nvim-cmp', 
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'saadparwaiz1/cmp_luasnip',
  'L3MON4D3/LuaSnip',
  'rafamadriz/friendly-snippets',

  {
      "NeogitOrg/neogit",
      dependencies = {
          "nvim-lua/plenary.nvim",         -- required
          "sindrets/diffview.nvim",        -- optional - Diff integration

          "nvim-telescope/telescope.nvim", 
      },
      config = true
  }
}

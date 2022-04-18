-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function()
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	use({ "folke/lsp-colors.nvim" })
	use({ "kyazdani42/nvim-web-devicons" })

	-- Themes
	use({ "morhetz/gruvbox" })
	use({ "sainnhe/sonokai" })
	use({ "Th3Whit3Wolf/one-nvim" })
	use({ "projekt0n/github-nvim-theme" })
	use({ "tjdevries/colorbuddy.vim" })
	use({ "dracula/vim", as = "dracula" })
	use({ "shaunsingh/nord.nvim" })
	use({ "mcchrish/zenbones.nvim" })
	use({ "rktjmp/lush.nvim" })
	use("rebelot/kanagawa.nvim")
	use("tanvirtin/monokai.nvim")
	use("Mofiqul/vscode.nvim")
	use("yorik1984/newpaper.nvim")

	use({
		"folke/todo-comments.nvim",
		config = function()
			require("todo-comments").setup({})
		end,
	})

	use({
		"lewis6991/gitsigns.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("gitsigns").setup()
		end,
	})

	use({
		"folke/trouble.nvim",
		config = function()
			require("plugins.trouble")
		end,
	})

	use({
		"onsails/lspkind-nvim",
		config = function()
			require("lspkind").init({
				mode = "symbol_text",
				preset = "codicons",
				-- preset = "default",
			})
		end,
	})

	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("treesitter-config")
		end,
	})
	use({ "nvim-treesitter/playground" })
	use({
		"SmiteshP/nvim-gps",
		after = { "nvim-treesitter", "lspkind-nvim" },
		config = function()
			local getkind = function(kind)
				local kinds = vim.lsp.protocol.CompletionItemKind
				return kinds[kinds[kind]]:match("^.*%s")
			end
			require("nvim-gps").setup({
				icons = {
					["class-name"] = getkind("Class"),
					["function-name"] = getkind("Function"),
					["method-name"] = getkind("Method"),
					["container-name"] = getkind("Enum"),
					-- ["tag-name"] = ' '
				},
			})
		end,
	})
	use({ "iamcco/markdown-preview.nvim", run = "cd app && yarn install" })

	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
		config = function()
			require("plugins.telescope")
		end,
	})

	use({
		"nvim-telescope/telescope-file-browser.nvim",
		config = function()
			require("telescope").load_extension("file_browser")
		end,
	})

	use({
		"nvim-telescope/telescope-dap.nvim",
		after = { "telescope.nvim", "nvim-dap" },
		config = function()
			require("telescope").load_extension("dap")
		end,
	})

	use({ "Shougo/vimproc.vim", run = "make" })

	use({ "tpope/vim-fugitive" })
	use({ "idanarye/vim-merginal" })
	use({ "tpope/vim-unimpaired" })
	use({ "tpope/vim-sleuth" })

	use({
		"neovim/nvim-lspconfig",
		config = function()
			require("lsp")
		end,
	})

	use("jose-elias-alvarez/null-ls.nvim")

	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-buffer" })
	use({ "hrsh7th/cmp-path" })
	use({ "hrsh7th/cmp-cmdline" })
	use({
		"hrsh7th/nvim-cmp",
		config = function()
			require("plugins.cmp")
		end,
	})
	use({ "hrsh7th/cmp-nvim-lsp-signature-help" })
	use("b0o/schemastore.nvim")

	use({
		"L3MON4D3/LuaSnip",
		config = function()
			require("plugins.luasnip")
		end,
	})
	use("saadparwaiz1/cmp_luasnip")
	use("rafamadriz/friendly-snippets")

	use({
		"mfussenegger/nvim-dap",
		config = function()
			require("dap-config")
		end,
	})
	use({
		"rcarriga/nvim-dap-ui",
		after = "nvim-dap",
		module = "dapui",
		config = function()
			require("dapui").setup()
		end,
	})

	--use({
	--	"tamago324/lir.nvim",
	--	config = function()
	--		require("plugins.lir")
	--	end,
	--})

	use({ "Hoffs/omnisharp-extended-lsp.nvim" })
	use({ "b0o/mapx.nvim" })
	use({ "rcarriga/nvim-notify" })
	use({
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup({})
		end,
	})

	-- Terminal
	use({
		"akinsho/toggleterm.nvim",
		config = function()
			require("plugins.toggleterm")
		end,
	})

	use({
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup()
			vim.o.laststatus=3
		end,
	})

	use({
		"elihunter173/dirbuf.nvim"
	})


	--use({
	--	"rebelot/heirline.nvim",
	--	event = { "VimEnter" },
	--	config = function()
	--		require("plugins.heirline")
	--	end,
	--})

	use({ "glacambre/firenvim", run = "firenvim#install(0)" })
end)

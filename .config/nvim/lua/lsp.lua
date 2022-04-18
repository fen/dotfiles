local nvim_lsp = require("lspconfig")
local util = require("lspconfig/util")

vim.diagnostic.config({
	-- This disables the inline diagnostics shown in the editor
	virtual_text = false,
	signs = true,
	underline = true,
	-- true and diagnostics will update while in insert mode
	update_in_insert = true,
	severity_sort = false,
})

vim.cmd([[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})]])

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end
	-- Enable completion triggered by <c-x><c-o>
	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	local opts = { noremap = true, silent = true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
	buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	buf_set_keymap("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
	buf_set_keymap("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
	buf_set_keymap("n", "<space>=", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

	buf_set_keymap("n", "<leader>s", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", opts)
	buf_set_keymap("n", "<leader>d", "<cmd>Telescope diagnostics<CR>", opts)
	buf_set_keymap("n", "<leader>r", "<cmd>Telescope lsp_references<CR>", opts)
end

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.prettier.with({ filetypes = { "markdown" } }),
		null_ls.builtins.formatting.stylua,
	},
	on_attach = on_attach,
	capabilities = capabilities,
})

nvim_lsp.rust_analyzer.setup({
	on_attach = on_attach,
	flags = {
		debounce_text_changes = 150,
	},
	capabilities = capabilities,
})

-- Example custom server
-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ";")

nvim_lsp.sumneko_lua.setup({
	cmd = { "C:\\bin\\lua-language-server\\bin\\lua-language-server.exe" },
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim", "use" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

--local csharp_ls_bin = "/home/fen/src/cs/csharp-language-server/src/CSharpLanguageServer/bin/Release/net6.0/CSharpLanguageServer"
--nvim_lsp.csharp_ls.setup{
--    cmd = { csharp_ls_bin };
--    on_attach = on_attach;
--    capabilities = capabilities;
--}

local pid = vim.fn.getpid()
-- On linux/darwin if using a release build, otherwise under scripts/OmniSharp(.Core)(.cmd)
local omnisharp_bin = "OmniSharp"
-- on Windows
-- local omnisharp_bin = "/path/to/omnisharp/OmniSharp.exe"
nvim_lsp.omnisharp.setup({
	cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
	on_attach = on_attach,
	capabilities = capabilities,
	handlers = {
		["textDocument/definition"] = require("omnisharp_extended").handler,
	},
})

-- DENO
nvim_lsp.denols.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	root_dir = util.root_pattern("deno.json"),
	settings = {
		deno = {
			enable = true,
			importMap = "./import_map.json",
		},
	},
})

nvim_lsp.jsonls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
		},
	},
})

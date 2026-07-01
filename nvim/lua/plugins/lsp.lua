require("mason").setup()

require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"rust_analyzer",
		"clangd",
		"jdtls",
		"ts_ls",
		"jsonls",
		"sqlls",
	},
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- completion
vim.opt.completeopt = { "menu", "menuone", "noselect" }
local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
	mapping = cmp.mapping.preset.insert({
		["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
		["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
		["<Enter>"] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete(), -- Manually trigger suggestions
		["<C-e>"] = cmp.mapping.abort(),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" }, -- LSP suggestions
	}),
})

-- diagnostics
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

-- keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "<leader>vws", function()
			vim.lsp.buf.workspace_symbol()
		end, opts)
		vim.keymap.set("n", "<leader>vd", function()
			vim.diagnostic.open_float()
		end, opts)
		vim.keymap.set("n", "<leader>vrr", function()
			vim.lsp.buf.references()
		end, opts)
		vim.keymap.set("i", "<C-h>", function()
			vim.lsp.buf.signature_help()
		end, opts)

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

		vim.keymap.set("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)

		vim.keymap.set("n", "[d", function()
			vim.diagnostic.jump({
				count = -1,
				on_jump = function(diagnostic, bufnr)
					if diagnostic then
						vim.diagnostic.open_float(nil, { bufnr = bufnr })
					end
				end,
			})
		end, opts)
		vim.keymap.set("n", "]d", function()
			vim.diagnostic.jump({
				count = 1,
				on_jump = function(diagnostic, bufnr)
					if diagnostic then
						vim.diagnostic.open_float(nil, { bufnr = bufnr })
					end
				end,
			})
		end, opts)
	end,
})

-- lua
vim.lsp.config("lua_ls", {
	capabilities = capabilities,

	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},

			workspace = {
				checkThirdParty = false,
			},

			telemetry = {
				enable = false,
			},
		},
	},
})

-- rust
vim.lsp.config("rust_analyzer", {
	capabilities = capabilities,
})

-- c/c++
vim.lsp.config("clangd", {
	capabilities = capabilities,
})

-- js/ts
vim.lsp.config("ts_ls", {
	capabilities = capabilities,
})

-- json
vim.lsp.config("jsonls", {
	capabilities = capabilities,
})

-- sql
vim.lsp.config("sqlls", {
	capabilities = capabilities,
})

-- java
vim.lsp.config("jdtls", {
	capabilities = capabilities,
})

-- enable servers
vim.lsp.enable({
	"lua_ls",
	"rust_analyzer",
	"clangd",
	"ts_ls",
	"jsonls",
	"sqlls",
	"jdtls",
})

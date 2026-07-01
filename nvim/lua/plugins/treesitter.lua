require('plugins.packer')

local ts_parsers = {
  "bash",
  "c",
  "dockerfile",
  "fish",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "go",
  "gomod",
  "gosum",
  "html",
  "javascript",
  "json",
  "lua",
  "make",
  "markdown",
  "python",
  "rust",
  "sql",
  "toml",
  "tsx",
  "typescript",
  "typst",
  "vim",
  "yaml",
  "zig",
}

require("nvim-treesitter").setup({
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
    }
})

require("treesitter-context").setup({
  max_lines = 3,
  multiline_threshold = 1,
  separator = '-',
  min_window_height = 20,
  line_numbers = true,
})

local nts = require('nvim-treesitter')
nts.install(ts_parsers)

vim.api.nvim_create_autocmd('PackChanged', { callback = function() nts.update() end })

vim.api.nvim_create_autocmd("FileType", { -- enable treesitter highlighting and indents
  callback = function(args)
    local filetype = args.match
    local lang = vim.treesitter.language.get_lang(filetype)
    if vim.treesitter.language.add(lang) then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.treesitter.start()
    end
  end
})

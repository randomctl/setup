require('lualine').setup({
    options = {
        fmt = string.lower,
    },
    sections = {
        lualine_c = { { 'filename', path = 1 } }
    }
})

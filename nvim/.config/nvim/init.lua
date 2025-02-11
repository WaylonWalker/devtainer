--  ╭─────╮  ╭────────╮  ╭─────╮
--  │     │  │        │  │     │
--  │     │  │        │  │     │
--  │     │  │        │  │     │
--  │     ╰──╯        ╰──╯     │
--  │           init.lua       │
--  │           @_waylonwalker │
--  ╰──────────────────────────╯
--

waylonwalker = require("waylonwalker")
ww = waylonwalker
vim.filetype.add({
    filename = {
        ["Containerfile"] = "dockerfile",
    },
    pattern = {
        [".*%.containerfile$"] = "dockerfile",
    },
})
-- Fallback for files ending with *.containerfile
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.containerfile",
    callback = function()
        vim.bo.filetype = "dockerfile"
    end,
})

--  ╭─────╮  ╭────────╮  ╭─────╮
--  │     │  │        │  │     │
--  │     │  │        │  │     │
--  │     │  │        │  │     │
--  │     ╰──╯        ╰──╯     │
--  │           init.lua       │
--  │           @_waylonwalker │
--  ╰──────────────────────────╯
--
do
    local treesitter_start = vim.treesitter.start

    vim.treesitter.start = function(bufnr, lang)
        local target_buf = bufnr
        if target_buf == nil or target_buf == 0 then
            target_buf = vim.api.nvim_get_current_buf()
        end

        local filetype = vim.bo[target_buf].filetype
        if lang == "markdown" or lang == "markdown_inline" or filetype == "markdown" then
            return false
        end

        return treesitter_start(target_buf, lang)
    end
end

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

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function(args)
        vim.bo[args.buf].syntax = "markdown"
        vim.schedule(function()
            if vim.api.nvim_buf_is_valid(args.buf) then
                pcall(vim.treesitter.stop, args.buf)
            end
        end)
    end,
})

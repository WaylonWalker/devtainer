local settings = require'waylonwalker.settings'
local augroup = vim.api.nvim_create_augroup   -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd   -- Create autocommand

local M = {}

M.waylonwalker_augroup = augroup('waylonwalker', { clear = true })

M.sync_packer = function()
    print('syncing')
    vim.cmd("runtime lua/waylonwalker/packer.lua")
    require("packer").sync()
end

-- automatically run PackerSync on save of plugins.lua
if settings.packer_auto_sync then
  -- source plugins.lua and run PackerSync on save
  autocmd({ "BufWritePost" }, {
    group=M.waylonwalker_augroup,
    pattern = { "packer.lua" },
    callback = M.sync_packer,
  })
end

M.format_python = function()
    if settings.auto_format.python then
        vim.cmd('silent execute "%!tidy-imports --black --quiet --replace-star-imports --replace --add-missing --remove-unused " . bufname("%")')
        vim.cmd('silent execute "%!isort " . bufname("%")')
        vim.cmd('silent execute "%!black " . bufname("%")')
    end
end

autocmd({ "BufWritePost" }, {
    group=M.waylonwalker_augroup,
    pattern = { "*.py" },
    callback = M.format_python,
})

M.format_markdown = function()
    if settings.auto_format.markdown then
        vim.cmd('silent execute "!tree-sitter-formatter " . bufname("%")')
    end
end


autocmd({ "BufWritePost" }, {
    group=M.waylonwalker_augroup,
    pattern = { "*.md" },
    callback = M.format_markdown,
})

M.format_html = function()
    if settings.auto_format.markdown then
        vim.cmd('silent execute "!prettier --write " . bufname("%")')
    end
end

autocmd({ "BufWritePost" }, {
    group=M.waylonwalker_augroup,
    pattern = { "*.html" },
    callback = M.format_html,
})

M.format_javascript = function()
    if settings.auto_format.javascript then
        vim.cmd('silent execute "!prettier --write " . bufname("%")')
    end
end

autocmd({ "BufWritePost" }, {
    group=M.waylonwalker_augroup,
    pattern = { "*.js" },
    callback = M.format_javascript,
})

M.format_json = function()
    if settings.auto_format.json then
        vim.cmd('silent execute "%!jq \'\'"')
    end
end


autocmd({ "BufWritePost" }, {
    group=M.waylonwalker_augroup,
    pattern = { "*.json" },
    callback = M.format_json,
})

M.format_yaml = function()
    if settings.auto_format.yaml then
        vim.cmd('silent execute "%!yamlfmt"')
    end
end

autocmd({ "BufWritePost" }, {
    group=M.waylonwalker_augroup,
    pattern = { "*.yaml", "*.yml" },
    callback = M.format_yaml,
})




return M


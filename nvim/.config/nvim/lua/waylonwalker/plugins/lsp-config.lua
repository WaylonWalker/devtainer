-- SETUP
local navic = require("nvim-navic")
local navbuddy = require("nvim-navbuddy")

local null_ls = require("null-ls")

local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local FORMATTING = methods.internal.FORMATTING

null_ls.builtins.formatting.tidy_import = h.make_builtin({
    name = "tidy_import",
    meta = {
        url = "https://github.com/deshaw/pyflyby",
        description = "automatic imports for python",
    },
    method = FORMATTING,
    filetypes = { "python" },
    generator_opts = {
        command = "tidy-imports",
        args = {
            "--black",
            "--quiet",
            "--replace-star-imports",
            "--add-missing",
            "--replace",
            "--remove-unused",
            "$FILENAME",
        },
        to_stdin = false,
        to_temp_file = true,
    },
    factory = h.formatter_factory,
})

null_ls.builtins.formatting.djhtml = h.make_builtin({
    name = "djhtml",
    meta = {
        url = "https://github.com/rtts/djhtml",
        description = "",
    },
    method = FORMATTING,
    filetypes = { "html", "htmldjango" },
    generator_opts = {
        command = "djhtml",
        args = {
            "$FILENAME",
        },
        to_stdin = false,
        to_temp_file = true,
    },
    factory = h.formatter_factory,
})

null_ls.builtins.formatting.rustywind = h.make_builtin({
    name = "rustywind",
    meta = {
        url = "",
        description = "",
    },
    method = FORMATTING,
    filetypes = { "html", "htmldjango" },
    generator_opts = {
        command = "rustywind",
        args = {
            "--write",
            "$FILENAME",
        },
        to_stdin = false,
        to_temp_file = true,
    },
    factory = h.formatter_factory,
})

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
    sources = {
        -- -- formatting
        null_ls.builtins.formatting.beautysh,
        null_ls.builtins.formatting.black.with({ extra_args = { "--fast" } }),
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.json_tool,
        null_ls.builtins.formatting.fixjson,
        null_ls.builtins.formatting.markdownlint,
        -- null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.djhtml,
        null_ls.builtins.formatting.rustywind,
        null_ls.builtins.formatting.sqlformat,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.tidy_import,
        null_ls.builtins.formatting.trim_newlines,
        null_ls.builtins.formatting.trim_whitespace,
        null_ls.builtins.formatting.yamlfmt,

        -- diagnostics
        null_ls.builtins.diagnostics.alex,
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.diagnostics.markdownlint,
        -- null_ls.builtins.diagnostics.proselint,
        -- null_ls.builtins.diagnostics.pydocstyle,
        -- null_ls.builtins.diagnostics.vale,

        -- completions
        null_ls.builtins.completion.spell,
    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                -- pattern = { "!*.jinja" },
                -- group = M.waylonwalker_augroup,
                group = augroup,
                buffer = bufnr,
                callback = function()
                    -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                    vim.lsp.buf.format({ async = false })
                end,
            })
        end
    end,
})

--- CREDIT THEPRIMEAGEN -> PYPEADAY
local nnoremap = require("waylonwalker.keymap").nnoremap

local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
    "bashls",
    "docker_compose_language_service",
    "dockerls",
    "grammarly",
    "helmls",
    "html",
    "jedi_language_server",
    "jsonls",
    "marksman",
    "prosemd_lsp",
    "pylsp",
    "ruff_lsp",
    "tailwindcss",
    "taplo",
    "terraformls",
    "yamlls",
    -- "llm-ls",
    -- "sumneko_lua",
    -- "tailwindcss-colors",
    -- "tailwindcss-language-server",
})

require("mason-null-ls").setup({
    ensure_installed = nil,
    automatic_installation = true,
    automatic_setup = false,
})

-- Fix Undefined global 'vim'
lsp.configure("sumneko_lua", {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            inlay_hints = {
                enabled = true,
            },
        },
    },
})

-- lsp.configure("tailwindcss-colors", {
--     settings = {},
-- })

lsp.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    -- require("tailwindcss-colors").buf_attach(bufnr)
end)

lsp.configure("pylsp", {
    settings = {
        pylsp = {
            configurationSources = { "flake8" },
            plugins = {
                pycodestyle = { enabled = false },
                flake8 = { enabled = false },
                mypy = {
                    enabled = true,
                    live_mode = true,
                    strict = true,
                },
                jedi_completion = { fuzzy = true, enabled = true },
                jedi_hover = { enabled = true },
                jedi_references = { enabled = true },
                jedi_signature_help = { enabled = true },
                jedi_symbols = { enabled = true, all_scopes = true },
                inlay_hints = {
                    enabled = true,
                },
            },
        },
    },
})

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_sources = {
    { name = "luasnip" },
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },
    { name = "nvim_lua" },
    { name = "treesitter" },
    { name = "buffer" },
    { name = "path" },
    { name = "tmux" },
    { name = "spell" },
}
local lspkind = require("lspkind")
local cmp_formatting = {
    format = lspkind.cmp_format({
        mode = "symbol", -- show only symbol annotations
        maxwidth = 50,   -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
    }),
}
local cmp_mappings = lsp.defaults.cmp_mappings({
    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-d>"] = cmp.mapping.scroll_docs(4), -- yes 4 is down
    ["<C-f>"] = cmp.mapping.scroll_docs(-4), --yes -4 is up
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
    }),
})

-- disable completion with tab
-- this helps with copilot setup
cmp_mappings["<Tab>"] = nil
cmp_mappings["<S-Tab>"] = nil

cmp.setup({
    snippet = {
        expand = function(args)
            -- For `luasnip` user.
            require("luasnip").lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
    },
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings,
    sources = cmp_sources,
    formatting = cmp_formatting,
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = "",
        warn = "",
        -- hint = "",
        info = "",
    },
})

-- " nnoremap <silent> <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap("<silent>(( ", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
nnoremap("<silent>)) ", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")

nnoremap("<leader>vd", "<cmd>lua vim.lsp.buf.definition()<CR>")
nnoremap("<leader>vD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
nnoremap("<leader>vh", "<cmd>lua vim.lsp.buf.hover()<CR>")
nnoremap("<leader>vi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
nnoremap("<leader>vsh", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
-- nnoremap("<leader>vrr", "<cmd>lua vim.lsp.buf.references()<CR>")
nnoremap("<leader>vrr", ":Telescope lsp_references<CR>")
nnoremap("<leader>vrn", "<cmd>lua vim.lsp.buf.rename()<CR>")
nnoremap("<leader>vca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
-- " show_line_diagnostics deprecated for open_float
nnoremap("<leader>vsd", " vim.diagnostic.open_float()<CR>  ")
nnoremap("<leader>vsl", "<cmd> lua vim.diagnostic.setloclist({open=false})<CR>")
nnoremap("<leader>vn", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")

lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
})

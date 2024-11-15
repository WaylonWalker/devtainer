require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "python",
    "regex",
    "lua",
    "javascript",
    "bash",
    "toml",
    "rst",
    "html",
    "json",
    "yaml",
  }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,       -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
  },
  swap = {
    enable = true,
    swap_next = {
      ["<leader>fj"] = "@function.outer",
    },
    swap_previous = {
      ["<leader>fk"] = "@function.outer",
    },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<leader>o",
      scope_incremental = "<leader>O",
      node_incremental = "<leader>o",
      node_decremental = "<leader>i",
    },
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aB"] = "@block.outer",
        ["iB"] = "@block.inner",

        -- Or you can define your own textobjects like this
        -- ["iF"] = {
        --   python = "(function_definition) @function",
        --   cpp = "(function_definition) @function",
        --   c = "(function_definition) @function",
        --   java = "(method_declaration) @function",
        -- },
      },
    },
    lsp_interop = {
      enable = true,
      border = "none",
      peek_definition_code = {
        ["gh"] = "@function.outer",
        ["gH"] = "@class.outer",
      },
    },
  },
})

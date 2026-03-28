#!/usr/bin/env bash
# Simple keybinding data extractor using NVim API

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT_FILE="${REPO_ROOT}/keybinding_data.json"

echo "🔍 Extracting keybindings using NVim API..."

# Create the data structure with proper environment format
NVIM_APPNAME=wwtest nvim --headless -c "lua
local result = {
    environments = {
        neovim = {
            raw = {
                metadata = {
                    timestamp = os.date('%Y-%m-%dT%H:%M:%S'),
                    neovim_version = vim.version().string,
                    extraction_method = 'nvim_api'
                },
                keymaps = {}
            },
            categorized = {}
        }
    }
}

local modes = {
    ['n'] = 'normal',
    ['i'] = 'insert', 
    ['v'] = 'visual_select',
    ['x'] = 'visual',
    ['s'] = 'select',
    ['o'] = 'operator_pending',
    ['l'] = 'language_arg',
    ['c'] = 'command_line',
    ['t'] = 'terminal'
}

-- Extract global keymaps for each mode
for mode_code, mode_name in pairs(modes) do
    local keymaps = vim.api.nvim_get_keymap(mode_code)
    if #keymaps > 0 then
        -- Filter out default mappings
        local filtered_keymaps = {}
        for _, keymap in ipairs(keymaps) do
            -- Skip default vim mappings
            if not keymap.lhs:match('^<[A-Z][a-z]*$') and
               not keymap.lhs:match('^<%-.*-$>') then
                table.insert(filtered_keymaps, {
                    lhs = keymap.lhs,
                    rhs = type(keymap.rhs) == 'function' and 'lua_function' or tostring(keymap.rhs),
                    desc = keymap.desc or '',
                    mode = mode_name,
                    noremap = keymap.noremap,
                    silent = keymap.silent,
                    scriptname = keymap.scriptname or '',
                    buffer = keymap.buffer or 0
                })
            end
        end
        result.environments.neovim.raw.keymaps[mode_code] = filtered_keymaps
    end
end

-- Categorize keybindings
local categories = {
    navigation = {},
    ['window-management'] = {},
    editing = {},
    search = {},
    git = {},
    lsp = {},
    terminal = {},
    files = {},
    media = {},
    layout = {},
    tag = {},
    client = {},
    awesome = {},
    other = {}
}

-- Simple categorization based on descriptions and keys
for mode_code, keymaps in pairs(result.environments.neovim.raw.keymaps) do
    for _, keymap in ipairs(keymaps) do
        local lhs = keymap.lhs:lower()
        local desc = keymap.desc:lower()
        local rhs = keymap.rhs:lower()
        
        local categorized = false
        
        -- Navigation
        if lhs:match('^[hjklwbe]$') or lhs:match('^gg') or lhs:match('^g[%.]') or
           lhs:match('^%[%w') or lhs:match('^%]%w') or lhs:match('^%*') or lhs:match('^#') or
           desc:match('jump') or desc:match('go to') or desc:match('navigate') or
           desc:match('diagnostic') then
            table.insert(categories.navigation, keymap)
            categorized = true
        -- Window management
        elseif lhs:match('^<c%-w>') or lhs:match('^<c%-hjkl>') or lhs:match('^<c%-arrow>') or
               desc:match('window') or desc:match('split') then
            table.insert(categories['window-management'], keymap)
            categorized = true
        -- Editing
        elseif lhs:match('^[cdsyx]$') or lhs:match('^<c%-[adfgimnprstvxyz]>') or
               desc:match('edit') or desc:match('delete') or desc:match('change') or
               desc:match('yank') or desc:match('comment') then
            table.insert(categories.editing, keymap)
            categorized = true
        -- Search
        elseif lhs:match('^[/?]$') or lhs:match('^n') or lhs:match('^N') or
               desc:match('search') or desc:match('find') or desc:match('fzf') then
            table.insert(categories.search, keymap)
            categorized = true
        -- Git
        elseif rhs:match('git') or desc:match('git') or lhs:match('^<leader>g') then
            table.insert(categories.git, keymap)
            categorized = true
        -- LSP
        elseif rhs:match('lsp') or desc:match('lsp') or lhs:match('^g[rd]') or
           lhs:match('^<leader>l') then
            table.insert(categories.lsp, keymap)
            categorized = true
        -- If not categorized, put in other
        else
            table.insert(categories.other, keymap)
        end
    end
end

result.environments.neovim.categorized = categories

-- Output JSON
print(vim.json.encode(result))
" -c "qa" > "${OUTPUT_FILE}" 2>&1

# Check if extraction succeeded
if [[ -f "${OUTPUT_FILE}" && -s "${OUTPUT_FILE}" ]]; then
    echo "✅ Successfully extracted Neovim keybindings to ${OUTPUT_FILE}"
else
    echo "❌ Failed to extract Neovim keybindings"
    exit 1
fi

# Show summary
if [[ -f "${OUTPUT_FILE}" ]]; then
    echo "📊 Extraction Summary:"
    echo "File: ${OUTPUT_FILE}"
    echo "Size: $(wc -c < "${OUTPUT_FILE}") bytes"
    
    # Simple count of keymaps
    if command -v jq >/dev/null 2>&1; then
        total_keymaps=$(jq '.environments.neovim.raw.keymaps | to_entries | map(.value | length) | add' "${OUTPUT_FILE}" 2>/dev/null || echo "N/A")
        echo "Total keymaps: ${total_keymaps}"
    fi
fi
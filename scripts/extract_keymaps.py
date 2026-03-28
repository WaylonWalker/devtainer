#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.10"
# dependencies = []
# ///

"""
Neovim keymap extractor with improved categorization.
"""

from __future__ import annotations
import json
import subprocess
import sys
import tempfile
import os
from pathlib import Path


def extract_neovim_keymaps():
    """Extract keymaps using Neovim's nvim_get_keymap API with improved categorization."""

    lua_script = """
local function extract_keymaps()
    local result = {
        metadata = {
            timestamp = os.date("%Y-%m-%dT%H:%M:%S"),
            neovim_version = vim.version().string,
            extraction_method = "nvim_api"
        },
        keymaps = {}
    }
    
    local modes = {"n", "i", "v", "c", "t"}
    
    for _, mode in ipairs(modes) do
        local keymaps = vim.api.nvim_get_keymap(mode)
        local filtered_keymaps = {}
        for _, keymap in ipairs(keymaps) do
            if keymap.lhs and not keymap.lhs:match("^<[A-Z][a-z]*$") and
                   not keymap.lhs:match("^<%-.*-$>") then
                    local rhs_str = type(keymap.rhs) == "function" and "<lua_function>" or tostring(keymap.rhs)
                    local desc = keymap.desc and keymap.desc or ""
                    local mode_name = mode == "n" and "normal" or
                                      mode == "i" and "insert" or
                                      mode == "v" and "visual" or
                                      mode == "c" and "command" or
                                      mode == "t" and "terminal" or
                    table.insert(filtered_keymaps, {
                        lhs = keymap.lhs,
                        rhs = rhs_str,
                        desc = desc,
                        mode = mode_name,
                        noremap = keymap.noremap,
                        silent = keymap.silent,
                        scriptname = keymap.scriptname and keymap.scriptname or "",
                        buffer = keymap.buffer or 0
                    })
                end
            end
            result.keymaps[mode] = filtered_keymaps
        end
    end
    
    return result
end

-- Execute and write to stdout
local ok, data = pcall(extract_keymaps)
if ok then
    print(vim.json.encode(data))
else
    print('{"error": "extraction_failed"}')
end
"""

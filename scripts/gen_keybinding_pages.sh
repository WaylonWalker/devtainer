#!/usr/bin/env bash
# Keybinding page generator for markata-go
# Creates markdown pages from extracted keybinding data

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATA_FILE="${REPO_ROOT}/keybinding_data.json"
PAGES_DIR="${REPO_ROOT}/pages"

# Create directories
mkdir -p "${PAGES_DIR}/keybindings"

# Check if data file exists
if [[ ! -f "${DATA_FILE}" ]]; then
    echo "❌ Keybinding data file not found: ${DATA_FILE}"
    echo "Run extract_keymaps.py first to generate data"
    exit 1
fi

# Function to generate a keybinding group page
generate_page() {
    local category="$1"
    local category_title="$2"
    local category_intro="$3"
    local env_name="$4"
    
    local page_file="${PAGES_DIR}/keybindings/${env_name}-${category}.md"
    
    cat > "${page_file}" << EOF
---
title: "${category_title} - ${env_name^} Keybindings"
slug: "${env_name}-${category}"
date: $(date +%Y-%m-%d)
published: true
tags: ["${env_name}", "keybindings", "${category}"]
description: "${category_title} keybindings for ${env_name^}"
environment: "${env_name}"
category: "${category}"
aliases: ["${env_name}-${category}"]
---

${category_intro}

## Keybindings

| Key | Mode | Description |
|-----|------|-------------|
EOF
    
    # Add keybindings from data
    local count=$(jq ".environments.${env_name}.categorized.${category} // [] | length" "${DATA_FILE}" 2>/dev/null || echo "0")
    if [[ $count -gt 0 ]]; then
        jq -r ".environments.${env_name}.categorized.${category}[] | \"| \\(.lhs) | \\(.mode) | \\(.desc) |\"" "${DATA_FILE}" >> "${page_file}"
    fi
    
    echo "📝 Generated ${page_file}"
}

# Main generation logic
main() {
    echo "🚀 Generating keybinding pages..."
    
    # Generate complete list page
    local complete_list="${PAGES_DIR}/keybindings/complete-list.md"
    cat > "${complete_list}" << EOF
---
title: "Complete Keybindings List"
slug: "keybindings-complete-list"
date: $(date +%Y-%m-%d)
published: true
tags: ["keybindings", "reference", "complete"]
description: "Complete alphabetical list of all keybindings across all environments"
aliases: ["keybindings-complete-list"]
---

All keybindings across Neovim and Awesome WM environments, organized alphabetically for quick reference.

EOF

    # Add Neovim keybindings if data exists
    if jq -e ".environments.neovim" "${DATA_FILE}" >/dev/null; then
        echo "" >> "${complete_list}"
        echo "## Neovim Keybindings" >> "${complete_list}"
        echo "" >> "${complete_list}"
        
        # Use Python to generate sorted keybindings
        python3 << PYEOF >> "${complete_list}"
import json
with open('${DATA_FILE}', 'r') as f:
    data = json.load(f)

# Get all neovim keymaps and sort by key
keymaps = []
for mode, mode_keymaps in data.get('environments', {}).get('neovim', {}).get('raw', {}).get('keymaps', {}).items():
    for keymap in mode_keymaps:
        key = keymap.get('lhs', '')
        mode = keymap.get('mode', '')
        desc = keymap.get('desc', '')
        rhs = keymap.get('rhs', '')
        
        if key and not key.startswith('<'):
            keymaps.append({
                'key': key,
                'mode': mode,
                'description': desc,
                'rhs': rhs
            })

# Sort by key, then by mode
keymaps.sort(key=lambda x: (x['key'].lower(), x['mode'], x['description'].lower()))

# Output markdown table
print('| Key | Mode | Description | Command |')
print('|-----|------|-------------|----------|')
for keymap in keymaps:
    key = keymap['key'].replace('|', '\\\\|')
    desc = keymap['description'].replace('|', '\\\\|')
    rhs = keymap['rhs'].replace('|', '\\\\|')
    mode_cap = keymap['mode'].capitalize()
    print(f'| \`{key}\` | {mode_cap} | {desc} | {rhs} |')
PYEOF
        
        echo "" >> "${complete_list}"
    fi
    
    echo "📝 Created ${complete_list}"

    # Generate environment index pages
    for env in neovim awesome; do
        if ! jq -e ".environments.${env}" "${DATA_FILE}" >/dev/null; then
            echo "⚠️  No ${env} data found, skipping"
            continue
        fi
        
        # Generate environment index
        local env_index="${PAGES_DIR}/keybindings/${env}-keybindings.md"
        cat > "${env_index}" << EOF
---
title: "${env^} Keybindings Reference"
slug: "${env}-keybindings"
date: $(date +%Y-%m-%d)
published: true
tags: ["${env}", "keybindings", "reference"]
description: "Complete reference for ${env^} keybindings organized by category"
environment: "${env}"
aliases: ["${env}-keybindings"]
---

Complete reference for ${env^} keybindings organized by functional category.

## Categories

EOF
        
        # Add categories
        local categories=(
            "navigation:Navigation and Movement"
            "window-management:Window Management"
            "editing:Text Editing"
            "search:Search and Find"
            "git:Git Operations"
            "lsp:LSP and IntelliSense"
            "terminal:Terminal Operations"
            "files:File Operations"
            "media:Media Controls"
            "layout:Layout Management"
            "tag:Workspace Tag Operations"
            "client:Client Window Operations"
            "awesome:Awesome WM Core"
            "other:Other"
        )
        
        for category_info in "${categories[@]}"; do
            IFS=: read -r category category_title <<< "${category_info}"
            local count=$(jq ".environments.${env}.categorized.${category} // [] | length" "${DATA_FILE}" 2>/dev/null || echo "0")
            if [[ $count -gt 0 ]]; then
                echo "- [[${env}-${category}|${category_title}]] (${count} keybindings)" >> "${env_index}"
            fi
        done
        
        # Add complete list link
        echo "- [[keybindings-complete-list|Complete List (Alphabetical)]]" >> "${env_index}"
        
        echo "📝 Generated ${env_index}"
        
        # Generate individual category pages
        for category_info in "${categories[@]}"; do
            IFS=: read -r category category_title <<< "${category_info}"
            
            # Get intro text for category
            local category_intro=""
            case $category in
                "navigation") category_intro="Move through your code efficiently. Jump between files, symbols, and references." ;;
                "window-management") category_intro="Split, arrange, and navigate editor windows. Keep multiple files visible and organized." ;;
                "editing") category_intro="Edit text faster with powerful selection, manipulation, and transformation commands." ;;
                "search") category_intro="Find anything in your project instantly. Search files, symbols, and text." ;;
                "git") category_intro="Manage version control without leaving your editor. Stage, commit, diff, and browse history." ;;
                "lsp") category_intro="Navigate code like an IDE. Jump to definitions, view documentation, and fix errors." ;;
                "terminal") category_intro="Access your shell without leaving your editor. Run commands and build tools." ;;
                "files") category_intro="Open, save, and manage files quickly. Browse your project structure." ;;
                "media") category_intro="Control playback and volume from your keyboard. Manage media." ;;
                "layout") category_intro="Switch between window layouts. Optimize your workspace." ;;
                "tag") category_intro="Jump between workspace tags and views. Organize windows." ;;
                "client") category_intro="Focus and manage application windows. Switch between programs." ;;
                "awesome") category_intro="Control your window manager. Launch applications." ;;
                *) category_intro="Utility commands for productivity enhancements." ;;
            esac
                
            generate_page "$category" "$category_title" "$category_intro" "$env"
        done
    done
    
    # Generate main keybindings index
    local main_index="${PAGES_DIR}/keybindings.md"
    cat > "${main_index}" << EOF
---
title: "Keybindings Reference"
slug: "keybindings"
date: $(date +%Y-%m-%d)
published: true
tags: ["keybindings", "reference"]
description: "Complete reference for all keybindings across Neovim and Awesome WM environments"
aliases: ["keybindings"]
---

Complete reference for all keybindings across Neovim and Awesome WM environments.

## Environments

EOF
    
    # Add environment links
    for env in neovim awesome; do
        if jq -e ".environments.${env}" "${DATA_FILE}" >/dev/null; then
            local total=$(jq ".environments.${env}.categorized | to_entries | map(.value | length) | add" "${DATA_FILE}" 2>/dev/null || echo "0")
            echo "- [[${env}-keybindings|${env^} Keybindings]] (${total} keybindings)" >> "${main_index}"
        fi
    done
    
    # Add complete list link
    echo "- [[keybindings-complete-list|Complete List (Alphabetical)]]" >> "${main_index}"
    
    echo ""
    echo "📝 Generated ${main_index}"
    echo "✅ Keybinding pages generation complete!"
    echo "📂 Pages directory: ${PAGES_DIR}/keybindings"
}

# Run main function
main "$@"
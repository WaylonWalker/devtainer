local cmp = require('cmp')
local scan = require('plenary.scandir')

vim.notify("wikilinks source loaded")

local function get_slugs()
  local slugs = {}
  scan.scan_dir('pages', {
    search_pattern = '%.md$',
    on_insert = function(entry)
      local slug = entry:match('pages/(.+)%.md$')
      if slug then
        slug = slug:match('([^/]+)$')
        table.insert(slugs, slug)
      end
    end,
  })
  print("Slugs found:", vim.inspect(slugs))
  return slugs
end

local source = {}

function source:is_available()
  print("wikilinks source:is_available called, filetype:", vim.bo.filetype)
  vim.notify("wikilinks source:is_available called, filetype: " .. vim.bo.filetype)
  return vim.bo.filetype == 'markdown'
end

function source:complete(params, callback)
  print("wikilinks completion called, line:", params.context.cursor_before_line)
  vim.notify("wikilinks completion called, line: " .. params.context.cursor_before_line)
  local line = params.context.cursor_before_line
  if not line:match('%[%[%w*$') then
    print("wikilinks: pattern not matched, not triggering completion")
    callback({ items = {}, isIncomplete = false })
    return
  end
  local items = {}
  for _, slug in ipairs(get_slugs()) do
    table.insert(items, { label = slug, kind = cmp.lsp.CompletionItemKind.File })
  end
  print("wikilinks: providing completion items:", vim.inspect(items))
  vim.notify("wikilinks: providing completion items:", vim.inspect(items))
  callback({ items = items, isIncomplete = false })
end

return source

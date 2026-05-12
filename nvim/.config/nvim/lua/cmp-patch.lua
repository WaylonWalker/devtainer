-- Patch for nvim-cmp userdata errors (glsl_analyzer LSP, etc.)
-- Fixes: "attempt to get length of local 'response' (a userdata value)"
local misc = require('cmp.utils.misc')
local _ensure_nil = misc.ensure_nil
misc.ensure_nil = function(value)
  if type(value) == 'userdata' or value == vim.NIL then
    return nil
  end
  return _ensure_nil(value)
end
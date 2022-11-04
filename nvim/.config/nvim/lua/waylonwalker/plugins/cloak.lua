require('cloak').setup({
  enabled = true,
  patterns = {
    {
      -- Match any file starting with '.yml'.
      file_pattern = 'credentials.yml',
      -- Match a con: sign and any character after it.
      cloak_pattern = ':.+'
    },
  },
})

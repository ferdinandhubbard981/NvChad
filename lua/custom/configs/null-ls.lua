local present, null_ls = pcall(require, "null-ls")
local h = require("null-ls.helpers")
local methods = require("null-ls.methods")
local DIAGNOSTICS_ON_SAVE = methods.internal.DIAGNOSTICS_ON_SAVE

if not present then
  return
end

local b = null_ls.builtins

local sources = {

  -- webdev stuff
  b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
  b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } }, -- so prettier works only on these filetypes

  -- Lua
  b.formatting.stylua,

  -- cpp
  b.formatting.clang_format,
}

-- Define custom clang-tidy diagnostic generator
local clang_tidy = {
  name = "clang-tidy",
  method = DIAGNOSTICS_ON_SAVE,
  filetypes = { "c", "cpp" },
  generator_opts = {
      command = "/opt/sdk/camo/2.3.0.0/sysroots/x86_64-camosdk-linux/usr/bin/clang-tidy",
      args = {
          "$FILENAME",
      },
      from_stderr = true,
      format = "line",
      check_exit_code = function(code)
          return code <= 1
      end,
      on_output = h.diagnostics.from_pattern(":(%d+):(%d+): (%w+): (.*)$", { "row", "col", "severity", "message" }),
  },
  factory = h.generator_factory,
}

-- Add clang-tidy diagnostic generator to sources
table.insert(sources, clang_tidy)

null_ls.setup {
  debug = true,
  sources = sources,
}

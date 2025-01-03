-- Lightweight yet powerful formatter plugin for Neovim

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo", "Format" },
  -- stylua: ignore
  keys = {
    { "<leader>cf", function() require("conform") vim.cmd("Format") end, mode = "", desc = "Format buffer(selection)" },
  },
  opts = {
    formatters_by_ft = {
      -- Good defaults
      lua = { "stylua" },
      -- Conform will run multiple formatters sequentially
      python = { "isort", "black" },
      -- You can customize some of the format options for the filetype (:help conform.format)
      rust = { "rustfmt", lsp_format = "fallback" },
      -- Conform will run the first available formatter
      javascript = { "prettierd", "prettier", stop_after_first = true },
      sh = { "shfmt" },
      go = { "goimports", "gofmt" },
    },
    formatters = {
      shfmt = {
        prepend_args = { "-i", "2" },
      },
    },
    -- Set default options
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 1000, lsp_format = "fallback" }
    end,
  },
  config = function(_, opts)
    require("conform").setup(opts)

    vim.api.nvim_create_user_command("Format", function(args)
      -- Range format something like works, but nearest lines
      -- outside of range by +-1 also formatted (bug?)
      local range = nil
      if args.count ~= -1 then
        local end_line =
          vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      require("conform").format({
        async = true,
        lsp_format = "fallback",
        range = range,
      })
    end, { range = true })

    -- Toggle format on save
    --   vim.api.nvim_create_user_command("FormatDisable", function(args)
    --     if args.bang then
    --       -- FormatDisable! will disable formatting just for this buffer
    --       vim.b.disable_autoformat = true
    --     else
    --       vim.g.disable_autoformat = true
    --     end
    --   end, {
    --     desc = "Disable autoformat-on-save",
    --     bang = true,
    --   })
    --   vim.api.nvim_create_user_command("FormatEnable", function()
    --     vim.b.disable_autoformat = false
    --     vim.g.disable_autoformat = false
    --   end, {
    --     desc = "Re-enable autoformat-on-save",
    --   })
  end,
}

local M = {}
local configs = require("configs")

function M.confirm(opts)
  local cmp = require("cmp")
  opts = vim.tbl_extend("force", {
    select = true,
    behavior = cmp.ConfirmBehavior.Insert,
  }, opts or {})
  return function(fallback)
    if cmp.core.view:visible() or vim.fn.pumvisible() == 1 then
      if cmp.confirm(opts) then
        return
      end
    end
    return fallback()
  end
end

function M.has_word_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

function M.opts()
  vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
  local cmp = require("cmp")
  local defaults = require("cmp.config.default")()
  local auto_select = true
  return {
    auto_brackets = {},
    completion = {
      completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
    },
    preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
    mapping = cmp.mapping.preset.insert({
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif require("copilot.suggestion").is_visible() then
          require("copilot.suggestion").accept()
        elseif M.has_word_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<CR>"] = M.confirm({ select = auto_select }),
      ["<C-y>"] = M.confirm({ select = true }),
      ["<S-CR>"] = M.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
      ["<C-CR>"] = function(fallback)
        cmp.abort()
        fallback()
      end,
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "path" },
    }, {
      -- { name = "buffer" },
    }),
    formatting = {
      format = function(entry, item)
        local icons = configs.icons.kinds
        if icons[item.kind] then
          item.kind = icons[item.kind] .. item.kind
        end

        local widths = {
          abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
          menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
        }

        for key, width in pairs(widths) do
          if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
            item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
          end
        end

        return item
      end,
    },
    -- experimental = {
    --   ghost_text = {
    --     hl_group = "CmpGhostText",
    --   },
    -- },
    sorting = defaults.sorting,
  }
end

return M

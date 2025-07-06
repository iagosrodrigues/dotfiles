local function git_branch()
  local ok, handle = pcall(io.popen, "git branch --show-current 2>/dev/null")
  if not ok or not handle then
    return ""
  end
  local branch = handle:read "*a"
  handle:close()
  if branch and branch ~= "" then
    branch = branch:gsub("\n", "")
    return "󰊢 " .. branch
  end
  return ""
end

local function safe_git_branch()
  local ok, result = pcall(git_branch)
  return ok and result or ""
end

local function linter_status()
  local ok, lint = pcall(require, "lint")
  if not ok then
    return ""
  end

  local linters = lint.linters_by_ft[vim.bo.filetype] or {}
  if #linters == 0 then
    return ""
  end

  return "󰁨 " .. table.concat(linters, ",")
end

local function safe_linter_status()
  local ok, result = pcall(linter_status)
  return ok and result or ""
end

local function formatter_status()
  local ok, conform = pcall(require, "conform")
  if not ok then
    return ""
  end

  local formatters = conform.list_formatters_to_run(0)
  if #formatters == 0 then
    return ""
  end

  local formatter_names = {}
  for _, formatter in ipairs(formatters) do
    table.insert(formatter_names, formatter.name)
  end

  return "󰉿 " .. table.concat(formatter_names, ",")
end

local function safe_formatter_status()
  local ok, result = pcall(formatter_status)
  return ok and result or ""
end

local function lsp_status_short()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients { bufnr = bufnr }

  if #clients == 0 then
    return "" -- Return empty string when no LSP
  end

  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end

  return "󰒋 " .. table.concat(names, ",")
end

local function safe_lsp_status()
  local ok, result = pcall(lsp_status_short)
  return ok and result or ""
end

_G.git_branch = safe_git_branch
_G.formatter_status = safe_formatter_status
_G.linter_status = safe_linter_status
_G.lsp_status = safe_lsp_status

vim.opt.statusline = table.concat({
  "%{v:lua.git_branch()}", -- Git branch
  "%f", -- File name
  "%m", -- Modified flag
  "%r", -- Readonly flag
  "%=", -- Right align
  "%{v:lua.linter_status()}", -- Linter status
  "%{v:lua.formatter_status()}", -- Formatter status
  "%{v:lua.lsp_status()}", -- LSP status
  " %l:%c", -- Line:Column
  " %p%%", -- Percentage through file
}, " ")

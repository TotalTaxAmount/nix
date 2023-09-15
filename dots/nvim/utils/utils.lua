local M = {}

local vim_opt = vim.opt
local vim_g = vim.g
local vim_fn = vim.fn

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}

  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function imap(lhs, rhs, opts)
    map("i", lhs, rhs, opts)
end

local function nmap(lhs, rhs, opts)
    map("n", lhs, rhs, opts)
end

local function get_g()
    return vim_g
end

local function get_opt()
    return vim_opt
end

local function get_fn()
    return vim_fn
end

M.map = map
M.imap = imap
M.nmap = nmap
M.get_g = get_g
M.get_opt = get_opt
M.get_fn = get_fn

return M


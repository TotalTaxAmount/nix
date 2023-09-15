-- Add modules to package cause nixos
local config_dir = os.getenv("CONFIG_DIRECTORY") .. "/nix/dots/nvim"
package.path = package.path .. ";" .. config_dir .."/?.lua"

local utils = require("utils.utils");
local opt = utils.get_opt()
local fn = utils.get_fn()

local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}


-- Undo
opt.undofile = true
opt.undodir = "/home/totaltaxamount/.cache/"

-- Indents
opt.smartindent = true
opt.autoindent = true
opt.shiftwidth = 4
opt.expandtab = true
 
-- Mouse
opt.mouse = "a"

-- UI
opt.number = true
vim.cmd "colorscheme onedark"

-- QOL
opt.smartcase = true

-- Treesitter
require'nvim-treesitter.configs'.setup {
    ensure_installed = "",

    sync_install = true,

    auto_install = true,

    parser_install_dir = config_dir + "/parsers",

    highlight = {
        enable = true,
    }
}

-- Configs
require('configs.vim-airline')
require('configs.vim-buffet')
require('configs.nvim-tree')

-- binds

-- COC
opt.backup = false
opt.writebackup = false

opt.updatetime = 300
opt.signcolumn = 'yes'

local keyset = vim.keymap.set

-- Autocompleate
function _G.check_back_space()
    local col = fn.col('.') - 1
    return col == 0 or fn.getline('.'):sub(col, col):match('%s') ~= nil
end

utils.imap("<TAB>", 'pumvisible() ? coc#_select_confirm() : v:lua.check_back_space() ? "\\<TAB>" : coc#refresh()', opts)

-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice
utils.imap("<CR>", 'pumvisible() ? coc#_select_confirm() : "\\<C-g>u\\<CR>\\<C-r>=coc#on_enter()\\<CR>"', opts)

-- Use <C-j> to trigger snippets
utils.imap("<C-j>", "<Plug>(coc-snippets-expand-jump)")
-- Use <C-space> to trigger completion
utils.imap("<C-space>", "coc#refresh()", {silent = true, expr = true})

-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
utils.nmap("[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
utils.nmap("]g", "<Plug>(coc-diagnostic-next)", {silent = true})

-- GoTo code navigation
utils.nmap("gd", "<Plug>(coc-definition)", {silent = true})
utils.nmap("gy", "<Plug>(coc-type-definition)", {silent = true})
utils.nmap("gi", "<Plug>(coc-implementation)", {silent = true})
utils.nmap("gr", "<Plug>(coc-references)", {silent = true})


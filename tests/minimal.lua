--[[

  PRECONFIGURATION

 ]]
vim.api.nvim_command('set rtp+=.')
vim.api.nvim_command('set rtp+=../which-key.nvim')
vim.api.nvim_command('set rtp+=../nvim-mapper')
vim.api.nvim_command('set rtp+=../telescope.nvim')
vim.api.nvim_command('set rtp+=../plenary.nvim')

vim.api.nvim_command('runtime! plugin/plenary.vim')
vim.api.nvim_command('runtime! plugin/telescope.vim')

local telescope = require("telescope")
-- Required to close with ESC in insert mode
local actions = require("telescope.actions")

telescope.setup({
})

-- Load mapper extension
telescope.load_extension("mapper")

require("nvim-mapper").setup({
    -- do not assign the default keymap (<leader>MM)
    no_map = false,
    -- where should ripgrep look for your keybinds definitions.
    -- Default config search path is ~/.config/nvim/lua
    search_path = os.getenv("HOME") .. "/.config/nvim/lua",
    -- what should be done with the selected keybind when pressing enter.
    -- Available actions:
    --   * "definition" - Go to keybind definition (default)
    --   * "execute" - Execute the keybind command
    action_on_enter = "definition",
})


--[[

  EXAMPLE NEST CONFIGURATION

 ]]
local nest = require('nest')
nest.enable(require('nest.integrations.whichkey'));
nest.enable(require('nest.integrations.mapper'))
nest.applyKeymaps {
    -- Remove silent from ; : mapping, so that : shows up in command mode
    { ';', ':' , options = { silent = false } },
    { ':', ';' },


    -- Prefix  every nested keymap with <leader>
    { '<leader>', {
        { 'm', '<cmd>Telescope mapper<cr>', 'Mapper'},
        { 'p', require'telescope.builtin'.planets, 'Planets' },
        -- Prefix every nested keymap with f (meaning actually <leader>f here)
        { 'f', name = '+File', {
            { 'f', '<cmd>Telescope find_files<cr>', 'Find Files' },
            -- This will actually map <leader>fl
            { 'l', '<cmd>Telescope live_grep<cr>', 'Search Files', },
            -- Prefix every nested keymap with g (meaning actually <leader>fg here)
            { 'g', name = '+Git', {
                { 'b', '<cmd>Telescope git_branches<cr>', 'Branches' },
                -- This will actually map <leader>fgc
                { 'c', '<cmd>Telescope git_commits<cr>', 'Commits' },
                { 's', '<cmd>Telescope git_status<cr>', 'Status' },
            }},
        }},

        -- Lua functions can be right side values instead of key sequences
        { 'l', name = '+Lsp', {
            { 'r', vim.lsp.buf.rename, 'Rename' },
            { 's', vim.lsp.buf.signature_help, 'Signature' },
            { 'h', vim.lsp.buf.hover, 'Hover' },
        }},
    }},

    -- Use insert mode for all nested keymaps
    { mode = 'i', {
        { 'jk', '<Esc>' },

        -- Set <expr> option for all nested keymaps
        { options = { expr = true }, {
            { '<cr>',       'compe#confirm("<CR>")' },
            -- This is equivalent to viml `:inoremap <C-Space> <expr>compe#complete()`
            { '<C-Space>',  'compe#complete()' },
        }},

        -- Buffer `true` sets keymaps only for the current buffer
        { '<C-', buffer = true, {
            { 'h>', '<left>' },
            { 'l>', '<right>' },
            -- You can also set bindings for a specific buffer
            { 'o>', '<Esc>o', buffer = 1 },
        }},
    }},

    -- Keymaps can be defined for multiple modes at once
    { 'H', '^', mode = 'nv' },
}
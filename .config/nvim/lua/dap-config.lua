local dap = require('dap')
local dapui = require('dapui')

vim.fn.sign_define('DapBreakpoint', {text=' ', texthl='debugBreakpoint', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointCondition', {text=' ', texthl='DiagnosticWarn', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text=' ', texthl='DiagnosticError', linehl='', numhl=''})
vim.fn.sign_define('DapLogPoint', {text=' ', texthl='debugBreakpoint', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='', texthl='debugBreakpoint', linehl='debugPC', numhl=''})
dapui.setup()

dap.adapters.chrome = {
    type = "executable",
    command = "node",
    args = {"c:\\src\\prj\\vscode-chrome-debug\\out\\src\\chromeDebug.js"}
}

--dap.configurations.typescript = {
--    {
--        type = "chrome",
--        request = "attach",
--        --program = "${file}",
--        cwd = vim.fn.getcwd(),
--        sourceMaps = true,
--        protocol = "inspector",
--        port = 9229,
--        url = function()
--            return "file:///" .. vim.fn.expand("%:p"):gsub("\\", "/")
--        end
--    }
--}

dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = {'c:\\src\\prj\\vscode-node-debug2\\out\\src\\nodeDebug.js'},
}
dap.configurations.typescript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = 'Attach to process',
    type = 'node2',
    request = 'attach',
    sourceMaps = true,
    --processId = require'dap.utils'.pick_process,
    port = 9229,
  },
}

-- dap.adapters.netcoredbg = {
--   type = 'executable',
--   command = '/home/fen/.local/bin/netcoredbg/netcoredbg',
--   args = {'--interpreter=vscode'},
-- }
-- dap.configurations.cs = {
--   {
--     type = "netcoredbg",
--     name = "launch - netcoredbg",
--     request = "launch",
--     program = function()
--         return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
--     end,
--   },
--   {
--     type = "netcoredbg",
--     name = "attach - netcoredbg",
--     request = "attach",
--     processId = require'dap.utils'.pick_process,
--   },
-- }

--dap.adapters.netcoredbg = {
--  type = 'executable',
--  command = '/home/fen/Downloads/ms-dotnettools.csharp-1.24.0@linux-x64/extension/.debugger/vsdbg-ui',
--}
--dap.configurations.cs = {
--  {
--    type = "netcoredbg",
--    name = "launch - netcoredbg",
--    request = "launch",
--    program = function()
--        return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
--    end,
--  },
--  {
--    type = "netcoredbg",
--    name = "attach - netcoredbg",
--    request = "attach",
--    processId = require'dap.utils'.pick_process,
--  },
--}

vim.cmd [[au FileType dap-repl lua require('dap.ext.autocompl').attach()]]

local M = {}
function M.DapEditConfig()
    if vim.fn.filereadable('nvim-dap_launch.json') == 1 then
        vim.cmd('vsplit nvim-dap_launch.json')
        return
    end
    local buf = vim.api.nvim_create_buf(true, false)
    vim.bo[buf].filetype = 'json'
    vim.api.nvim_buf_set_name(buf, 'nvim-dap_launch.json')
    local lines = {
        '{',
        '   "version": "0.2.0",',
        '   "configurations": [',
        '       {',
        '           "type": "type",',
        '           "request": "launch",',
        '           "name": "Debug",',
        '           "program": "executable name"',
        '       }',
        '   ]',
        '}'
    }
    vim.api.nvim_buf_set_lines(buf, 0, 0, false, lines)

    vim.cmd('vsplit')
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
    vim.cmd [[au BufWritePost <buffer> lua require'dap.ext.vscode'.load_launchjs('nvim-dap_launch.json')]]
end

vim.cmd [[command! DapEditConfig lua require'dap-config'.DapEditConfig()]]
vim.cmd [[command! DapReloadConfig lua require'dap'.configurations = {}; vim.cmd("luafile ~/.config/nvim/lua/dap-config.lua"); require'dap.ext.vscode'.load_launchjs('nvim-dap_launch.json')]]
vim.cmd [[command! DapClose lua require'dap'.terminate(); require'dapui'.close(); vim.cmd("bd! \\[dap-repl]") ]]
vim.cmd [[command! DapStart lua require'dap'.continue()]]

-- mappings
local map_opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<leader>dC', '<cmd>lua require"dap".continue()<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>db', '<cmd>lua require"dap".toggle_breakpoint()<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>dB', ':lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<cr>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>do', '<cmd>lua require"dap".step_over()<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>dO', '<cmd>lua require"dap".step_out()<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>dn', '<cmd>lua require"dap".step_into()<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>dN', '<cmd>lua require"dap".step_back()<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>dr', '<cmd>lua require"dap".repl.toggle()<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>d.', '<cmd>lua require"dap".goto_()<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>dh', '<cmd>lua require"dap".run_to_cursor()<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>de', '<cmd>lua require"dap".set_exception_breakpoints()<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>dv', '<cmd>Telescope dap variables<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>dc', '<cmd>Telescope dap commands<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>dx', '<cmd>lua require"dapui".eval()<CR>', map_opts)
vim.api.nvim_set_keymap('n', '<leader>dX', '<cmd>lua require"dapui".eval(vim.fn.input("expression: "))<CR>', map_opts)
vim.api.nvim_set_keymap('x', '<leader>dx', '<cmd>lua require"dapui".eval()<CR>', map_opts)

dap.listeners.after['event_initialized']['dapui'] = function()
    require'dapui'.open()
end
dap.listeners.after['event_terminated']['dapui'] = function()
    require'dapui'.close()
    vim.cmd("bd! \\[dap-repl]")
end

return M

local M = {}

function M.setup()
    -- Keep Neovim's native statusline, with a coloured mode label.
    local default_statusline = vim.api.nvim_get_option_info2("statusline", {}).default
    local modes = {
        n = { "NORMAL", "Title" },
        i = { "INSERT", "String" },
        v = { "VISUAL", "StatusModeVisual" },
        V = { "V-LINE", "StatusModeVisual" },
        ["\22"] = { "V-BLOCK", "StatusModeVisual" },
        s = { "SELECT", "StatusModeVisual" },
        S = { "S-LINE", "StatusModeVisual" },
        ["\19"] = { "S-BLOCK", "StatusModeVisual" },
        c = { "COMMAND", "Function" },
        R = { "REPLACE", "DiagnosticWarn" },
        t = { "TERMINAL", "DiagnosticError" },
    }
    _G.vavro_statusline_mode_marker = function()
        local mode = vim.api.nvim_get_mode().mode
        local info = modes[mode:sub(1, 1)] or { mode:upper(), "StatusLine" }
        return ("%%#%s#▎ %-8s%%*"):format(info[2], info[1])
    end
    vim.o.rulerformat = vim.api.nvim_get_option_info2("rulerformat", {}).default
    vim.o.statusline = "%{%v:lua.vavro_statusline_mode_marker()%}  " .. default_statusline

    vim.api.nvim_create_autocmd("ModeChanged", {
        group = vim.api.nvim_create_augroup("vavro-statusline", { clear = true }),
        callback = function()
            vim.cmd.redrawstatus()
        end,
    })
end

return M

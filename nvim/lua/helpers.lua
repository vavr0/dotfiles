local M = {}

function M.markdown_foldexpr()
    local lnum = vim.v.lnum
    local line = vim.fn.getline(lnum)
    local frontmatter_end = vim.b.frontmatter_end

    if line == "---" and lnum == 1 and frontmatter_end then
        return "1"
    end

    if frontmatter_end and lnum > 1 and lnum <= frontmatter_end then
        return "1"
    end

    local heading = line:match("^(#+)%s")
    if heading then
        local level = #heading
        if level == 1 then
            if lnum == 1 then
                return ">1"
            end
            if frontmatter_end and lnum == frontmatter_end + 1 then
                return ">1"
            end
        elseif level >= 2 and level <= 6 then
            return ">" .. level
        end
    end

    return "="
end

local function detect_frontmatter_end(bufnr)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local found_first = false
    local frontmatter_end = nil

    for i, line in ipairs(lines) do
        if line == "---" then
            if not found_first then
                found_first = true
            else
                frontmatter_end = i
                break
            end
        end
    end

    vim.b[bufnr].frontmatter_end = frontmatter_end
end

local function fold_headings_of_level(bufnr, level)
    vim.api.nvim_buf_call(bufnr, function()
        vim.cmd("keepjumps normal! gg")
        local total_lines = vim.fn.line("$")

        for line = 1, total_lines do
            local line_content = vim.fn.getline(line)
            if line_content:match("^" .. string.rep("#", level) .. "%s") then
                vim.cmd(string.format("keepjumps call cursor(%d, 1)", line))
                if vim.fn.foldlevel(line) > 0 and vim.fn.foldclosed(line) == -1 then
                    vim.cmd("normal! za")
                end
            end
        end
    end)
end

local function fold_markdown_headings(bufnr, levels)
    vim.api.nvim_buf_call(bufnr, function()
        local saved_view = vim.fn.winsaveview()
        for _, level in ipairs(levels) do
            fold_headings_of_level(bufnr, level)
        end
        vim.cmd("nohlsearch")
        vim.fn.winrestview(saved_view)
    end)
end

local function set_markdown_keymaps(bufnr)
    local function map(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map("zj", function()
        vim.api.nvim_buf_call(bufnr, function()
            vim.cmd("silent update")
            vim.cmd("edit!")
            vim.cmd("normal! zR")
            fold_markdown_headings(bufnr, { 6, 5, 4, 3, 2, 1 })
            vim.cmd("normal! zz")
        end)
    end, "[P]Fold all headings level 1 or above")

    map("zk", function()
        vim.api.nvim_buf_call(bufnr, function()
            vim.cmd("silent update")
            vim.cmd("edit!")
            vim.cmd("normal! zR")
            fold_markdown_headings(bufnr, { 6, 5, 4, 3, 2 })
            vim.cmd("normal! zz")
        end)
    end, "[P]Fold all headings level 2 or above")

    map("zl", function()
        vim.api.nvim_buf_call(bufnr, function()
            vim.cmd("silent update")
            vim.cmd("edit!")
            vim.cmd("normal! zR")
            fold_markdown_headings(bufnr, { 6, 5, 4, 3 })
            vim.cmd("normal! zz")
        end)
    end, "[P]Fold all headings level 3 or above")

    map("z;", function()
        vim.api.nvim_buf_call(bufnr, function()
            vim.cmd("silent update")
            vim.cmd("edit!")
            vim.cmd("normal! zR")
            fold_markdown_headings(bufnr, { 6, 5, 4 })
            vim.cmd("normal! zz")
        end)
    end, "[P]Fold all headings level 4 or above")

    map("<Tab>", function()
        vim.api.nvim_buf_call(bufnr, function()
            local line = vim.fn.line(".")
            if vim.fn.foldlevel(line) == 0 then
                vim.notify("No fold found", vim.log.levels.INFO)
            else
                vim.cmd("normal! za")
                vim.cmd("normal! zz")
            end
        end)
    end, "[P]Toggle fold")

    map("zu", function()
        vim.api.nvim_buf_call(bufnr, function()
            vim.cmd("silent update")
            vim.cmd("edit!")
            vim.cmd("normal! zR")
            vim.cmd("normal! zz")
        end)
    end, "[P]Unfold all headings level 2 or above")
end

function M.setup_markdown(bufnr)
    detect_frontmatter_end(bufnr)

    vim.api.nvim_buf_call(bufnr, function()
        vim.opt_local.foldmethod = "expr"
        vim.opt_local.foldexpr = "v:lua.require'helpers'.markdown_foldexpr()"
        vim.opt_local.foldlevel = 99
        vim.opt_local.foldcolumn = "0"
    end)

    if not vim.b[bufnr].markdown_folding_keymaps_set then
        set_markdown_keymaps(bufnr)
        vim.b[bufnr].markdown_folding_keymaps_set = true
    end
end

function M.toggle_quickfix()
    local qf_exists = false

    for _, win in ipairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            qf_exists = true
            break
        end
    end

    if qf_exists then
        vim.cmd("cclose")
    else
        if vim.tbl_isempty(vim.fn.getqflist()) then
            vim.notify("Quickfix list is empty", vim.log.levels.INFO)
        else
            vim.cmd("copen")
        end
    end
end

local function open_diagnostics(opts)
    local diagnostics = vim.diagnostic.get(opts.bufnr)

    if vim.tbl_isempty(diagnostics) then
        vim.notify(opts.empty_message, vim.log.levels.INFO)
        return
    end

    vim.fn.setqflist({}, " ", {
        title = opts.title,
        items = vim.diagnostic.toqflist(diagnostics),
    })
    vim.cmd("copen")
end

function M.open_buffer_diagnostics()
    open_diagnostics({
        bufnr = 0,
        title = "Buffer Diagnostics",
        empty_message = "No diagnostics in current buffer",
    })
end

function M.open_workspace_diagnostics()
    open_diagnostics({
        bufnr = nil,
        title = "Workspace Diagnostics",
        empty_message = "No diagnostics in workspace",
    })
end

function M.pack_clean()
    local active_plugins = {}
    local unused_plugins = {}

    for _, plugin in ipairs(vim.pack.get()) do
        active_plugins[plugin.spec.name] = plugin.active
    end

    for _, plugin in ipairs(vim.pack.get()) do
        if not active_plugins[plugin.spec.name] then
            table.insert(unused_plugins, plugin.spec.name)
        end
    end

    if #unused_plugins == 0 then
        print("No unused plugins.")
        return
    end

    local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
    if choice == 1 then
        vim.pack.del(unused_plugins)
    end
end

function M.pack_update()
    vim.pack.update()
end

return M

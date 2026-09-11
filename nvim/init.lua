local helpers = require("helpers")
local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.cmd("packadd nvim.undotree")
vim.cmd("packadd nvim.difftool")
vim.cmd("packadd nvim.tohtml")
vim.cmd("packadd! termdebug")
vim.cmd("packadd cfilter")

require('vim._core.ui2').enable({})

---------------------------------
---         options           ---
---------------------------------

vim.opt.guicursor = ""

vim.o.winborder = "rounded"

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.background = "dark"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.hlsearch = true
vim.opt.incsearch = true

-- vim.o.inccommand = "split"

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.colorcolumn = "100"
vim.opt.confirm = true

vim.o.cmdheight = 0

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 1
vim.g.netrw_preview = 1

vim.opt.mouse = "a"

vim.o.swapfile = false
vim.o.backup = false
vim.opt.undofile = true

vim.opt.conceallevel = 0

vim.o.pumblend = 2
vim.o.pumheight = 10

vim.o.grepprg = "rg --vimgrep --smart-case --hidden"

vim.o.foldtext = ""
vim.opt.foldlevel = 99
vim.o.foldcolumn = "0"
vim.opt.fillchars:append({ fold = " " })

---------------------------------
---         plugins           ---
---------------------------------

vim.pack.add({
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    { src = "https://github.com/mfussenegger/nvim-jdtls" },

    { src = "https://github.com/nvim-treesitter/nvim-treesitter",          version = 'main' },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },

    { src = "https://github.com/L3MON4D3/LuaSnip" },
    { src = "https://github.com/saghen/blink.cmp",                         version = vim.version.range("^1") },
    { src = "https://github.com/rafamadriz/friendly-snippets" },

    { src = "https://github.com/rose-pine/neovim" },

    { src = "https://github.com/ibhagwan/fzf-lua" },
    { src = "https://github.com/mfussenegger/nvim-dap" },
    { src = "https://github.com/igorlfs/nvim-dap-view" },
    { src = "https://github.com/theHamsta/nvim-dap-virtual-text" },

    { src = "https://github.com/nvim-mini/mini.icons" },
    { src = "https://github.com/nvim-mini/mini.bufremove" },
    { src = "https://github.com/nvim-mini/mini.pairs" },
    { src = "https://github.com/nvim-mini/mini.surround" },
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/chomosuke/typst-preview.nvim" },
    { src = "https://github.com/lervag/vimtex" },
    { src = "https://github.com/opdavies/toggle-checkbox.nvim" },
    { src = "https://github.com/chentoast/marks.nvim" },
    { src = "https://github.com/tpope/vim-fugitive" },
    { src = "https://github.com/windwp/nvim-ts-autotag" },
    { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
    { src = "https://github.com/j-hui/fidget.nvim" },
    { src = 'https://github.com/nvim-orgmode/orgmode' },
    { src = 'https://github.com/jceb/jiejie.nvim' },
})

local servers = {
    "lua_ls",
    "rust_analyzer",
    "ts_ls",
    "gopls",
    "basedpyright",
    "zls",
    "clangd",
    "bashls",
    "texlab",
    "tinymist",
    "html",
    "cssls",
    "markdown_oxide",
}

--|-----|
--| LSP |
--|-----|

local capabilities = require("blink.cmp").get_lsp_capabilities()

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = servers,
})

for _, s in ipairs(servers) do
    vim.lsp.config(s, { capabilities = capabilities })
end

vim.lsp.enable('org')

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
        },
    },
})

vim.lsp.config("texlab", {
    capabilities = capabilities,
    root_markers = {
        "main-en.tex",
        ".latexmkrc",
        "latexmkrc",
        ".texlabroot",
        "texlabroot",
        "Tectonic.toml",
    },
    settings = {
        texlab = {
            build = {
                auxDirectory = "build",
                logDirectory = "build",
                pdfDirectory = "build",
                useFileList = true,
            },
        },
    },
})

--|-----|
--| FZF |
--|-----|

local fzf = require("fzf-lua")
fzf.setup({
    hls = {
        border = "FloatBorder",
        preview_border = "FloatBorder",
    },
    winopts = {
        title_flags = false,
        fullscreen = true,
        height = 0.85,
        width = 0.85,
        border = "rounded",
        preview = {
            border = "rounded",
            layout = "horizontal",
            horizontal = "right:60%",
        },
    },
    keymap = {
        fzf = {
            true,
            ["ctrl-j"] = "down",
            ["ctrl-k"] = "up",
            ["ctrl-q"] = "select-all+accept",
        },
    }
})

-- org
require('orgmode').setup({
    org_agenda_files = '~/personal/notes/org/**/*.org',
    org_default_notes_file = '~/personal/notes/org/inbox.org',
    org_archive_location = '~/personal/notes/org/archive.org::',
})

vim.g.jiejie_config = {
      -- Excluded revset expression, see https://docs.jj-vcs.dev/latest/revsets/ for the full language
    excluded_revset = 'bookmarks(glob:"renovate/*") | tracked_remote_bookmarks(glob:"renovate/*") | untracked_remote_bookmarks(glob:"renovate/*")',
    default_view = 1,
    dynamic_views = {
      -- Dynamic view that dispalys all merges, see https://docs.jj-vcs.dev/latest/revsets/ for the full language
      { revset = "merges()" }
    },
    log_revisions = 10,
}

-- VimTeX
vim.g.vimtex_view_method = "sioyek"
vim.g.vimtex_view_automatic = 1
vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_compiler_latexmk = {
    options = {
        "-pdfxe",
        "-interaction=nonstopmode",
        "-synctex=1",
        "-outdir=build",
    },
}

--|-----|
--| DAP |
--|-----|

local dap = require("dap")
local dapview = require("dap-view")

require("nvim-dap-virtual-text").setup({
    commented = true,
    clear_on_continue = true,
    show_stop_reason = true,
})

dapview.setup({})

dap.listeners.after.event_initialized["dapview_autoopen"] = function()
    dapview.open()
end
dap.listeners.before.event_terminated["dapview_autoclose"] = function()
    dapview.close()
end
dap.listeners.before.event_exited["dapview_autoclose"] = function()
    dapview.close()
end

local codelldb = vim.fn.exepath("codelldb")
if codelldb == "" then
    codelldb = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"
end

dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = codelldb,
        args = { "--port", "${port}" },
    },
}

local function pick_file_with(suffix)
    return function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. suffix, "file")
    end
end

local common = {
    type = "codelldb",
    request = "launch",
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
}

dap.configurations.c = {
    vim.tbl_extend("force", common, {
        name = "Launch C binary",
        program = pick_file_with("/build/"),
    }),
}

dap.configurations.cpp = {
    vim.tbl_extend("force", common, {
        name = "Launch C++ binary",
        program = pick_file_with("/build/"),
    }),
}

dap.configurations.rust = {
    vim.tbl_extend("force", common, {
        name = "Launch Rust binary",
        program = pick_file_with("/target/debug/"),
        env = { RUST_BACKTRACE = "1" },
    }),
}

dap.configurations.zig = {
    vim.tbl_extend("force", common, {
        name = "Launch Zig binary",
        program = pick_file_with("/zig-out/bin/"),
    }),
}


require("rose-pine").setup({
    disable_background = true,
    disable_float_background = true,
})
vim.cmd.colorscheme("rose-pine")
require("colors").setup()

require("statusline").setup()

require("mini.icons").setup()
require("mini.pairs").setup()
require("mini.surround").setup()
require("typst-preview").setup()
require("mini.bufremove").setup()
require("which-key").setup({
    preset = "helix",
})

require("oil").setup({
    keymaps = {
        ["q"] = { "actions.close", mode = "n" },
        ["<leader>k"] = { "actions.parent", mode = "n" },
    },
    float = {
        padding = 2,
        max_width = 0,
        max_height = 0,
        border = nil,
        preview_split = "right",
    }
})

require("marks").setup()

require("nvim-ts-autotag").setup({
    opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
    },
})

local treesitter = require("nvim-treesitter")
treesitter.install({
    "javascript",
    "typescript",
    "java",
    "html",
    "c",
    "cpp",
    "glsl",
    "lua",
    "python",
    "typst",
    "vim",
    "vimdoc",
    "query",
    "rust",
    "zsh",
    "zig"
})

require("treesitter-context").setup({
    enable = true,
    max_lines = 3,
    trim_scope = "outer",
    auto_install = true,
})


require("render-markdown").setup({
    pipe_table = { preset = "round" },
    render_modes = { "n", "v", "i", "c" },
    heading = {
        icons = { " 󰎤 ", "  󰎧 ", " 󰎪 ", " 󰎭 ", " 󰎱 ", " 󰇏 " },
        backgrounds = {
            "Headline1Bg",
            "Headline2Bg",
            "Headline3Bg",
            "Headline4Bg",
            "Headline5Bg",
            "Headline6Bg",
        },
    },
    indent = {
        enabled = true,
        render_modes = false,
        per_level = 2,
        skip_level = 1,
        skip_heading = true,
        icon = " ",
        priority = 0,
        highlight = "RenderMarkdownIndent",
    },
})


require("blink.cmp").setup({
    keymap = {
        preset = "none",
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-y>"] = { "accept", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
    },
    snippets = { preset = "luasnip" },
    appearance = {
        nerd_font_variant = "mono",
    },
    completion = {
        documentation = { auto_show = false },
        menu = {
            border = "rounded",
        },
        ghost_text = { enabled = false },
    },
    sources = {
        default = { "lsp", "snippets", "buffer", "path" },
    },
    cmdline = {
        enabled = true,
        completion = {
            menu = { auto_show = true },
        },
    },
    fuzzy = {
        implementation = "prefer_rust_with_warning",
    },
})

require("luasnip.loaders.from_lua").lazy_load({
    paths = { vim.fn.stdpath("config") .. "/snippets" },
})
require("luasnip.loaders.from_vscode").lazy_load()

require("fidget").setup({})



---------------------------------
---         autocmds          ---
---------------------------------

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("vavro-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ higroup = "YankHighlight", timeout = 150 })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.breakindent = true
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("vavro-lsp-keys", { clear = true }),
    callback = function(args)
        local opts = { buffer = args.buf, silent = true }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "H", vim.lsp.buf.hover, opts)
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("vavro-markdown-folding", { clear = true }),
    pattern = "markdown",
    callback = function(args)
        require("helpers").setup_markdown(args.buf)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "*" },
    callback = function()
        local filetype = vim.bo.filetype
        if filetype and filetype ~= "" and filetype ~= "latex" then
            local success = pcall(function()
                vim.treesitter.start()
            end)
            if not success then
                return
            end
        end
    end,
})

vim.api.nvim_create_autocmd("PackChanged", {
    desc = "Handle nvim-treesitter updates",
    group = vim.api.nvim_create_augroup("nvim-treesitter-pack-changed-update-handler", { clear = true }),
    callback = function(event)
        if event.data.kind == "update" then
            local ok = pcall(vim.cmd, "TSUpdate")
            if ok then
                vim.notify("TSUpdate completed successfully!", vim.log.levels.INFO)
            else
                vim.notify("TSUpdate command not available yet, skipping", vim.log.levels.WARN)
            end
        end
    end,
})
---------------------------------
---         remaps            ---
---------------------------------


map("n", "<leader>a", function()
    vim.cmd('$argadd %')
    vim.cmd('argdedupe')
end, { desc = "Add current file to arglist" })

map("n", "<leader>w", "<cmd>update<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit file" })
map("n", "<leader>Q", "<cmd>:wqa<CR>", { desc = "Quit and savefile" })
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute word" })
map("n", "<leader>k", "<cmd>Oil --preview --float<CR>", { desc = "Open parent directory" })

-- map({ 'n', 'v' }, '<leader>n', ':norm ')

map("n", "<C-j>", "<cmd>cnext<CR>zz", { desc = "Next quickfix" })
map("n", "<C-k>", "<cmd>cprev<CR>zz", { desc = "Prev quickfix" })
map("n", "<C-q>", helpers.toggle_quickfix, { desc = "Toggle quickfix" })
map("n", "<C-h>", "<cmd>1argument<CR>", { desc = "arg 1" })
map("n", "<C-l>", "<cmd>2argument<CR>", { desc = "arg 2" })
map("n", "<C-n>", "<cmd>3argument<CR>", { desc = "arg 3" })
map("n", "<C-m>", "<cmd>4argument<CR>", { desc = "arg 4" })
map("n", "<C-g>", "<cmd>5argument<CR>", { desc = "arg 5" })
map("n", "<C-b>", "<cmd>6argument<CR>", { desc = "arg 6" })
map("n", "<C-t>", "<cmd>7argument<CR>", { desc = "arg 7" })


map("n", "<C-s>", "<cmd>e #<CR>", { desc = "Alternate file" }) -- b#
map("n", "<C-y>", "<C-i>", { desc = "Redo jump" })
map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "Open sessionizer" })

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Exit terminal mode" })


map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprev<CR>", { desc = "Previous buffer" })
map("n", "<leader>cd", "<cmd>cd %:p:h<CR>", { noremap = true, silent = true, desc = "Cwd to file dir" })
map("n", "<leader>xx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })
map("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "Open new tab" })

map("n", "<leader>pc", helpers.pack_clean, { desc = "Clean packages" })
map("n", "<leader>pu", helpers.pack_update, { desc = "Update packages" })


map({ "n", "v", "x" }, ';', ':', { desc = "Enter command-line" })
map({ "n", "v", "x" }, ':', ';', { desc = "Repeat f/t" })
-- map("n", "q;", "q:", { noremap = true, desc = "Open command-line window" })

map("v", "<", "<gv", { desc = "Indent and reselect" })
map("v", ">", ">gv", { desc = "Indent and reselect" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move block down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move block up" })
map("n", "J", "mzJ`z", { desc = "Join lines keep cursor" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up centered" })
map("n", "n", "nzzzv", { desc = "Center search next" })
map("n", "N", "Nzzzv", { desc = "Center search prev" })

map("x", "<leader>p", [["_dP]], { desc = "Paste without yank" })
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to clipboard" })
map({ "n", "v" }, "<leader>dd", [["_d]], { desc = "Delete without yank" })
map({ "n", "v" }, "<leader>D", [["_d]], { desc = "Delete without yank" })

map("n", "<down>", ":resize +2<cr>", { desc = "Increase height" })
map("n", "<up>", ":resize -2<cr>", { desc = "Decrease height" })
map("n", "<right>", ":vertical resize +2<cr>", { desc = "Increase width" })
map("n", "<left>", ":vertical resize -2<cr>", { desc = "Decrease width" })


map("n", "<leader>lf", function()
    vim.lsp.buf.format { async = true }
end, { desc = "Format buffer with LSP" })

map("n", "<leader>re", "<cmd>restart<CR>")

map("n", "<leader>rr", function()
        vim.cmd("source")
    end,
    { desc = "source lua file" }
)

for i = 1, 8 do
    map({ "n", "t" }, "<Leader>" .. i, "<Cmd>tabnext " .. i .. "<CR>", { desc = "Go to tab " .. i })
end

map("n", "<leader>bd", function()
    require("mini.bufremove").delete(0, false)
end, { desc = "Delete buffer" })

map("n", "<leader>u", vim.cmd.Undotree, { desc = "Toggle Undotree" })
map("n", "<leader>to", ":lua require('toggle-checkbox').toggle()<CR>", { desc = "Toggle checkbox" })

-- FZF-LUA

map("n", "<leader>f", fzf.files, { desc = "Find files" })
map("n", "<leader>m", fzf.buffers, { desc = "Buffers" })
map("n", "<leader>ps", fzf.live_grep, { desc = "Live grep" })
map("n", "<leader>he", fzf.helptags, { desc = "Help tags" })
map("n", "<leader>gf", fzf.git_files, { desc = "Git files" })
map("n", "<leader>ls", fzf.lsp_document_symbols, { desc = "LSP document symbols" })
map("n", "<leader>lS", fzf.lsp_workspace_symbols, { desc = "LSP workspace symbols" })
map("n", "<leader>te", fzf.builtin, { desc = "FZF-Lua commands" })

map("n", "<leader>db", require("dap").toggle_breakpoint, { desc = "Toggle Breakpoint" })
map("n", "<leader>dt", "<cmd>DapViewToggle<cr>", { desc = "Dap Toggle View" })
map("n", "<leader>dw", "<cmd>DapViewWatch<cr>", { desc = "Dap View Watch" })
map("n", "<leader>dc", require("dap").continue, { desc = "Continue Debugging" })
map("n", "<leader>dx", require("dap").terminate, { desc = "Terminate Debug" })
map("n", "<leader>dr", require("dap").repl.open, { desc = "Open REPL" })

map("n", "<leader>do", require("dap").step_over, { desc = "Step Over" })
map("n", "<leader>di", require("dap").step_into, { desc = "Step Into" })
map("n", "<leader>da", function()
    local args = vim.fn.input("New args: ")
    local parsed = vim.trim(args) == "" and {} or vim.split(args, " ", { trimempty = true })
    for _, ft in ipairs({ "c", "cpp", "rust", "zig" }) do
        if require("dap").configurations[ft] and require("dap").configurations[ft][1] then
            require("dap").configurations[ft][1].args = parsed
        end
    end
end, { desc = "Set args for debugging" })


map("n", "<leader>?", function()
    require("which-key").show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })




map("n", "<leader>gi", "<cmd>Git<CR>", { desc = "Fugitive status" })
map("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Fugitive blame" })
map("n", "<leader>gd", "<cmd>Gvdiffsplit<CR>", { desc = "Fugitive vertical diff" })
map("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "Fugitive commit" })
map("n", "<leader>gP", "<cmd>Git push<CR>", { desc = "Fugitive push" })
map("n", "<leader>gp", "<cmd>Git pull<CR>", { desc = "Fugitive pull" })
map("n", "<leader>gl", "<cmd>Git log --oneline --decorate --graph<CR>", { desc = "Fugitive log" })
map("n", "<leader>gL", "<cmd>Gclog<CR>", { desc = "Fugitive log" })



map("n", "<leader>e", helpers.open_workspace_diagnostics, { desc = "Diagnostics (workspace)" })
map("n", "<leader>E", helpers.open_buffer_diagnostics, { desc = "Diagnostics (buffer)" })

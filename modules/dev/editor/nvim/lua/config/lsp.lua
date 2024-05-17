local luasnipvscode = require("luasnip.loaders.from_vscode")
local lspconfig_util = require("lspconfig/util")
local rusttools = require("rust-tools")
local cmpnvim = require("cmp_nvim_lsp")
local neodev = require("neodev")
local lspconfig = require("lspconfig")
local luasnip = require("luasnip")
local cmp = require("cmp")

local function init()
    -- TODO breadcrumbs instead of context?
    -- TODO call trees
    -- TODO symbols on the right instead

    -- LSP
    -- nvim-lspconfig: https://github.com/neovim/nvim-lspconfig -- Collection of configurations for built-in LSP client
    -- nvim-cmp: https://github.com/hrsh7th/nvim-cmp -- Autocompletion plugin
    -- cmp-nvim-lsp: https://github.com/hrsh7th/cmp-nvim-lsp -- LSP source for nvim-cmp
    -- cmp_luasnip: https://github.com/saadparwaiz1/cmp_luasnip -- Snippets source for nvim-cmp
    -- LuaSnip: https://github.com/L3MON4D3/LuaSnip -- Snippets plugin

    ---------------------- Completion and diagnostics UI modifications
    vim.opt.completeopt = { "menu", "menuone", "noselect" }
    vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })
    vim.diagnostic.config({
        update_in_insert = false,
        underline = false,
        signs = true,
        virtual_text = true,
        severity_sort = true,
        float = {
            border = "rounded",
            source = "always",
        },
    })

    require("config.autocommands").close_with_q("lspinfo", { "lspinfo" })

    ---------------------- Load Snippets
    luasnipvscode.lazy_load()

    ---------------------- cmp setup
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
    local kind_icons = {
        Text = "",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰇽",
        Variable = "󰂡",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰅲",
        -- Codeium = "",
    }
    -- local catppuccin_mocha = require("catppuccin.palettes").get_palette("mocha")
    -- vim.api.nvim_set_hl(0, "CmpItemKindCodeium", { fg = catppuccin_mocha.sky })

    local cmp_select_opts = { behavior = cmp.SelectBehavior.Select }
    cmp.setup({
        enabled = function()
            return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
        end,
        window = {
            completion = cmp.config.window.bordered({
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            }),
            documentation = cmp.config.window.bordered({
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            }),
        },
        formatting = {
            format = function(entry, vim_item)
                vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
                vim_item.menu = ({
                    -- codeium = "[AI]",
                    buffer = "[Buf]",
                    nvim_lsp = "[LSP]",
                    luasnip = "[Snip]",
                    nvim_lua = "[Lua]",
                })[entry.source.name]
                return vim_item
            end,
        },
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<C-y>"] = cmp.mapping.confirm({ select = true }),
            ["<C-e>"] = cmp.mapping.abort(),

            ["<Up>"] = cmp.mapping.select_prev_item(cmp_select_opts),
            ["<Down>"] = cmp.mapping.select_next_item(cmp_select_opts),
            ["<C-p>"] = cmp.mapping(function()
                if cmp.visible() then
                    cmp.select_prev_item(cmp_select_opts)
                else
                    cmp.complete()
                end
            end),
            ["<C-n>"] = cmp.mapping(function()
                if cmp.visible() then
                    cmp.select_next_item(cmp_select_opts)
                else
                    cmp.complete()
                end
            end),
            ["<Tab>"] = cmp.mapping(function(fallback)
                local col = vim.fn.col(".") - 1
                if cmp.visible() then
                    cmp.select_next_item(cmp_select_opts)
                elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
                    fallback()
                else
                    cmp.complete()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item(cmp_select_opts)
                else
                    fallback()
                end
            end, { "i", "s" }),

            ["<C-u>"] = cmp.mapping.scroll_docs(-5),
            ["<C-d>"] = cmp.mapping.scroll_docs(5),
            ["<C-f>"] = cmp.mapping(function(fallback)
                if luasnip.jumpable(1) then
                    luasnip.jump(1)
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<C-b>"] = cmp.mapping(function(fallback)
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
            -- { name = "codeium" },
            { name = "nvim_lsp" },
            { name = "nvim_lsp_signature_help" },
            { name = "nvim_lua" }, -- FIXME: might not need this anymore due to neodev.nvim
            { name = "luasnip" },
            { name = "path" },
        }, {
            { name = "buffer", keyword_length = 3 },
        }),
    })

    -- Set configuration for specific filetype.
    cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
            { name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
        }, {
            { name = "buffer" },
        }),
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer" },
        },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "path" },
        }, {
            { name = "cmdline" },
        }),
    })

    -- Completions on dap UI
    cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
        sources = {
            { name = "dap" },
        },
    })

    -- Emoji completions on markdown
    cmp.setup.filetype({ "markdown" }, {
        sources = {
            { name = "emoji" },
        },
    })

    -------------------------------------------- LSP
    -- Add additional capabilities supported by nvim-cmp
    local capabilities = cmpnvim.default_capabilities()

    ---------------------- Lua
    neodev.setup({
        library = {
            -- you can also specify the list of plugins to make available as a workspace library
            plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim", "nvim-dap-ui" },
        },
        override = function(root_dir, library)
            if root_dir:find("/etc/nixos", 1, true) == 1 or root_dir:find("/nix/store", 1, true) == 1 then
                library.enabled = true
                library.plugins = true
            end
        end,
    })

    lspconfig.lua_ls.setup({
        settings = {
            Lua = {
                telemetry = { enable = false },
                format = { enable = false },
                completion = {
                    callSnippet = "Replace",
                },
            },
        },
    })

    ---------------------- bash
    lspconfig.bashls.setup({})

    ---------------------- docker
    lspconfig.dockerls.setup({})
    -- lspconfig.docker_compose_language_service.setup({
    --     filetypes = { "yaml.docker-compose" }, -- TOOD: setup ft?
    -- })

    ---------------------- terraform
    lspconfig.terraformls.setup({})

    ---------------------- Nix
    lspconfig.nil_ls.setup({
        capabilities = capabilities,
        autostart = true,
        settings = {
            ["nil"] = {
                formatting = {
                    command = { "alejandra" },
                },
            },
        },
    })

    -- seems to be not working well
    -- lspconfig.nixd.setup({})

    ---------------------- Python
    -- Setup python lsp
    lspconfig.ruff_lsp.setup({})
    lspconfig.pyright.setup({}) -- remove if duplicates with ruff

    ---------------------- Go
    lspconfig.gopls.setup({
        capabilities = capabilities,
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_dir = lspconfig_util.root_pattern("go.work", "go.mod", ".git"),
        settings = {
            gopls = {
                staticcheck = true,
                usePlaceholders = true,
                completeUnimported = true,
                experimentalPostfixCompletions = true,
                analyses = {
                    unusedparams = true,
                    shadow = true,
                },
            },
        },
        init_options = {
            usePlaceholders = true,
        },
    })
    lspconfig.golangci_lint_ls.setup({})

    ---------------------- Rust
    -- Setup rust_analyzer via rust-tools.nvim
    rusttools.setup({
        server = {
            capabilities = capabilities,
        },
    })

    ---------------------- HTMX
    -- lspconfig.htmx.setup() -- Currently buggy with the LSP version

    -- TODO: Setup jsonls https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#jsonls

    -- LspAttach mappings
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
            -- NOTE: Some keybingds are set with trouble

            -- Enable completion triggered by <c-x><c-o>
            -- Also see: https://github.com/hrsh7th/nvim-cmp/wiki/Language-Server-Specific-Samples#golang-gopls
            vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
            vim.bo[ev.buf].tagfunc = "v:lua.vim.lsp.tagfunc"
            vim.bo[ev.buf].formatexpr = "v:lua.vim.lsp.formatexpr()"

            local function opts(desc)
                return { buffer = ev.buf, desc = desc }
            end

            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Hover [LSP]"))
            vim.keymap.set("n", "gk", vim.lsp.buf.signature_help, opts("Signature [LSP]"))
            vim.keymap.set("n", "gR", vim.lsp.buf.rename, opts("Rename [LSP]"))
            vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts("Line Diagnostics"))
            vim.keymap.set({ "n", "v" }, "ga", vim.lsp.buf.code_action, opts("Code Action [LSP]"))
            vim.keymap.set("n", "gh", function()
                vim.lsp.buf.format({ async = true })
            end, opts("Format"))

            -- Workspace keymaps
            vim.keymap.set("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, opts("Workspace Add"))
            vim.keymap.set("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, opts("Workspace Remove"))
            vim.keymap.set("n", "<leader>lwl", function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts("Workspace List"))
        end,
    })
end

return { init = init }

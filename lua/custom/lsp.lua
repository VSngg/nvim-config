-- LSP settings.

vim.diagnostic.config({ virtual_text = false })
--  This function gets run when an LSP connects to a particular buffer.


-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
    completion = {
        -- autocomplete = false,
        keyword_length = 3,
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
        else
                        fallback()
                    end
                end, { 'i', 's' }),
    },
        sources = {
        { name = 'buffer'},
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
}

require("luasnip.loaders.from_vscode").lazy_load()
-- null-ls setup
local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.stylua,
    },
})

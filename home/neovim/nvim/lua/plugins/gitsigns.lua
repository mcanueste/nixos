return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
      end

      -- stylua: ignore start
      map("n", "]h", gs.next_hunk, "Next Hunk")
      map("n", "[h", gs.prev_hunk, "Prev Hunk")
      map("n", "<leader>vd", gs.diffthis, "Diff This")
      map("n", "<leader>vD", function() gs.diffthis("~") end, "Diff This ~")
      map("n", "<leader>vp", gs.preview_hunk, "Preview Hunk")
      map("n", "<leader>vb", function() gs.blame_line({ full = true }) end, "Blame Line")
      map({ "n", "v" }, "<leader>vs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
      map({ "n", "v" }, "<leader>vsu", gs.undo_stage_hunk, "Undo Stage Hunk")
      map("n", "<leader>vS", gs.stage_buffer, "Stage Buffer")
      map({ "n", "v" }, "<leader>vr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
      map("n", "<leader>vR", gs.reset_buffer, "Reset Buffer")
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk") -- ?
    end,
  },
}

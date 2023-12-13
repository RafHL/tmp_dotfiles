--------------------------------------------------------------------------------
-- Written by Rafael Hernandez on 10/2020                                     --
--                                                                            --
-- Makes various blocks of SV code that looks like the following:             --
--        // vpf                                                              --
--        for (i = 0; i < 11; i++) begin: vpf_i                               --
--            for (j = 0; j < 9; j++) begin: vpf_j                            --
--                for (k = 0; k < 2; k++) begin: vpf_k                        --
--                    if (is >= 182) begin                                    --
--                        is = 0;                                             --
--                        js++;                                               --
--                    end                                                     --
--                    assign vpf[i][j][k] = sr0[is][js];                      --
--                end                                                         --
--            end                                                             --
--        end                                                                 --
--        // At sr0:198 bits                                                  --
--                                                                            --
-- Purpose: I had to do this manually like 15 times, then realized I needed   --
--              to decrease the amount of bits I am using which meant I had   --
--              to do all that work over again.                               --
--          That or put my thought process into a program I can execute to    --
--              generate these lines for me.                                  --
--          Now this file generates the entire register connections for me!   --
--------------------------------------------------------------------------------

function pcs_reg()
--    -- Load rassign if not already loaded
--    if rassign == nil then
--        vim.api.nvim_input("<ESC>:luafile ~/scripts/work/rassign.lua")
--        wait()
--    end

    local onlyOutput = 0

    -- Set up variables used for script

    local vnames = {
        "vpf", "wg", "hstr", "cpat"
    }
    vdims = {
        {6,9,2}, {6,9,2,7}, {6,9,2,8}, {6,9,2,4}
    }
    local srnams = "sr"
    local srnums = 0
    local srdims = {6,160}
    local srfils = 0

    if (table.getn(vdims) ~= table.getn(vnames)) then
        print("ERROR: vdims and vnames don't have the same number of indeces! Try again after fixing this error")
        print (". vdims vnames")
        print (tostring(table.getn(vdims)))
        print (tostring(table.getn(vnames)))
        return
    end

    -- assign vr = sr
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>o <BS><ESC>S<ENTER>is = 0;<ENTER>js = 0;<ESC>", true, true, true), 'n', true)
    if (onlyOutput == 0) then
        for i,vnam in ipairs(vnames) do
            --srnums, srfils = rassign(vnam, vdims[i], srnams, srnums, srdims, srfils)
            srnums, srfils = rassign(vnam, vdims[i], srnams, srnums, srdims, srfils)
        end
    end
    srnums = 0
    srfils = 0
    srnams = "so"
    local vnames = {

        "ph_0", "ph_1", "ph_2", "ph_3", "ph_4", "ph_5", "th11", "th", "vl",
        "phzvl", "me11a", "cpatr", "ph_hit_0", "ph_hit_1", "ph_hit_2",
        "ph_hit_3", "ph_hit_4", "ph_hit_5"
    }
    vdims = {
        {9,2,13}, {9,2,13}, {9,2,13}, {9,2,13}, {9,2,13}, {9,2,13}, {3,3,4,7},
        {6,9,2,7}, {6,9,2}, {6,9,7}, {3,3,2}, {6,9,2,4}, {9,4}, {9,4}, {9,4},
        {9,4}, {9,4}, {9,44}
    }
    -- assign sr = vr
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>o <BS><ESC>S<ENTER>is = 0;<ENTER>js = 0;<ESC>", true, true, true), 'n', true)
    for i,vnam in ipairs(vnames) do
        --srnums, srfils = rassign(vnam, vdims[i], srnams, srnums, srdims, srfils)
        srnums, srfils = rassign(vnam, vdims[i], srnams, srnums, srdims, srfils, 1)
    end
end

print ("pcs_reg loaded! To use, call pcs_reg()")



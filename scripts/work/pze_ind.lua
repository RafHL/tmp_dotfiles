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

function pze_reg()
--    -- Load rassign if not already loaded
--    if rassign == nil then
--        vim.api.nvim_input("<ESC>:luafile ~/scripts/work/rassign.lua")
--        wait()
--    end

    local onlyOutput = 1

    -- Set up variables used for script

    local vnames = {
        "vpf", "wg", "hstr", "cpat", "th_corr_mem_0_0", "th_corr_mem_0_1",
        "th_corr_mem_0_2", "th_corr_mem_1_0", "th_corr_mem_1_1",
        "th_corr_mem_1_2", "th_corr_mem_2_0", "th_corr_mem_2_1",
        "th_corr_mem_2_2", "params_0", "params_1", "params_2", "params_3",
        "params_4", "params_5", "th_mem_0_0", "th_mem_0_1", "th_mem_0_2",
        "th_mem_0_3", "th_mem_0_4", "th_mem_0_5", "th_mem_0_6", "th_mem_0_7",
        "th_mem_0_8", "th_mem_1_0", "th_mem_1_1", "th_mem_1_2", "th_mem_1_3",
        "th_mem_1_4", "th_mem_1_5", "th_mem_1_6", "th_mem_1_7", "th_mem_1_8",
        "th_mem_2_0", "th_mem_2_1", "th_mem_2_2", "th_mem_2_3", "th_mem_2_4",
        "th_mem_2_5", "th_mem_2_6", "th_mem_2_7", "th_mem_2_8", "th_mem_3_0",
        "th_mem_3_1", "th_mem_3_2", "th_mem_3_3", "th_mem_3_4", "th_mem_3_5",
        "th_mem_3_6", "th_mem_3_7", "th_mem_3_8", "th_mem_4_0", "th_mem_4_1",
        "th_mem_4_2", "th_mem_4_3", "th_mem_4_4", "th_mem_4_5", "th_mem_4_6",
        "th_mem_4_7", "th_mem_4_8", "th_mem_5_0", "th_mem_5_1", "th_mem_5_2",
        "th_mem_5_3", "th_mem_5_4", "th_mem_5_5", "th_mem_5_6", "th_mem_5_7",
        "th_mem_5_8", "ph_ext_0_0", "ph_ext_0_1", "ph_ext_0_2", "ph_ext_0_3",
        "ph_ext_0_4", "ph_ext_0_5", "ph_ext_0_6", "ph_ext_0_7", "ph_ext_0_8",
        "ph_ext_0_9", "ph_ext_0_10", "ph_ext_0_11", "ph_ext_0_12",
        "ph_ext_0_13", "ph_ext_0_14", "ph_ext_0_15", "ph_ext_1_0", "ph_ext_1_1",
        "ph_ext_1_2", "ph_ext_1_3", "ph_ext_1_4", "ph_ext_1_5", "ph_ext_1_6",
        "ph_ext_1_7", "ph_ext_1_8", "ph_ext_1_9", "ph_ext_1_10", "ph_ext_1_11",
        "ph_ext_1_12", "ph_ext_1_13", "ph_ext_1_14", "ph_ext_1_15",
        "ph_ext_2_0", "ph_ext_2_1", "ph_ext_2_2", "ph_ext_2_3", "ph_ext_2_4",
        "ph_ext_2_5", "ph_ext_2_6", "ph_ext_2_7", "ph_ext_2_8", "ph_ext_2_9",
        "ph_ext_2_10", "ph_ext_2_11", "ph_ext_2_12", "ph_ext_2_13",
        "ph_ext_2_14", "ph_ext_2_15", "ph_ext_3_0", "ph_ext_3_1", "ph_ext_3_2",
        "ph_ext_3_3", "ph_ext_3_4", "ph_ext_3_5", "ph_ext_3_6", "ph_ext_3_7",
        "ph_ext_3_8", "ph_ext_3_9", "ph_ext_3_10", "ph_ext_3_11", "ph_ext_3_12",
        "ph_ext_3_13", "ph_ext_3_14", "ph_ext_3_15", "ph_ext_4_0", "ph_ext_4_1",
        "ph_ext_4_2", "ph_ext_4_3", "ph_ext_4_4", "ph_ext_4_5", "ph_ext_4_6",
        "ph_ext_4_7", "ph_ext_4_8", "ph_ext_4_9", "ph_ext_4_10", "ph_ext_4_11",
        "ph_ext_4_12", "ph_ext_4_13", "ph_ext_4_14", "ph_ext_4_15",
        "ph_ext_5_0", "ph_ext_5_1", "ph_ext_5_2", "ph_ext_5_3", "ph_ext_5_4",
        "ph_ext_5_5", "ph_ext_5_6", "ph_ext_5_7", "ph_ext_5_8", "ph_ext_5_9",
        "ph_ext_5_10", "ph_ext_5_11", "ph_ext_5_12", "ph_ext_5_13",
        "ph_ext_5_14", "ph_ext_5_15", "ph_ext_6_0", "ph_ext_6_1", "ph_ext_6_2",
        "ph_ext_6_3", "ph_ext_6_4", "ph_ext_6_5", "ph_ext_6_6", "ph_ext_6_7",
        "ph_ext_6_8", "ph_ext_6_9", "ph_ext_6_10", "ph_ext_6_11", "ph_ext_6_12",
        "ph_ext_6_13", "ph_ext_6_14", "ph_ext_6_15"
    }
    vdims = {
        {11,9,2}, {6,9,2,7}, {6,9,2,8}, {6,9,2,4}, {128,4}, {128,4}, {128,4},
        {128,4}, {128,4}, {128,4}, {128,4}, {128,4}, {128,4}, {9,6,13},
        {9,6,13}, {9,6,13}, {9,6,13}, {9,6,13}, {9,6,13}, {128,6}, {128,6},
        {128,6}, {128,6}, {128,6}, {128,6}, {128,6}, {128,6}, {128,6}, {128,6},
        {128,6}, {128,6}, {128,6}, {128,6}, {128,6}, {128,6}, {128,6}, {128,6},
        {128,6}, {128,6}, {128,6}, {128,6}, {128,6}, {128,6}, {128,6}, {128,6},
        {128,6}, {128,6}, {128,6}, {128,6}, {128,6}, {128,6}, {128,6}, {128,6},
        {128,6}, {128,6}, {128,6}, {128,6}, {128,6}, {128,6}, {128,6}, {128,6},
        {128,6}, {128,6}, {128,6}, {128,6}, {128,6}, {128,6}, {128,6}, {128,6},
        {128,6}, {128,6}, {128,6}, {128,6}, {160}, {160}, {160}, {160}, {160},
        {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160},
        {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160},
        {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160},
        {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160},
        {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160},
        {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160},
        {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160},
        {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160},
        {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160},
        {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160},
        {160}, {160}, {160}, {160}, {160}, {160}, {160}
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
    if (onlyOutput == 0) then
        for i,vnam in ipairs(vnames) do
            --srnums, srfils = rassign(vnam, vdims[i], srnams, srnums, srdims, srfils)
            srnums, srfils = rassign_ind(vnam, vdims[i], srnams, srnums, srdims, srfils)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>k", true, true, true), 'n', true)
        end
    end
    srnums = 0
    srfils = 0
    srnams = "so"
    local vnames = {
        "ph_ext_0_0", "ph_ext_0_1", "ph_ext_0_2", "ph_ext_0_3",
        "ph_ext_0_4", "ph_ext_0_5", "ph_ext_0_6", "ph_ext_0_7", "ph_ext_0_8",
        "ph_ext_0_9", "ph_ext_0_10", "ph_ext_0_11", "ph_ext_0_12",
        "ph_ext_0_13", "ph_ext_0_14", "ph_ext_0_15", "ph_ext_1_0", "ph_ext_1_1",
        "ph_ext_1_2", "ph_ext_1_3", "ph_ext_1_4", "ph_ext_1_5", "ph_ext_1_6",
        "ph_ext_1_7", "ph_ext_1_8", "ph_ext_1_9", "ph_ext_1_10", "ph_ext_1_11",
        "ph_ext_1_12", "ph_ext_1_13", "ph_ext_1_14", "ph_ext_1_15",
        "ph_ext_2_0", "ph_ext_2_1", "ph_ext_2_2", "ph_ext_2_3", "ph_ext_2_4",
        "ph_ext_2_5", "ph_ext_2_6", "ph_ext_2_7", "ph_ext_2_8", "ph_ext_2_9",
        "ph_ext_2_10", "ph_ext_2_11", "ph_ext_2_12", "ph_ext_2_13",
        "ph_ext_2_14", "ph_ext_2_15", "ph_ext_3_0", "ph_ext_3_1", "ph_ext_3_2",
        "ph_ext_3_3", "ph_ext_3_4", "ph_ext_3_5", "ph_ext_3_6", "ph_ext_3_7",
        "ph_ext_3_8", "ph_ext_3_9", "ph_ext_3_10", "ph_ext_3_11", "ph_ext_3_12",
        "ph_ext_3_13", "ph_ext_3_14", "ph_ext_3_15", "ph_ext_4_0", "ph_ext_4_1",
        "ph_ext_4_2", "ph_ext_4_3", "ph_ext_4_4", "ph_ext_4_5", "ph_ext_4_6",
        "ph_ext_4_7", "ph_ext_4_8", "ph_ext_4_9", "ph_ext_4_10", "ph_ext_4_11",
        "ph_ext_4_12", "ph_ext_4_13", "ph_ext_4_14", "ph_ext_4_15",
        "ph_ext_5_0", "ph_ext_5_1", "ph_ext_5_2", "ph_ext_5_3", "ph_ext_5_4",
        "ph_ext_5_5", "ph_ext_5_6", "ph_ext_5_7", "ph_ext_5_8", "ph_ext_5_9",
        "ph_ext_5_10", "ph_ext_5_11", "ph_ext_5_12", "ph_ext_5_13",
        "ph_ext_5_14", "ph_ext_5_15", "ph_ext_6_0", "ph_ext_6_1", "ph_ext_6_2",
        "ph_ext_6_3", "ph_ext_6_4", "ph_ext_6_5", "ph_ext_6_6", "ph_ext_6_7",
        "ph_ext_6_8", "ph_ext_6_9", "ph_ext_6_10", "ph_ext_6_11", "ph_ext_6_12",
        "ph_ext_6_13", "ph_ext_6_14", "ph_ext_6_15"
    }
    vdims = {
        {160}, {160}, {160}, {160}, {160},
        {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160},
        {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160},
        {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160},
        {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160},
        {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160},
        {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160},
        {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160},
        {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160},
        {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160},
        {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160}, {160},
        {160}, {160}, {160}, {160}, {160}, {160}, {160}
    }
    -- assign sr = vr
    for i,vnam in ipairs(vnames) do
        --srnums, srfils = rassign(vnam, vdims[i], srnams, srnums, srdims, srfils)
        srnums, srfils = rassign_ind(vnam, vdims[i], srnams, srnums, srdims, srfils, 1)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>k", true, true, true), 'n', true)
    end
end

print ("pze_reg loaded! To use, call pze_reg()")



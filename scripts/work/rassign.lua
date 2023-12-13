--------------------------------------------------------------------------------
-- Written by Rafael Hernandez on 10/2020                                     --
--                                                                            --
-- Makes a block of SV code that looks like the following:                    --
--        // vpf                                                              --
--        for (i = 0; i < 11; i++) begin: vpf_i                               --
--            for (j = 0; j < 9; j++) begin: vpf_j                            --
--                for (k = 0; k < 2; k++) begin: vpf_k                        --
--                    if (js >= 182) begin                                    --
--                        js = 0;                                             --
--                        is++;                                               --
--                    end                                                     --
--                    vpf[i][j][k] = sr0[is][js++];                           --
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
--------------------------------------------------------------------------------

-- vname: name of the variable, like "vpf" above
-- vdims: an array with the dimmensions of the variable, like {11, 9, 2} above
--        can be arbitrary number of variables
-- srnam: Name of register w/o number, "sr" above
-- srnum: Register's number, 0 above
-- srdim: shift register dimensions, like {5, 174}
--        only 2 dimmensions currently supported (all I currently need)
-- srfil: shift register's elements used, like 110
--
-- Sample usage:
-- :luafile <location of this file>/rassign.lua
-- :1 luado rassign("vpf", {11,9,2}, "sr", 0, {5,174}, 110)

function rassign(vname, vdims, srnam, srnum, srdim, srfil, sr_vr)
    local srcap = 1 -- shift register capacity
    local v_cap = 1 -- variable capacity
    local vdlen = 0 -- number of dimmensions in vdims
    local sdlen = 0 -- number of dimmensions in srdim
    local itr -- will hold iterator name
    local i

    i = 1
    while srdim[i] ~= nil do
        srcap = srcap*srdim[i]
        i = i + 1
    end
    sdlen = i - 1

    i = 1
    while vdims[i] ~= nil do
        v_cap = v_cap*vdims[i]
        i = i + 1
    end
    vdlen = i - 1

    -- Number of additional shift registers needed:
    --     These will have the name str(srnam) + str(srnum + srcnt)
    local srcnt = math.ceil((srfil + v_cap)/srcap) - 1

    -- Prepare insert mode and remove auto comment //
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>o <BS><ESC>S<ENTER>", true, true, true), 'n', true)

    -- Assuming variable sr exists,
    --     this will let SV know which shift register we will be using
    if srcnt > 0 then
        vim.api.nvim_feedkeys("sr = 0;", 'n', true)
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ENTER>// ", true, true, true), 'n', true)
    vim.api.nvim_feedkeys(vname, 'n', true)

    -- Send for loop begins
    for i, dim in ipairs(vdims) do
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ENTER>", true, true, true), 'n', true)
        if i == 1 then -- To remove automatic "// "
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<BS><BS><BS>", true, true, true), 'n', true)
        end
        if i > 1 then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<TAB>", true, true, true), 'n', true)
        end
        itr = string.char(string.byte('i') + i - 1)
        vim.api.nvim_feedkeys("for (", 'n', true)
        vim.api.nvim_feedkeys(itr, 'n', true)
        vim.api.nvim_feedkeys(" = 0; ", 'n', true)
        vim.api.nvim_feedkeys(itr, 'n', true)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(" <LT> ", true, true, true), 'n', true)
        vim.api.nvim_feedkeys(tostring(dim), 'n', true)
        vim.api.nvim_feedkeys("; ", 'n', true)
        vim.api.nvim_feedkeys(itr, 'n', true)
        vim.api.nvim_feedkeys("++) begin: ", 'n', true)
        vim.api.nvim_feedkeys(vname, 'n', true)
        vim.api.nvim_feedkeys("_", 'n', true)
        vim.api.nvim_feedkeys(itr, 'n', true)
    end

    -- Send for loops' body
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ENTER><TAB>", true, true, true), 'n', true)
    for i = 0,srcnt do
        if (i == 0 and srcnt > 0) then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("if ", true, true, true), 'n', true)
            if (srcnt > 1) then
                vim.api.nvim_feedkeys("     ", 'n', true)
            end
            vim.api.nvim_feedkeys("(sr == ", 'n', true)
        elseif (i > 0 and i < srcnt) then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("else if (sr == ", true, true, true), 'n', true)
        elseif (srcnt > 0) then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("else         ", true, true, true), 'n', true)
            if (srcnt > 1) then
                vim.api.nvim_feedkeys("     ", 'n', true)
            end
        end
        if i < srcnt then
            vim.api.nvim_feedkeys(tostring(i), 'n', true)
            vim.api.nvim_feedkeys(") ", 'n', true)
        end
        --vim.api.nvim_feedkeys("assign ", 'n', true)
        if (sr_vr) then
            vim.api.nvim_feedkeys(srnam, 'n', true)
            vim.api.nvim_feedkeys(tostring(srnum+i), 'n', true)
            vim.api.nvim_feedkeys("[is][js++]", 'n', true)
        else
            vim.api.nvim_feedkeys(vname, 'n', true)
            for j = 1,vdlen do
                itr = string.char(string.byte('i') + j - 1)
                vim.api.nvim_feedkeys("[", 'n', true)
                vim.api.nvim_feedkeys(itr, 'n', true)
                vim.api.nvim_feedkeys("]", 'n', true)
            end
        end
        vim.api.nvim_feedkeys(" = ", 'n', true)
        if (sr_vr) then
            vim.api.nvim_feedkeys(vname, 'n', true)
            for j = 1,vdlen do
                itr = string.char(string.byte('i') + j - 1)
                vim.api.nvim_feedkeys("[", 'n', true)
                vim.api.nvim_feedkeys(itr, 'n', true)
                vim.api.nvim_feedkeys("]", 'n', true)
            end
        else
            vim.api.nvim_feedkeys(srnam, 'n', true)
            vim.api.nvim_feedkeys(tostring(srnum+i), 'n', true)
            vim.api.nvim_feedkeys("[is][js++]", 'n', true)
        end
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(";<ENTER>", true, true, true), 'n', true)
    end
    vim.api.nvim_feedkeys("if (js >= ", 'n', true)
    vim.api.nvim_feedkeys(tostring(srdim[2]), 'n', true)
    vim.api.nvim_feedkeys(") begin", 'n', true)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ENTER><TAB>js = 0;<ENTER>is++;", true, true, true), 'n', true)
    if srcnt > 0 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ENTER>if (is >= ", true, true, true), 'n', true)
        vim.api.nvim_feedkeys(tostring(srdim[1]), 'n', true)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(") begin<ENTER><TAB>sr++;<ENTER>is = 0;<ENTER>js = 0;", true, true, true), 'n', true)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ENTER><BS>end", true, true, true), 'n', true)
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ENTER><BS>end", true, true, true), 'n', true)

    -- Send for loops' end
    for i, dim in ipairs(vdims) do
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ENTER><BS>end", true, true, true), 'n', true)
    end

    -- Send end results
    for i = 0, srcnt do
        if i == 0 then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ENTER>// At ", true, true, true), 'n', true)
        else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ENTER>At ", true, true, true), 'n', true)
        end
        vim.api.nvim_feedkeys(srnam, 'n', true)
        vim.api.nvim_feedkeys(tostring(srnum+i), 'n', true)
        vim.api.nvim_feedkeys(":", 'n', true)
        if (v_cap  >= (srcap - srfil)) then
            vim.api.nvim_feedkeys(tostring(srcap), 'n', true)
            vim.api.nvim_feedkeys("/Full", 'n', true)
            v_cap = v_cap - (srcap - srfil)
            srfil = 0
        else
            vim.api.nvim_feedkeys(tostring(v_cap+srfil), 'n', true)
            vim.api.nvim_feedkeys("/Not full", 'n', true)
        end
    end
    if (v_cap == 0 and srcnt == 0) then
        srcnt = 1
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>o <BS><ESC>Sis = 0;", true, true, true), 'n', true)
    end

    return srnum+srcnt, v_cap+srfil
end

print ("rassign function loaded! To use, call rassign()")


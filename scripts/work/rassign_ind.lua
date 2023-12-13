--------------------------------------------------------------------------------
-- Written by Rafael Hernandez on 10/2020                                     --
--                                                                            --
-- Makes a block of unrolled SV code that looks like the following rolled:    --
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
--------------------------------------------------------------------------------

-- vname: name of the variable, like "vpf" above
-- vdims: an array with the dimmensions of the variable, like {11, 9, 2} above
--        can be arbitrary number of variables
-- srnam: Name of register w/o number, "sr" above
-- srnum: Register's number, 0 above
-- srdim: shift register dimensions, like {5, 174}
--        only 2 dimmensions currently supported (all I currently need)
-- srfil: shift register's elements used, like 110
-- sr_vr: 1 for sr[] = vr[], 0/nil for vr[] = sr[]
--
-- Sample usage:
-- :luafile <location of this file>/rassign.lua
-- :1 luado rassign("vpf", {11,9,2}, "sr", 0, {5,174}, 110)

function rassign_ind(vname, vdims, srnam, srnum, srdim, srfil, sr_vr)
    local srcap = 1 -- shift register capacity
    local v_cap = 1 -- variable capacity
    local vdlen = 0 -- number of dimmensions in vdims
    local sdlen = 0 -- number of dimmensions in srdim
    local sr_itr = {} -- shift register iterator table
    local vr_itr = {} -- variable iterator table
    local loop_cur = 0
    local loop_max
    local i
    -- Will have number of additional shift registers needed:
    --     These will have the name str(srnam) + str(srnum + srcnt)
    local srorg = srnum

    i = 1
    while srdim[i] ~= nil do
        srcap = srcap*srdim[i]
        sr_itr[i] = 0
        i = i + 1
    end
    sdlen = i - 1
    -- Start at next empty index
    sr_itr[sdlen] = srfil
    if bound_check(sr_itr, srdim, sdlen) == 0 then
        srnum = srnum + 1
    end

    i = 1
    while vdims[i] ~= nil do
        v_cap = v_cap*vdims[i]
        vr_itr[i] = 0
        i = i + 1
    end
    vdlen = i - 1

    local srcnt = math.ceil((srfil + v_cap)/srcap) - 1
    loop_max = v_cap + 10

    -- Prepare insert mode and remove auto comment // if it exists
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>o <BS><ESC>S", true, true, true), 'n', true)

    -- Indicate start of new variable assigns
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ENTER>// ", true, true, true), 'n', true)
    vim.api.nvim_feedkeys(vname, 'n', true)

    -- Unroll for loop begins; move onto next line and remove auto comment if it exists
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>o <BS><ESC>S", true, true, true), 'n', true)
    -- For all the input dimmensions
    while (loop_cur <= loop_max and bound_check(vr_itr, vdims, vdlen) == 1) do
        -- Send for loops' body
        vim.api.nvim_feedkeys("assign ", 'n', true)
        if sr_vr then
            vim.api.nvim_feedkeys(srnam, 'n', true)
            vim.api.nvim_feedkeys(tostring(srnum), 'n', true)
            send_index(sr_itr, sdlen)
        else
            vim.api.nvim_feedkeys(vname, 'n', true)
            send_index(vr_itr, vdlen)
        end
        vim.api.nvim_feedkeys(" = ", 'n', true)
        if sr_vr then
            vim.api.nvim_feedkeys(vname, 'n', true)
            send_index(vr_itr, vdlen)
        else
            vim.api.nvim_feedkeys(srnam, 'n', true)
            vim.api.nvim_feedkeys(tostring(srnum), 'n', true)
            send_index(sr_itr, sdlen)
        end
        vim.api.nvim_feedkeys(";", 'n', true)
        vr_itr[vdlen] = vr_itr[vdlen] + 1
        sr_itr[sdlen] = sr_itr[sdlen] + 1
        -- Check if current shift register is full
        if bound_check(sr_itr, srdim, sdlen) == 0 then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(" // ", true, true, true), 'n', true)
            vim.api.nvim_feedkeys(srnam, 'n', true)
            vim.api.nvim_feedkeys(tostring(srnum), 'n', true)
            vim.api.nvim_feedkeys(" /Full ", 'n', true)
            vim.api.nvim_feedkeys(tostring(srcap), 'n', true)
            srnum = srnum + 1
        end
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ENTER>", true, true, true), 'n', true)
        loop_cur = loop_cur + 1
    end

    if (loop_cur >= loop_max) then
        vim.api.nvim_feedkeys("// WARNING: Looped for too long!", 'n', true)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>o <BS><ESC>S", true, true, true), 'n', true)
    end

    if (srcnt ~= (srnum - srorg)) then
        vim.api.nvim_feedkeys("// WARNING: Indeces went wrong somewhere!", 'n', true)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>o <BS><ESC>S", true, true, true), 'n', true)
    end

    -- Send end results
    for i = srcnt, 0, -1 do
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("// At ", true, true, true), 'n', true)
        vim.api.nvim_feedkeys(srnam, 'n', true)
        vim.api.nvim_feedkeys(tostring(srnum-i), 'n', true)
        vim.api.nvim_feedkeys(":", 'n', true)
        vim.api.nvim_feedkeys(tostring(srnum), 'n', true)
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
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>o <BS><ESC>S", true, true, true), 'n', true)
    end

    return srnum, v_cap+srfil
end

-- Checks the bounds for a particular set of input iterators
--
-- itr - table with current iterator values, like {0,1} for i = 0, j = 1
-- max_dim - table with maximum bound for the iterators, like {5, 7} for i < 5, j < 7
-- dim_len - number of dimmensions to check from itr/max_dim like 2 for i and j
--
-- Returns 1 if itr is within the bounds provided by max_dim
-- Returns 0 if itr is out of bounds (carry is 1)
--
-- Inputs must not be nil, and dim_len must be <= len(itr) and len(max_dim)
function bound_check(itr, max_dim, dim_len)
    local tmp
    -- Out of bounds if inputs aren't legal
    if itr == nil or max_dim == nil or dim_len == nil or dim_len == 0 then
        return 0
    end
    for i = dim_len, 1, -1 do
        if itr[i] >= max_dim[i] then
            tmp = itr[i]
            itr[i] = (itr[i] % max_dim[i])
            if i > 1 then
                itr[i-1] = itr[i-1] + math.floor(tmp/max_dim[i])
            else
                --print("False")
                return 0
            end
        end
    end
    --print("True")
    return 1
end

-- Sends itr in form [itr[0]][itr[1]]...
-- With [ being optional input sep1, and ] being optional input sep2
--
-- itr - iterator
-- itr_dim - dimmensions of itr you want to send
-- sep1 - first separator, defaults to [ if either sep missing
-- sep2 - second separator, defaults to ] if either sep missing
function send_index(itr, itr_dim, sep1, sep2)
    -- No itr
    if itr == null then
        return
    end

    -- Deal with optional inputs, if either missing, use "[","]"
    if sep1 == nil or sep2 == nil then
        sep1 = "["
        sep2 = "]"
    end

    -- Send all the iterators
    for i = 1, itr_dim do
        vim.api.nvim_feedkeys(sep1, 'n', true)
        vim.api.nvim_feedkeys(tostring(itr[i]), 'n', true)
        vim.api.nvim_feedkeys(sep2, 'n', true)
    end
end

print ("rassign_ind function loaded! To use, call rassign_ind()")




Hello Sid and Dr Lam!

 

Here are my lua functions, and the version of the wrapper I used for synthesis.

 

Extra info on wrapper:

Sid, the wrapper ends up using a for loop inside an always @* block (combinatorial logic/wires) and an always @posedge clk (input shift register shifting, and output register new data clocking/shifting). Note the input stall and output shift variables. I didn't have an output shift at first, and it took a while to debug why I was getting 0 resource usages: turns out that if you shift the output register as well as assign every bit  a value from the output, verilog assumes you care more about the shifting than the output connections and optimizes away all the output connections. Fun times.

 

Extra info on Lua scripts:

These rely heavily on NeoVim, which is available on Windows/Mac/Linux. To use them, make a copy of the pze_reg function with the names and sizes of the input variables in the correct locations as mentioned inside my rassign header comments.

To run: open your SV file in neovim, scroll down to where you want the for loops to be written, then:

Tap the escape key

Type (the colon is very important. You should begin typing on the lower left corner of the neovim window, if not then tap the escape key a few times) :luafile <path to rassign.lua>/rassign.lua Type :luafile <path to pze_reg.lua>/pze_reg.lua Type

:1 luado pze_reg()

Wait for a few seconds depending on how many variables you have, and then look at the output. Make sure you configured the pze_reg() function properly if the names or sizes are wrong.

 

Additonal comments:

Using any of these tools is completely optional; I made them because my wrapper has too many bits to manually take care of, and I found myself changing the register's dimensions too often for comfort. Too many bits and too many lines means there's a lot more places to check for mistakes vs a centralized function (rassign) that I can tweak and simultaneously fix ~2600 lines of SV code with one function call (pze_reg). I guess playing a vim tutorial wouldn't hurt: https://www.openvim.com/ https://vim-adventures.com/ (the vim adventures, play the free level). To save and exit NeoVim/Vim, use :x. To exit without saving, use :q. rassign depends on your shift registers having two dimensions. I have a version rassign_ind that can take an arbitrary number of dimensions, but it also takes 3-8 hours to generate the individual assign lines, and it isn't heavily tested.

 

Dr Lam, if in the future we decide to make it so this implementation wrapper is almost entirely automatically generated, I could put focus on doing that. Currently, I only automated as much as I felt could save me time without taking up too much time for testing, considering also the time it'd take me to do it manually vs the time dedicated to automating something well enough for it to work.

 

Hope you both are doing well!

- Rafael


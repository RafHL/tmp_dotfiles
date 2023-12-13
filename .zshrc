# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000000
REPORTTIME=10
unsetopt beep
setopt appendhistory autocd extendedglob nomatch notify
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/rafe/.zshrc'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Load installed plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# Autoload prompt theme system
autoload -Uz promptinit
promptinit

# Use chosen prompt theme
prompt walters

# Enable zsh wrong command interpreter
setopt correct

# Map jk to escape
bindkey -M viins 'jk' vi-cmd-mode

# Alias for list
alias ls='ls --color=auto'
alias ll='ls -la'
alias la='ls -la'
alias l.='ls -d .* --color=auto'

# aliases from bash
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='vim -w PKGBUILD'
alias treesiz='tree --du -h'
alias more=less
alias matlabcli='matlab -nosplash -nodesktop'
alias i3-save="$HOME/Documents/i3-restore/i3-save"
alias i3-restore="$HOME/Documents/i3-restore/i3-restore"

# Better yaourt colors from bash
export YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"

# Use vim as default editor
export VISUAL=vim
export EDITOR="$VISUAL"

# Vivado, Rafe self installed
# NEEDED FOR VITIS, CRASHES MODELSIM
#export LD_PRELOAD=/usr/lib/libstdc++.so.6
if [ -n "${PATH}" ]; then
  export PATH=/home/rafe/Xilinx/DocNav:$PATH
else
  export PATH=/home/rafe/Xilinx/DocNav
fi
if [ -n "${PATH}" ]; then
  export PATH=/home/rafe/Xilinx/Vivado/2018.2/bin:$PATH
else
  export PATH=/home/rafe/Xilinx/Vivado/2018.2/bin
fi
#if [ -n "${PATH}" ]; then
#  export PATH=/home/rafe/Xilinx/Vivado/2020.2/bin:$PATH
#else
#  export PATH=/home/rafe/Xilinx/Vivado/2020.2/bin
#fi
if [ -n "${PATH}" ]; then
  export PATH=/home/rafe/Xilinx/Vivado/2023.2/bin:$PATH
else
  export PATH=/home/rafe/Xilinx/Vivado/2023.2/bin
fi
if [ -n "${PATH}" ]; then
  export PATH=/home/rafe/Xilinx/Vitis_HLS/2020.2/bin:$PATH
else
  export PATH=/home/rafe/Xilinx/Vitis_HLS/2020.2/bin
fi

# Removed by Rafael - old version of cmake prevents installation of keyledsd by
# hidding the version installed by pacman
#if [ -n "${PATH}" ]; then
#  export PATH=/home/rafe/Xilinx/SDK/2018.2/bin:/home/rafe/Xilinx/SDK/2018.2/gnu/microblaze/lin/bin:/home/rafe/Xilinx/SDK/2018.2/gnu/arm/lin/bin:/home/rafe/Xilinx/SDK/2018.2/gnu/microblaze/linux_toolchain/lin64_le/bin:/home/rafe/Xilinx/SDK/2018.2/gnu/aarch32/lin/gcc-arm-linux-gnueabi/bin:/home/rafe/Xilinx/SDK/2018.2/gnu/aarch32/lin/gcc-arm-none-eabi/bin:/home/rafe/Xilinx/SDK/2018.2/gnu/aarch64/lin/aarch64-linux/bin:/home/rafe/Xilinx/SDK/2018.2/gnu/aarch64/lin/aarch64-none/bin:/home/rafe/Xilinx/SDK/2018.2/gnu/armr5/lin/gcc-arm-none-eabi/bin:/home/rafe/Xilinx/SDK/2018.2/tps/lnx64/cmake-3.3.2/bin:$PATH
#else
#  export PATH=/home/rafe/Xilinx/SDK/2018.2/bin:/home/rafe/Xilinx/SDK/2018.2/gnu/microblaze/lin/bin:/home/rafe/Xilinx/SDK/2018.2/gnu/arm/lin/bin:/home/rafe/Xilinx/SDK/2018.2/gnu/microblaze/linux_toolchain/lin64_le/bin:/home/rafe/Xilinx/SDK/2018.2/gnu/aarch32/lin/gcc-arm-linux-gnueabi/bin:/home/rafe/Xilinx/SDK/2018.2/gnu/aarch32/lin/gcc-arm-none-eabi/bin:/home/rafe/Xilinx/SDK/2018.2/gnu/aarch64/lin/aarch64-linux/bin:/home/rafe/Xilinx/SDK/2018.2/gnu/aarch64/lin/aarch64-none/bin:/home/rafe/Xilinx/SDK/2018.2/gnu/armr5/lin/gcc-arm-none-eabi/bin:/home/rafe/Xilinx/SDK/2018.2/tps/lnx64/cmake-3.3.2/bin
#fi
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/rafe/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/rafe/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/rafe/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/rafe/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

alias x11vnc="x11vnc -usepw"

# Run ltspice using wine
alias ltspice="wine ~/.wine/drive_c/Program\ Files/LTC/LTspiceXVII/XVIIx64.exe"

#alias quartus="./intelFPGA_lite/19.1/quartus/bin/quartus"
#export PATH=/home/rafe/intelFPGA_lite/19.1/quartus/bin:$PATH
#export PATH=/home/rafe/intelFPGA_lite/19.1/modelsim_ase/bin:$PATH
export PATH=/opt/intelFPGA/21.1/quartus/bin:$PATH
export PATH=/opt/intelFPGA/20.1/modelsim_ase/bin:$PATH
export PATH=/home/rafe/.gem/ruby/2.7.0/bin:$PATH

alias vim=/usr/bin/nvim
alias vvim=/usr/bin/vim

if [ "$SHELL" = '/usr/bin/zsh' ]
then
    case $TERM in
        *term*|rxvt*|screen*|tmux*)
         precmd() { print -Pn "\e]0;%m:%~\a" }
         preexec () { print -Pn "\e]0;$1\a" }
         ;;
    esac
fi

export QSYS_ROOTDIR="/home/rafe/.cache/yay/quartus-free/pkg/quartus-free-quartus/opt/intelFPGA/21.1/quartus/sopc_builder/bin"
export PATH="/opt/intelFPGA/21.1/quartus/bin":$PATH
export PATH="/opt/gowin-eda-programmer/bin":$PATH
alias gowin_programmer="/opt/gowin-eda-programmer/bin/programmer"
alias gowin_ide="/opt/gowin-eda-ide/bin/gw_ide"
alias gowin_jtagserver="/opt/gowin-eda-programmer/bin/jtagserver"

# xreader prints a bunch of critical warnings when clicking inside and outside
# of the xreader window and it is distracting
xreaderf() {
    # Open files with xreader without warnings and errors popping up
    xreader "$@" 2> /dev/null
}

# For i3-restore
export i3_PATH="$HOME/.i3"

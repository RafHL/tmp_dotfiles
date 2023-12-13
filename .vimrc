" This is my attempt at making a vimrc on 7/5/18 2:36 AM using
" gougblack.io/words/a-good-vimrc.html as a guide

let g:python3_host_prog='/usr/bin/python3'
if has("python3")
    let g:gundo_prefer_python3=1
endif
"let g:powerline_pycmd="py3"

call pathogen#infect()    " Use pathogen to load plugins

set nofixendofline

" ---------------------------------------------------------

" UI/FUNCTIONS
" Attempts to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific
filetype indent plugin on

" Allows omni complete to work
filetype plugin on
set omnifunc=syntaxcomplete#Complete

" COLORS
colorscheme badwolf       " I like badwolf and lucius
syntax enable             " Enable syntax coloring

" It hides buffers instead of closing them. This means that you can have unwritten...
"  changes to a file and open a new file using :e, without being forced to write or...
"  undo your changes first. Also, undo buffers and marks are preserved while the buffer is open.
"  -Vincent Driessen in How I boosted my Vim
set hidden

set confirm               " Prompts for save if command used requires it
set visualbell            " Show a visible bell instead of error beep 
set mouse=a               " Allow use of mouse for all modes
set cmdheight=2           " Makes space for messages bigger

set undofile
set undodir=~/.vim/undodir

" UI CONFIG
set number                " Shows line numbers
set showcmd               " Shows last inputted command in bottom bar
filetype indent off       " Loads ~/.vim/indent/<some language>/vim files with indentation files
set wildmenu              " Graphical menu of all autocomplete options
set lazyredraw            " Redraw screen only when needed. Makes macros faster if setted
set showmatch             " Match/Highlight parantheses [{()}]
set ruler                 " Show cursor positiov
set laststatus=2          " Always shows status bar, even with only one window
set textwidth=80          " Width 80, unless next word makes it go past 80
set colorcolumn=+1        " Color bar at column 81
set cursorline            " Highlight the current line
set guioptions-=m         "remove menu bar
set guioptions-=T         "remove toolbar
set guioptions-=r         "remove right-hand scroll bar
set guioptions-=L         "remove left-hand scroll bar

" Make Dejavu default font
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10"

" SEARCHING
set incsearch             " Search as characters are entered
set hlsearch              " Highlight matches
set ignorecase            " Case insensitive searches unless uppercase used
set smartcase

" FOLDING
set foldenable            " Enable folding
set foldlevelstart=10     " Open most folds by default
set foldnestmax=10        " Allows 10 nested folds max
set foldmethod=indent     " fold based on indent level
set breakindent
set breakindentopt=shift:8 " add eight extra spaces to wrapped lines
"set breakindentopt=shift:4 " add four extra spaces to wrapped lines

" CtrlP settings
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

" Spaces & tabs
set tabstop=4             " Visible spaces per tab
set softtabstop=4         " # of spaces for tab while editing
set shiftwidth=4          " Make > indent by 4
set expandtab             " Makes tabs into spaces
set backspace=indent,eol,start " Allows backspace over autoindent linebreaks and start of insert action
set autoindent            " Keeps same indentation on enter if no file specific indenting is enabled

"" Makes trailing spaces and tabs visible. Thanks to guckes.net
set list
set lcs=tab:»·
set lcs+=trail:·
set fillchars+=vert:┃     " Fils vertical separator with a line, not as choppy as before

" MOVEMENT
" move vertically by visual line
nnoremap j gj
nnoremap k gk
" highlight last inserted text
nnoremap gV `[v`]
" Space opens and closes folds
nnoremap <space> za

" LEADER SHORTCUTS
" leader is ;
let mapleader=";"
" Turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>
" jk is escape
inoremap jk <esc>
" Toggle gundo
nnoremap <leader>u :GundoToggle<CR>
" Toggle NERDTree
nnoremap <leader>N :NERDTreeToggle<CR>
" Save session (Super save) to session directory
nnoremap <leader>S :mksession! ~/vim.rafe/sessions/.vim_session<CR>
" Save session locally
nnoremap <leader>s :mksession! ./.vim_session<CR>
" Restore session (Super load)
nnoremap <leader>L :source ~/vim.rafe/sessions/.vim_session<CR>
" Restore session locally
nnoremap <leader>l :source ./.vim_session<CR>
" Edit vimrc and load vimrc bindings
nnoremap <leader>ev :tabedit ~/.vimrc<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
" Open ag.vim
nnoremap <leader>a :Ack
" " Use colorscheme lucius
" " Use colorscheme badwolf
" nnoremap <leader>cb :colorscheme badwolf<CR>
" " Use colorscheme meta5
" " Use colorscheme gruvbox
" " Use colorscheme happy_hacking
" " Use colorscheme iceberg
" " Use colorscheme lightning
" " Use colorscheme summerfruit GUI ONLY
" nnoremap <leader>cf :colorscheme summerfruit<CR>
" " Use colorscheme colokschi-light
" nnoremap <leader>ccl :colorscheme colokschi-light<CR>
" " Use colorscheme colokschi dark
" nnoremap <leader>ccd :colorscheme colokschi-dark<CR>
" Copy all text by pressing \y, aka super-yank
nnoremap <leader>y gg V G y<CR>
" Highlight all text by pressing \h
nnoremap <leader>h gg V G<CR>
" Go to next buffer using leader n
nnoremap <leader>n :bn<CR>
" Go to previous buffer using leader p
nnoremap <leader>p :bp<CR>
" Delete buffer using leader d
nnoremap <leader>d :bd<CR>
" Make all buffers into tabs
nnoremap <leader>t :tab ball<CR>
" Copy line
nnoremap <leader>c "+yy
nnoremap <leader>C "+y
" FIXME I suggest adding a function leader m that turns j and k into gjzz adn gkzz to keep
" cursor in the middle of the screen
nnoremap <leader>m :call Mid()<CR>
nnoremap <leader>M :call Midu()<CR>
function Mid()
    nunmap j
    nunmap k
    nnoremap j gjzz
    nnoremap k gkzz
endfunction
function Midu()
    nunmap j
    nunmap k
    nnoremap j gj
    nnoremap k gk
endfunction

" Thanks to Christopher Bottoms
" Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
" Advance to previous tab using gb as well as gT
nnoremap gb gT
nnoremap <leader><space> :nohlsearch<CR>
" Map ctrl | to omni function
inoremap <C-;> <C-x><C-o>
" Map ctrl \ to local completion
inoremap <C-'> <C-x><C-p>
" Automatic indentation and matching (
inoremap (<CR> (<CR>)<C-o>O<Tab>
" Automatic indentation and matching {
inoremap {<CR> {<CR>}<C-o>O<Tab>
" Automatic indentation and matching [
inoremap [<CR> [<CR>]<C-o>O<Tab>
" ---------------------------------------------------------

" For status line:
"set rtp+=/home/rafe/Downloads/powerline/powerline/bindings/vim


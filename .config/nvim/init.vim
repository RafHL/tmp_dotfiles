set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
"let g:python3_host_prog='/usr/bin/python3'

source ~/.vimrc

nnoremap <leader>eV :tabedit $MYVIMRC<CR>


set nocompatible
set encoding=utf-8
set cursorline
set colorcolumn=76
set nowrap

set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set smarttab

autocmd BufWritePre * :%s/\s\+$//e
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endi
	
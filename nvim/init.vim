
set autoindent shiftwidth=2 softtabstop=2 tabstop=2 expandtab
set backspace=indent,eol,start
set colorcolumn=76
set cursorline
set foldenable
set foldmethod=syntax
set foldlevel=9 " make it really high, so they're not displayed by default
set ignorecase
set list listchars=tab:»·,trail:·
set nowrap
set number
setlocal numberwidth=3
set scrolloff=8
set showmatch
set smarttab
set wildmode=longest,list

syntax on

nnoremap Y y$
" ^ Yank from the cursor to the end of the line, to be consistent with C and D.
inoremap <leader>d <C-R>=strftime("%y-%m-%d %H:%M")<CR>
" ^ shortcut to insert timestamps

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endi

augroup myfiletypes
  autocmd!
  " ^ Clear old autocmds in group
  autocmd FileType yaml set autoindent shiftwidth=2 softtabstop=2 tabstop=2 expandtab
  autocmd FileType python set autoindent shiftwidth=4 softtabstop=4 expandtab textwidth=80
  autocmd FileType matlab set autoindent shiftwidth=4 softtabstop=4 expandtab textwidth=80
  autocmd FileType c,cpp set autoindent shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType javascript,html,css set autoindent shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType vim set autoindent tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  " add for LaTeX files
  au BufRead,BufNewFile *etc/nginx/* set ft=nginx
  autocmd FileType markdown set autoindent shiftwidth=2 softtabstop=2 tabstop=2 expandtab
  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END


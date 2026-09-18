"<ctrl-/><ctrl-n> to change to normal mode in terminal
"Configs
let GITROOT = system("git rev-parse --show-toplevel")

set textwidth=80
set expandtab
set foldmethod=indent
set autochdir
set noswapfile
set splitbelow
map <Up> <NOP>
map <Down> <NOP>
map <Left> <NOP>
map <Right> <NOP>
imap <Up> <NOP>
imap <Down> <NOP>
imap <Left> <NOP>
imap <Right> <NOP>
set relativenumber
set number

"Tags
function! UpdateCtags()
    let l:root = substitute(system("git rev-parse --show-toplevel"), '\n', '', 'g')
    if v:shell_error == 0
        silent! execute "!ctags -f " . shellescape(l:root . "/tags") . " --recurse=yes " . shellescape(l:root)
    endif
endfunction

autocmd BufWritePost *.c,*.h,*.go,*.py call UpdateCtags()
set tags=./tags;

set noundofile

"Colors
"set background=dark
set t_Co=256

"Deal with mac backspace problem.
set backspace=2
set backspace=indent,eol,start

"Cursors
highlight Folded ctermbg=2
highlight TabLine ctermbg=2

"set cursorline
highlight CursorLine ctermbg=23 cterm=NONE

"Filetypes
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType python setlocal shiftwidth=4 tabstop=4
autocmd FileType c setlocal shiftwidth=4 tabstop=4 noexpandtab
autocmd FileType go setlocal shiftwidth=4 tabstop=4 noexpandtab
autocmd FileType asm setlocal syntax=gas
autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2
autocmd FileType rkt setlocal shiftwidth=4 tabstop=4
autocmd FileType snippets setlocal shiftwidth=4 tabstop=4
autocmd FileType rst setlocal shiftwidth=4 tabstop=4 noexpandtab
autocmd FileType text setlocal shiftwidth=4 tabstop=4 wrapmargin=0 formatoptions+=t noexpandtab wrap linebreak nolist
autocmd FileType sh setlocal shiftwidth=8 tabstop=8 noexpandtab


"Leaders and vimrc commands
let mapleader=","
if has('win32')
        set runtimepath^=$WINVIM
        nnoremap <Leader>ev :tabedit $WINRC<cr>
        nnoremap <Leader>sv :source $WINRC<cr>
else
        nnoremap <Leader>ev :tabedit $MYVIMRC<cr>
        nnoremap <Leader>sv :source $MYVIMRC<cr>
endif

nnoremap <Leader>rtcl :term tclsh %<cr>
nnoremap <Leader>rp :term python %<cr>
nnoremap <Leader>rtp :term pytest %<cr>
nnoremap <Leader>rip :term ipython -i %<cr>
nnoremap <Leader>rg :term go run %<cr>
nnoremap <Leader>drg :call GoDebug()<cr>
nnoremap <Leader>rjs :term node %<cr>
nnoremap <Leader>rc :call CScratch()<cr>
nnoremap <Leader>rvc :call VCScratch()<cr>
nnoremap <Leader>rs :term scheme --quiet --load %<cr><c-d>
nnoremap <Leader>am :call ApueMake()<cr><c-d>
nnoremap <Leader>cm :call CMake()<cr><c-d>
nnoremap <Leader>vcm :call VCMake()<cr><c-d>
nnoremap <Leader>gr :cd `=GITROOT`<cr>:e
nnoremap <Leader>grt :cd `=GITROOT`<cr>:tabedit
nnoremap <Leader>grh :cd `=GITROOT`<cr>:sp
nnoremap <Leader>grv :cd `=GITROOT`<cr>:vs
nnoremap <Leader>nc :call NCurses()<cr><c-d>

"Close parens, etc
inoremap (<tab> ()<Left>
inoremap {<tab> {}<Left>
inoremap [<tab> []<Left>
inoremap '<tab> ''<Left>
inoremap "<tab> ""<Left>
inoremap {<CR> {<CR>}<C-o>O
inoremap (<CR> (<CR>)<C-o>O
inoremap [<CR> [<CR>]<C-o>O
inoremap '<CR> '<CR>'<C-o>O
inoremap "<CR> "<CR>"<C-o>O

if has('win32')
        call plug#begin('$HOME\OneDrive - Whole Foods Market\Documents\vim\plugged')
else
        call plug#begin('~/.vim/plugged')
endif

Plug 'kien/rainbow_parentheses.vim'

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

"Plug 'luochen1990/rainbow'
"let g:rainbow_active = 1

Plug 'tpope/vim-surround'
Plug 'kien/ctrlp.vim'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
Plug 'christoomey/vim-tmux-navigator'
Plug 'Shirk/vim-gas'
Plug 'nonetallt/vim-neon-dark', { 'tag': '2.1.0' }

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 0
let g:airline_theme='simple'

call plug#end()
set guioptions-=e  "make tabs look like the ones in the console."
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

fun! ApueMake()
        term bash -c "make -f ../Makefile vimmake ERROR=../error.o SOURCE=%:p && ./a.out"
endfun

fun! CMake()
        term bash -c "make && ./a.out"
endfun

fun! VCMake()
        term bash -c "make && valgrind ./a.out"
endfun

fun! CScratch()
        term bash -c "gcc -Wall -g -o a.out % && ./a.out"
endfun

fun! VCScratch()
        term bash -c "gcc -Wall -g -o a.out % && valgrind ./a.out"
endfun

fun! GoDebug()
        term bash -c "go build -gcflags=all='-N -l'"
endfun

fun! NCurses()
        term bash -c "gcc -Wall -g % -o a.out -lncurses && ./a.out"
endfun

colorscheme neon-dark

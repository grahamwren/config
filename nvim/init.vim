set nocompatible
syntax on
filetype on
filetype indent on
filetype plugin on
set tabstop=2
set shiftwidth=2
set list
set omnifunc=syntaxcomplete#Complete

" numbers
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

set clipboard^=unnamed
set expandtab
set showmatch
set nohlsearch
set undofile " persist undo through save
set undodir=~/config/nvim/undodir

" semi-colon as mod key
let mapleader = ";"

" inserting blank lines
nmap [<space> O<esc>
nmap ]<space> o<esc>

" Terminal
autocmd TermOpen * set bufhidden=hide

au FileType ruby set isk+=?,!

" NERDTree
map <leader>t :NERDTreeToggle<CR>
map <leader>n :NERDTreeFind<CR>

" Map leader w to switch pane
map <leader>w <C-w>

" Prevent vim from moving cursor after returning to normal mode
imap <esc> <esc>l

"Autocenter file jumps
nmap G Gzz
nmap * *zz
nmap # #zz
nmap <C-o> <C-o>zz
nmap <C-i> <C-i>zz

" select-all
nmap <leader>a gg<S-v>G<CR>

" autoformat then save with <leader>s
nmap <leader>s :FormatCode<CR>:w<CR>

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" Press Enter to toggle highlighting for the word current under the cursor
let g:highlighting = 0
function! Highlighting()
  if g:highlighting == 1 && @/ =~ '^\\<'.expand('<cword>').'\\>$'
    let g:highlighting = 0
    return ":silent nohlsearch\<CR>"
  endif
  let @/ = '\<'.expand('<cword>').'\>'
  let g:highlighting = 1
  return ":silent set hlsearch\<CR>"
endfunction
nnoremap <silent> <expr> <CR> Highlighting()

" --- FZF ---
"
map <leader>f :ProjectFiles<CR>
map <leader>g :GFiles<CR>
map <leader>b :Buffers<CR>
map <leader>r :rviminfo!<CR>
map <leader>m :History<CR>
map <leader>; :History:<CR>
nmap <leader>t <Plug>(fzf_tags)
nnoremap <leader>T :BTags<CR>

command! FZFMru call fzf#run(fzf#wrap(
      \ {
      \  'source':  v:oldfiles,
      \  'options': '--multi -x +s',
      \  'down':    '40%'
      \ }
      \))

" --- vim-markdown --
"
let g:markdown_enable_spell_checking = 0

" --- vim-airline-clock --
"
let g:airline#extensions#clock#format = '%H:%M:%S'
let g:airline#extensions#clock#updatetime = 200

call plug#begin('~/.local/share/nvim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'gabrielelana/vim-markdown'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'
Plug 'google/vim-maktaba'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/vim-easy-align'
Plug 'mustache/vim-mustache-handlebars'
Plug 'pest-parser/pest.vim'
Plug 'preservim/nerdtree'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'enricobacis/vim-airline-clock'
Plug 'wizicer/vim-jison'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'zackhsi/fzf-tags'
Plug 'scrooloose/vim-slumlord'
Plug 'aklt/plantuml-syntax'
Plug 'majutsushi/tagbar'
Plug 'thoughtbot/vim-rspec'

call plug#end()

" --- custom filetypes ---
"
autocmd BufNewFile,BufRead *.h.mustache set filetype=cpp.mustache
autocmd BufNewFile,BufRead *.uml.txt set filetype=plantuml

" --- Codefmt ---
"
augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
  autocmd FileType c,cpp,proto AutoFormatBuffer clang-format
  autocmd FileType javascript,typescript,json AutoFormatBuffer prettier
  autocmd FileType dart AutoFormatBuffer dartfmt
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType gn AutoFormatBuffer gn
  autocmd FileType html,css,sass,scss,less AutoFormatBuffer js-beautify
  autocmd FileType java AutoFormatBuffer google-java-format
  autocmd FileType python AutoFormatBuffer yapf
  " Alternative: autocmd FileType python AutoFormatBuffer autopep8
  autocmd FileType ruby AutoFormatBuffer rubocop
  autocmd FileType rust AutoFormatBuffer rustfmt
  autocmd FileType vue AutoFormatBuffer prettier
augroup END

" Add helloworld to the runtime path. (Normally this would be done with another
" Plugin command, but helloworld doesn't have a repository of its own.)
call maktaba#plugin#Install(maktaba#path#Join([maktaba#Maktaba().location,
    \ 'examples', 'helloworld']))

call glaive#Install()

Glaive codefmt prettier_options=`['--single-quote', '--trailing-comma=all', '--arrow-parens=avoid', '--print-width=80']`

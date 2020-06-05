# fzf setup

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" --exclude "node_modules" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" --exclude "node_modules" . "$1"
}

## fe [FUZZY PATTERN] - Open the selected file with the default editor
##   - Bypass fuzzy finder if there's only one match (--select-1)
##   - Exit if there's no match (--exit-0)
#fe() {
#  local files
#  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
#  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
#}
#
## Modified version where you can press
##   - CTRL-O to open with `open` command,
##   - CTRL-E or Enter key to open with the $EDITOR
#fo() {
#  local out file key
#  IFS=$'\n' out=("$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e --preview 'cat {}')")
#  key=$(head -1 <<< "$out")
#  file=$(head -2 <<< "$out" | tail -1)
#  if [ -n "$file" ]; then
#    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
#  fi
#}

fo () {
  files=$(fzf-tmux --query="$@" --multi --select-1 --exit-0 --height 50% --preview 'cat {}')
  [[ -n "$files" ]] && echo "$files" | xargs ${EDITOR:-"nvim"}
}

## using ripgrep combined with preview
## find-in-file - usage: fif <searchTerm>
#fif() {
#  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
#  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
#}

# alternative using ripgrep-all (rga) combined with fzf-tmux preview
# implementation below makes use of "open" on macOS, which can be replaced by other commands if needed.
# allows to search in PDFs, E-Books, Office documents, zip, tar.gz, etc. (see https://github.com/phiresky/ripgrep-all)
# find-in-file - usage: fif <searchTerm> or fif "string with spaces" or fif "regex"
fif() {
    if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
    local file
    file="$(rga --max-count=1 --ignore-case --files-with-matches --no-messages "$@" | fzf-tmux +m --preview="rga --ignore-case --pretty --context 10 '"$@"' {}")" && $EDITOR "$file"
}

# fh - repeat history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | `_get_sed` -r 's/ *[0-9]*\*? *//' | `_get_sed` -r 's/\\/\\\\/g')
}


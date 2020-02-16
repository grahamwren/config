export _NOTEBOOK_DIR="$HOME/Documents/Notebook"
export _DEFAULT_NOTES="$_NOTEBOOK_DIR/default"
export _PSYCH_NOTES="$_NOTEBOOK_DIR/psyc1101"
export _SOFTWARE_DEV_NOTES="$_NOTEBOOK_DIR/cs4500"

alias edit_notebook_utils="$EDITOR $ZSH_CONFIG_DIR/notebook.sh && source $ZSH_CONFIG_DIR/notebook.sh"

export _NOTE_MODE="default"
notes_psy () {
  export _NOTE_MODE="psych"
  mkdir $(_note_dir) 2>/dev/null
  return 0;
}

notes_cs () {
  export _NOTE_MODE="cs"
  mkdir $(_note_dir) 2>/dev/null
  return 0;
}

notes_reset () {
  export _NOTE_MODE="default"
  mkdir $(_note_dir) 2>/dev/null
  return 0;
}

_note_dir () {
  case "$_NOTE_MODE" in
    (psych) echo $_PSYCH_NOTES;;
    (cs) echo $_SOFTWARE_DEV_NOTES;;
    (default | *) echo $_DEFAULT_NOTES;;
  esac
}

notes_commit () {
  cd $_NOTEBOOK_DIR
  command git add -A
  command git pull
  command git commit -m "notes: `dash_timestamp` (auto-commit)"
  check_github_conn && command git push origin $(current_branch)
  cd -
}

header_date () {
  date "+DATE: %Y-%m-%d, TIME: %H:%M:%S %Z"
}

note_quick () {
  nvim "+normal G$" "+read !echo \"\n\n$(header_date)\n\n\# \"" +'startinsert!' $_DEFAULT_NOTES/quick_notes.md
}
alias nq=note_quick

note_new () {
  nvim "+read !echo \"$(header_date)\n\n\# \"" '+normal Gdd$' +'startinsert!' $(_note_dir)/note-$(dash_timestamp).md
}
alias nn=note_new

_last_note_file () {
  echo $(_note_dir)/* | tr " " "\n" | rg -v "quick_note|log" | sort | tail -n1
}

note_last () {
  local file=$(_last_note_file)
  nvim "+normal G$" +startinsert! $file
}
alias nl=note_last

log_note () {
  local file="$(_note_dir)/pwren-log.md"
  touch $file
  nvim "+0read !echo \"date/time: $(header_date)\nplace:\ngoal:\nnotes:\n\nduration:\nnext:\n\n\"" '+normal ggj' +startinsert! $file
}

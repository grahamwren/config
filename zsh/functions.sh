find_and_replace () {
  local pattern=$1
  local replace=$2
  local usages=$(rg $pattern -l)
  local sed_command
  if echo "$pattern$replace" | rg -q "/"; then
    sed_command=$(cat << COMMAND
s#$pattern#$replace#g
COMMAND
)
  else
    sed_command=$(cat << COMMAND
s/$pattern/$replace/g
COMMAND
)
  fi
  echo $usages | parallel `_get_sed` -E -i "$sed_command"
}

mkatom () {
  set -o noclobber
  { > $1; } &>/dev/null
}

current_repo () {
  local url=$(git remote get-url origin)
  echo "$url" |
    awk -F':' '{ print $2 }' |
    awk -F'.' '{ print $1 }'
}

_get_open () {
  if command -v open; then
    echo "open"
  else
    echo "xdg-open"
  fi
}

_get_sed () {
  if command -v gsed; then
    echo "gsed"
  else
    echo "sed"
  fi
}

show_added_modified_files () {
  local ref=${1:-HEAD}
  git diff --name-status $ref | awk '/A|M\s+.*/{ print $2 }'
}

show_added_modified_specs () {
  show_added_modified_files $@ | rg "^spec.*spec.rb$"
}

open_jira () {
  # if in a git repo
  if git rev-parse --git-dir >/dev/null; then
    local ticket=$(echo "$(current_branch)" | rg --color=never "^([A-Z]+-\d+)(.*$)" -r '$1')

    # if we were able to match a ticket from the branch name
    if [ -n "$ticket" ]; then
      `_get_open` "https://procoretech.atlassian.net/browse/$ticket"
    else
      command cat << HELP
Failed: unable to detect ticket in branch name
Please name your branch with the ticket number at the beginning.
e.g. SW-55-some-feature, SW-55/some-feature
HELP
      return 1
    fi
  fi
}

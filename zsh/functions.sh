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
  if [[ -z "$url" ]]; then
    return 1
  fi

  if [[ "$url" =~ '^http' ]]; then
    echo "$url" |
      awk -F'/' '{ print $4 "/" $5 }' |
      awk -F'.' '{ print $1 }'
  else
    echo "$url" |
      awk -F':' '{ print $2 }' |
      awk -F'.' '{ print $1 }'
  fi
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

jira_url () {
  # if in a git repo
  if git rev-parse --git-dir >/dev/null; then
    local ticket=$(echo "$(current_branch)" | rg --color=never "^([A-Z]+-\d+)(.*$)" -r '$1')

    # if we were able to match a ticket from the branch name
    if [ -n "$ticket" ]; then
      echo "https://procoretech.atlassian.net/browse/$ticket"
    else
      command cat >/dev/stderr << HELP
Failed: unable to detect ticket in branch name
Please name your branch with the ticket number at the beginning.
e.g. SW-55-some-feature, SW-55/some-feature
HELP
      return 1
    fi
  fi
}
alias open_jira="__JIRA_URL=\"\$(jira_url)\" && `_get_open` \"\${__JIRA_URL}\""

pr_template () {
  local template=""

  local ticket_url=`jira_url`
  if [ -n "$ticket_url" ]; then
    template+="$ticket_url\n\n"
  fi

  template+="# Description\n\n"

  IFS=$'\n'
  for commit in `command git log master...HEAD --format='%h******%s'`; do
    local hash=$(echo "$commit" | rg '^(.*?)\*\*\*\*\*\*(.*)$' -r '$1')
    local subject=$(echo "$commit" | rg '^(.*?)\*\*\*\*\*\*(.*)$' -r '$2')
    local commit_url="https://github.com/$(current_repo)/commit/$hash"
    template+="* [\`$hash\`]($commit_url) $subject\n"
  done
  template+="\n"

  local changed_files=`diff-tree`
  if [ -n "$changed_files" ]; then
    template+="<details><summary>Files</summary>\n\n"
    template+='```txt\n'
    template+="$changed_files\n"
    template+='```\n\n'
    template+="</details>\n\n"
  fi

  template+="# Testing Notes\n\n"
  template+="- [ ] _coming soon_"

  # TODO: add defer migrations heading and check-boxes

  echo "$template"
}

nspec () {
  local runner=${SPEC_RUNNER:-rspec}
  local n=$1
  local specs=${@:2}
  if [[ "$n" =~ '^[[:digit:]]+$' && -n "$specs" ]]; then
    for i in $(seq "$n"); do
      eval ${runner} ${specs}

      if [[ ! $? = 0 ]]; then
        break
      fi
    done
  else
    command cat >/dev/stderr << HELP
$ nspec <n> <spec arguments>

nspec will run your spec runner with the given arguments <n> times. This is
meant for detecting intermittent specs. By default 'rspec' is used for the spec
runner, to use an alternative test program set the SPEC_RUNNER environment
variable. As soon as the spec runner returns a non-zero exit code, nspec will
stop running the specs.

Examples:
  $ nspec 10 --seed=1234 spec/controller/application_controller_spec.rb
  $ SPEC_RUNNER=jest nspec 5 src/__tests__/reducer_test.js
HELP
    return 1
  fi
}

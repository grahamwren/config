find_and_replace () {
	local pattern=$1
	local replace=$2
	local usages=$(rg $pattern -l)
  local gsed_command
  if echo "$pattern$replace" | rg -q "/"; then
    gsed_command=$(cat << COMMAND
s#$pattern#$replace#g
COMMAND
)
  else
    gsed_command=$(cat << COMMAND
s/$pattern/$replace/g
COMMAND
)
  fi
	echo $usages | xargs -t gsed -E -i "$gsed_command"
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

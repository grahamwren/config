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

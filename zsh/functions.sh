find_and_replace () {
	local pattern=$1
	local replace=$2
	usages=$(rg $pattern -l)
	echo $usages | xargs -t gsed -E -i "s/$pattern/$replace/g"
}

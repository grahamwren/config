# Functions
check_github_conn () {
  curl https://www.github.com --head &>/dev/null
}


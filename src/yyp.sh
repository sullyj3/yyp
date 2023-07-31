#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail

script_name=$(basename "$0")

usage () {
  echo "Usage:"
  echo "  $script_name yank <file to yank>"
  echo "  $script_name put [flags]"
  echo
  echo "By default, -i will be passed to cp to prevent accidentally"
  echo "overwriting files."
  echo "If the file to be copied is a directory, -r will be used."
  echo "Any flags passed to \`put\` will be passed to cp after -i and -r."
  echo
  echo "It is recommended to alias \`yyp yank\` to \`yy\` and \`yyp put\` to \`p\`"
  exit 1
}

XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
data_dir="$XDG_DATA_HOME/yyp"

yank () {
  # ensure file to yank is provided
  if [ "$#" -ne 1 ]; then
    usage
  fi

  file_to_yank=$(realpath "$1")
  # ensure file exists
  if [ ! -e "$file_to_yank" ]; then
    echo "$file_to_yank does not exist"
    exit 1
  fi

  # ensure data dir exists
  mkdir -p "$data_dir"

  # store file path in yyp.txt
  echo "$file_to_yank" >> "$data_dir/yyp.txt"
  echo "Yanked $file_to_yank"
}

no_yanked_files () {
  echo "No yanked files"
  exit 1
}

put () {
  # ensure yyp.txt exists
  if [ ! -f "$data_dir/yyp.txt" ]; then
    no_yanked_files
  fi

  # get last yanked file
  last_yanked=$(tail -n 1 "$data_dir/yyp.txt")
  if [ -z "$last_yanked" ]; then
    no_yanked_files
  fi

  # ensure file still exists
  if [ ! -e "$last_yanked" ]; then
    echo "File $last_yanked is no longer available"
    exit 1
  fi

  # determine what flags to pass to cp
  # provide -i by default
  cp_flags="-i"
  # if the file to be copied is a directory, use -r
  if [ -d "$last_yanked" ]; then
    cp_flags="$cp_flags -r"
  fi
  # pass additional flags if provided
  if [ "$#" -ne 0 ]; then
    cp_flags="$cp_flags $*"
  fi

  echo "cp $cp_flags $last_yanked ."
  cp $cp_flags "$last_yanked" .
}

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  usage
fi

subcommand="$1"
shift

case "$subcommand" in
  yank)
    yank "$@"
    ;;
  put)
    put "$@"
    ;;
  *)
    usage
    ;;
esac

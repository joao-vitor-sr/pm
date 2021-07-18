#!/bin/sh

sread() {
  printf '%s: ' "$2"

  read -r "$1"

  printf '\n'
}


yn() {
  printf '%s [y/n]: ' "$1"

    # Enable raw input to allow for a single byte to be read from
    # stdin without needing to wait for the user to press Return.
    stty -icanon

    # Read a single byte from stdin using 'dd'. POSIX 'read' has
    # no support for single/'N' byte based input from the user.
    answer=$(dd ibs=1 count=1 2>/dev/null)

    # Disable raw input, leaving the terminal how we *should*
    # have found it.
    stty icanon

    printf '\n'

    # Handle the answer here directly, enabling this function's
    # return status to be used in place of checking for '[yY]'
    # throughout this program.
    glob "$answer" '[yY]'
  }

glob() {
  # This is a simple wrapper around a case statement to allow
  # for simple string comparisons against globs.
  #
  # Example: if glob "Hello World" '* World'; then
  #
  # Disable this warning as it is the intended behavior.
  # shellcheck disable=2254
  case $1 in $2) return 0; esac; return 1
  }

usage() {
  printf %s "\
    PM 1.0.0 - Project Manager.

  =>  add [name]   - Create a new project.
  =>  del [name]   - Delete a project
  =>  start [name] - Start a project.
  =>  stop [name]  - Stop a project.
  =>  list        - List all projects.
  "
  exit 0
}

add_project() {
  name=$1
  nameOfFile="$1.project"

  # validating if the project already exist (if exist will update instead add a new)
  if test -f "$nameOfFile"; then
    echo "the $name already exist."
  else

    stillAsking=true
    :>"$nameOfFile"

    while [ "$stillAsking" = true ]
    do
      sread commandToStart "Enter the command to start the project"

      echo "$commandToStart" >> "$nameOfFile"

      if yn "You want add more one command?"; then
        continue
      else
        stillAsking=false
        break
      fi
    done
  fi
}

list_projects() {
  find . -type f -name \*.project | sed 's/..//;s/\.project$//'
}

remove_project() {
  name=$1
  nameOfFile="$1.project"

  if test -f "$nameOfFile"; then
    rm -rf "$nameOfFile"
  else
    printf '%s\n' "The project '$name' Don't exist"
  fi
}

start_project() {
  name=$1
  nameOfFile="$1.project"

  if test -f "$nameOfFile"; then
    while IFS= read -r line || [ -n "$line" ]; do
      printf '%s\n' "$line"
    done < "$nameOfFile"
  else
    printf '%s' "This project don't exist"
  fi
}

stop_project() {
  name=$1
  printf '%s\n' "stoping the project '$name'"
}

main() {
  : "${PM_DIR:=${XDG_DATA_HOME:=$HOME/.local/share}/pm}"

  cd "$PM_DIR"

  case $1 in
    add*) add_project "$2" ;;
    del*) remove_project "$2" ;;
    start*) start_project "$2" ;;
    stop*) stop_project "$2" ;;
    list*) list_projects "$2" ;;
    *) usage
  esac
}

[ "$1" ] || usage && main "$@"

#!/bin/sh

sread() {
  printf '%s: ' "$2"

  read -r "$1"

  printf '\n'
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
    touch "$nameOfFile"

    stillAsking=true
    while [ "$stillAsking" = true ]
    do
      sread commandToStart "Enter the command to start the project"

      printf '%s' "The command is $commandToStart"

      stillAsking=false
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
  printf '%s\n' "Starting the project '$name'"
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

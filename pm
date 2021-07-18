#!/bin/sh

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
  printf '%s\n' "The project was '$name' added."

  # validating if the project alreayd exist (if exist will update instead add a new)
}

list_projects() {
  find . -type f -name \*.project | sed 's/..//;s/\.project$//'
}

remove_project() {
  name=$1
  printf '%s\n' "The project '$name' was removed"
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

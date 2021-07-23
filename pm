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

  =>  add [name]    - Add a new command in a project
  =>  remove [name] - Remove a command in a project
  =>  create [name] - Create a a new project
  =>  del [name]    - Delete a project
  =>  start [name]  - Start a project.
  =>  stop [name]   - Stop a project.
  =>  list          - List all projects.
  =>  desc [name]   - Describe a project.
  "
  exit 0
}

# === CREATE PROJECT ===
create_project() {
  name=$1
  nameOfFile="$1.project"
  nameOfFileStart="$1.project.start"
  nameOfFileStop="$1.project.stop"

  if test -z "$name"; then
    printf '%s' "The name of the project can't be null"
    exit 0
  fi

  if test -f "$nameOfFile"; then
    printf '%s' "the '$name' project already exist."
    exit 0
  fi

  :>"$nameOfFile"
  :>"$nameOfFileStart"
  :>"$nameOfFileStop"

  printf '%s' "Congratulations the '$name' project was created"
}

# === REMOVE COMMAND ===
remove_command() {
  name=$1
  nameOfFile="$1.project"
  nameOfFileStop="$1.project.stop"
  nameOfFileStart="$1.project.start"

  describe_project "$1"

  if test -z "$name"; then
    printf '%s' "The name of the project can't be null"
    exit 0
  fi

  if ! test -f "$nameOfFile"; then
    printf '%s' "This project does not exist"
    exit 0
  fi

  optionToRemove=""
  sread optionToRemove "Enter the option than you want remove [stop, start, desc]"

  case $optionToRemove in
    stop)
      numberOfLine=""
      sread numberOfLine "Enter the number of line than you want remove"
      sed -i "$numberOfLine d" "$nameOfFileStop"

      printf '%s' "Congratulations the line was removed"

      exit 0
      ;;
    start)
      numberOfLine=""
      sread numberOfLine "Enter the number of line than you want remove"
      sed -i "$numberOfLine d" "$nameOfFileStart"

      printf '%s' "Congratulations the line was removed"
      exit 0
      ;;
    desc)
      echo "" > "$nameOfFile"

      printf '%s' "Congratulations the was removed"

      return 0;
      ;;
    *)
      printf '%s' "This option don't exist"
      exit 0
  esac
}

# === ADD COMMAND ===
add_command() {
  name=$1
  nameOfFile="$1.project"
  nameOfFileStart="$1.project.start"
  nameOfFileStop="$1.project.stop"


  if test -z "$name"; then
    printf '%s' "The name of the project can't be null"
    exit 0
  fi

  if ! test -f "$nameOfFile"; then
    printf '%s' "This project does not exist"
    exit 0
  fi

  optionToAdd=""
  sread optionToAdd "Enter the option than you want add [stop, start,
  description-force, description] use only description for add more lines at
  description use description-force to overwrite"


  case $optionToAdd in
    start*)
      commandToStart=""
      sread commandToStart "Enter the command to start"

      echo "$commandToStart" >> "$nameOfFileStart"
      exit 0;
      ;;
    stop*)
      commandToStop=""
      sread commandToStop "Enter the command to stop"

      echo "$commandToStop" >> "$nameOfFileStop"
      exit 0;
      ;;

    description)
      newLineOfDescription=""
      sread newLineOfDescription "Enter the new line for the description"

      echo "$newLineOfDescription"

      echo "$newLineOfDescription" >> "$nameOfFile"
      exit 0;
      ;;

    description-force)
      newDescription=""
      sread newDescription "Enter the new description"

      echo "$newDescription" > "$nameOfFile"
      exit 0;
      ;;
    *) printf '%s' "This option does not exist" exit 0
  esac
}

# === LIST PROJECTS ===
list_projects() {
  find . -type f -name \*.project | sed 's/..//;s/\.project$//'
}

# === DELETE PROJECT ===
delete_project () {
  name=$1
  nameOfFile="$1.project"
  nameOfFileStart="$1.project.start"
  nameOfFileStop="$1.project.stop"

  if test -f "$nameOfFile"; then
    rm -rf "$nameOfFile"
    rm -rf "$nameOfFileStart"
    rm -rf "$nameOfFileStop"
  else
    printf '%s\n' "The project '$name' Don't exist"
  fi
}

# === START PROJECT ===
start_project() {
  name=$1
  nameOfFile="$1.project.start"

  if test -f "$nameOfFile"; then
    while IFS= read -r line || [ -n "$line" ]; do
      $line
    done < "$nameOfFile"
  else
    printf '%s' "This project don't exist"
  fi
}

# === STOP PROJECT ===
stop_project() {
  name=$1
  nameOfFile="$1.project.stop"

  if test -f "$nameOfFile"; then
    while IFS= read -r line || [ -n "$line" ]; do
      $line
    done < "$nameOfFile"
  else
    printf '%s' "This project don't exist"
  fi
}

# === DESCRIBE PROJECT === 
describe_project() {
  name=$1
  nameOfFile="$1.project"
  nameOfFileStop="$1.project.stop"
  nameOfFileStart="$1.project.start"

  if test -f "$nameOfFile"; then
    printf '%s \n' "Description:"
    while IFS= read -r line || [ -n "$line" ]; do
      printf '%s\n' "$line"
    done < "$nameOfFile"

    printf '\n%s' "Commands to start the project:"

    numberOfLine=1;
    while IFS= read -r line || [ -n "$line" ]; do
      printf '\n %s' "[$numberOfLine] $line"
      numberOfLine=$((numberOfLine+1))
    done < "$nameOfFileStart"

    printf '\n\n%s' "Commands to stop the project:"
    numberOfLine=1;
    while IFS= read -r line || [ -n "$line" ]; do
      printf '\n %s' "[$numberOfLine] $line"
      numberOfLine=$((numberOfLine+1))
    done < "$nameOfFileStop"

  else
    printf '%s' "This project don't exist"
  fi
}

# === MAIN === 
main() {
  : "${PM_DIR:=${XDG_DATA_HOME:=$HOME/.local/share}/pm}"

  cd "$PM_DIR" || exit || return;

  case $1 in
    add*) add_command "$2" ;;
    remove*) remove_command "$2" ;;
    create*) create_project "$2" ;;
    del*) delete_project "$2" ;;
    start*) start_project "$2" ;;
    stop*) stop_project "$2" ;;
    list*) list_projects "$2" ;;
    desc*) describe_project "$2" ;;
    *) usage
  esac
}

[ "$1" ] || usage && main "$@"

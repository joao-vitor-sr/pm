# PM
A simple command line Project Management written in POSIX

PM is a command-line Project Management
PM can manager multiple projects
start and stop projects

The overall purpose of PM is to be a powerful and simple Project Management

## Installation

- Download the latest release.
  - [https://github.com/joao-vitor-sr/pm](https://github.com/joao-vitor-sr/pm)
- Run make install inside the script directory to install the script.
  - MacOS: make PREFIX=/usr/local install
  - Haiku: make PREFIX=/boot/home/config/non-packaged install
  - OpenIndiana: gmake install
  - MinGW/MSys: make -i install
  - NOTE: You may have to run this as root.

## Usage

```
SYNOPSIS

PM 1.0.3 - Project Manager.

=>  add [name]    - Add a new command in a project
=>  remove [name] - Remove a command in a project
=>  create [name] - Create a a new project
=>  del [name]    - Delete a project
=>  start [name]  - Start a project.
=>  stop [name]   - Stop a project.
=>  list          - List all projects.
=>  desc [name]   - Describe a project.

```

### Examples
To create a project you can use the next command
```
pm create <name_of_project>
```
for add commands use this command
```
pm add <name_of_project>
```

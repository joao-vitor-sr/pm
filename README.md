# PM
A simple Projects Manager written in POSIX ```sh```

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
pm add <name_of_project>
```

so will start a short quiz with what commands than you want to add
```
Type a description for the project: monkey

Enter the command to start the project: docker ps

Now enter the command to stop the project: docker ps

You want add more commands? [y/n]: n
```
you can add multiples commands to start and to stop the project

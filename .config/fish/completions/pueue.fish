complete -c pueue -n "__fish_use_subcommand" -s c -l config -d 'Path to a specific pueue config file to use. This ignores all other config files' -r
complete -c pueue -n "__fish_use_subcommand" -s v -l verbose -d 'Verbose mode (-v, -vv, -vvv)'
complete -c pueue -n "__fish_use_subcommand" -s h -l help -d 'Prints help information'
complete -c pueue -n "__fish_use_subcommand" -s V -l version -d 'Prints version information'
complete -c pueue -n "__fish_use_subcommand" -f -a "add" -d 'Enqueue a task for execution'
complete -c pueue -n "__fish_use_subcommand" -f -a "remove" -d 'Remove tasks from the list. Running or paused tasks need to be killed first'
complete -c pueue -n "__fish_use_subcommand" -f -a "switch" -d 'Switches the queue position of two commands. Only works on queued and stashed commands'
complete -c pueue -n "__fish_use_subcommand" -f -a "stash" -d 'Stashed tasks won\'t be automatically started. You have to enqueue them or start them by hand'
complete -c pueue -n "__fish_use_subcommand" -f -a "enqueue" -d 'Enqueue stashed tasks. They\'ll be handled normally afterwards'
complete -c pueue -n "__fish_use_subcommand" -f -a "start" -d 'Resume operation of specific tasks or groups of tasks.
By default, this resumes the default group and all its tasks.
Can also be used force-start specific tasks.'
complete -c pueue -n "__fish_use_subcommand" -f -a "restart" -d 'Restart task(s). Identical tasks will be created and by default enqueued. By default, a new task will be created'
complete -c pueue -n "__fish_use_subcommand" -f -a "pause" -d 'Either pause running tasks or specific groups of tasks.
By default, pauses the default group and all its tasks.
A paused queue (group) won\'t start any new tasks.'
complete -c pueue -n "__fish_use_subcommand" -f -a "kill" -d 'Kill specific running tasks or whole task groups. Kills all tasks of the default group when no ids are provided'
complete -c pueue -n "__fish_use_subcommand" -f -a "send" -d 'Send something to a task. Useful for sending confirmations such as \'y\\n\''
complete -c pueue -n "__fish_use_subcommand" -f -a "edit" -d 'Edit the command or path of a stashed or queued task.
The command is edited by default.'
complete -c pueue -n "__fish_use_subcommand" -f -a "group" -d 'Use this to add or remove groups. By default, this will simply display all known groups'
complete -c pueue -n "__fish_use_subcommand" -f -a "status" -d 'Display the current status of all tasks'
complete -c pueue -n "__fish_use_subcommand" -f -a "log" -d 'Display the log output of finished tasks. Prints either all logs or only the logs of specified tasks'
complete -c pueue -n "__fish_use_subcommand" -f -a "follow" -d 'Follow the output of a currently running task. This command works like tail -f'
complete -c pueue -n "__fish_use_subcommand" -f -a "wait" -d 'Wait until tasks are finished. This can be quite useful for scripting. By default, this will wait for all tasks in the default group to finish. Note: This will also wait for all tasks that aren\'t somehow \'Done\'. Includes: [Paused, Stashed, Locked, Queued, ...]'
complete -c pueue -n "__fish_use_subcommand" -f -a "clean" -d 'Remove all finished tasks from the list (also clears logs)'
complete -c pueue -n "__fish_use_subcommand" -f -a "reset" -d 'Kill all tasks, clean up afterwards and reset EVERYTHING!'
complete -c pueue -n "__fish_use_subcommand" -f -a "shutdown" -d 'Remotely shut down the daemon. Should only be used if the daemon isn\'t started by a service manager'
complete -c pueue -n "__fish_use_subcommand" -f -a "parallel" -d 'Set the amount of allowed parallel tasks. By default, adjusts the amount of the default group'
complete -c pueue -n "__fish_use_subcommand" -f -a "completions" -d 'Generates shell completion files. This can be ignored during normal operations'
complete -c pueue -n "__fish_use_subcommand" -f -a "help" -d 'Prints this message or the help of the given subcommand(s)'
complete -c pueue -n "__fish_seen_subcommand_from add" -d 'The command to be added' -r
complete -c pueue -n "__fish_seen_subcommand_from add" -s d -l delay -d 'Prevents the task from being enqueued until <delay> elapses. See "enqueue" for accepted formats' -r
complete -c pueue -n "__fish_seen_subcommand_from add" -s g -l group -d 'Assign the task to a group. Groups kind of act as separate queues. I.e. all groups run in parallel and you can specify the amount of parallel tasks for each group. If no group is specified, the default group will be used' -r
complete -c pueue -n "__fish_seen_subcommand_from add" -s a -l after -d 'Start the task once all specified tasks have successfully finished. As soon as one of the dependencies fails, this task will fail as well' -r
complete -c pueue -n "__fish_seen_subcommand_from add" -s l -l label -d 'Add some information for yourself. This string will be shown in the "status" table. There\'s no additional logic connected to it' -r
complete -c pueue -n "__fish_seen_subcommand_from add" -s e -l escape -d 'Escape any special shell characters (" ", "&", "!", etc.). Beware: This implicitly disables nearly all shell specific syntax ("&&", "&>")'
complete -c pueue -n "__fish_seen_subcommand_from add" -s i -l immediate -d 'Immediately start the task'
complete -c pueue -n "__fish_seen_subcommand_from add" -s s -l stashed -d 'Create the task in Stashed state. Useful to avoid immediate execution if the queue is empty'
complete -c pueue -n "__fish_seen_subcommand_from add" -s p -l print-task-id -d 'Only return the task id instead of a text. This is useful when scripting and working with dependencies'
complete -c pueue -n "__fish_seen_subcommand_from add" -s h -l help -d 'Prints help information'
complete -c pueue -n "__fish_seen_subcommand_from add" -s V -l version -d 'Prints version information'
complete -c pueue -n "__fish_seen_subcommand_from remove" -d 'The task ids to be removed' -r
complete -c pueue -n "__fish_seen_subcommand_from remove" -s h -l help -d 'Prints help information'
complete -c pueue -n "__fish_seen_subcommand_from remove" -s V -l version -d 'Prints version information'
complete -c pueue -n "__fish_seen_subcommand_from switch" -d 'The first task id' -r
complete -c pueue -n "__fish_seen_subcommand_from switch" -d 'The second task id' -r
complete -c pueue -n "__fish_seen_subcommand_from switch" -s h -l help -d 'Prints help information'
complete -c pueue -n "__fish_seen_subcommand_from switch" -s V -l version -d 'Prints version information'
complete -c pueue -n "__fish_seen_subcommand_from stash" -d 'Stash these specific tasks' -r
complete -c pueue -n "__fish_seen_subcommand_from stash" -s h -l help -d 'Prints help information'
complete -c pueue -n "__fish_seen_subcommand_from stash" -s V -l version -d 'Prints version information'
complete -c pueue -n "__fish_seen_subcommand_from enqueue" -d 'Enqueue these specific tasks' -r
complete -c pueue -n "__fish_seen_subcommand_from enqueue" -s d -l delay -d 'Delay enqueuing these tasks until <delay> elapses. See DELAY FORMAT below' -r
complete -c pueue -n "__fish_seen_subcommand_from enqueue" -s h -l help -d 'Prints help information'
complete -c pueue -n "__fish_seen_subcommand_from enqueue" -s V -l version -d 'Prints version information'
complete -c pueue -n "__fish_seen_subcommand_from start" -d 'Start these specific tasks. Paused tasks will resumed. Queued or Stashed tasks will be force-started' -r
complete -c pueue -n "__fish_seen_subcommand_from start" -s g -l group -d 'Resume a specific group and all paused tasks in it. The group will be set to running and its paused tasks will be resumed' -r
complete -c pueue -n "__fish_seen_subcommand_from start" -s a -l all -d 'Resume all groups! All groups will be set to running and paused tasks will be resumed'
complete -c pueue -n "__fish_seen_subcommand_from start" -s c -l children -d 'Also resume direct child processes of your paused tasks. By default only the main process will get a SIGSTART'
complete -c pueue -n "__fish_seen_subcommand_from start" -s h -l help -d 'Prints help information'
complete -c pueue -n "__fish_seen_subcommand_from start" -s V -l version -d 'Prints version information'
complete -c pueue -n "__fish_seen_subcommand_from restart" -d 'Restart these specific tasks' -r
complete -c pueue -n "__fish_seen_subcommand_from restart" -s k -l start-immediately -d 'Immediately start the tasks'
complete -c pueue -n "__fish_seen_subcommand_from restart" -s s -l stashed -d 'Set the restarted task to a "Stashed" state. Useful to avoid immediate execution'
complete -c pueue -n "__fish_seen_subcommand_from restart" -s i -l in-place -d 'Restart the task by reusing the already existing tasks. This will overwrite any previous logs of the restarted tasks'
complete -c pueue -n "__fish_seen_subcommand_from restart" -s a -l all-failed -d 'Restart all failed tasks'
complete -c pueue -n "__fish_seen_subcommand_from restart" -s e -l edit -d 'Edit the tasks\' command before restarting'
complete -c pueue -n "__fish_seen_subcommand_from restart" -s p -l edit-path -d 'Edit the tasks\' path before restarting'
complete -c pueue -n "__fish_seen_subcommand_from restart" -s h -l help -d 'Prints help information'
complete -c pueue -n "__fish_seen_subcommand_from restart" -s V -l version -d 'Prints version information'
complete -c pueue -n "__fish_seen_subcommand_from pause" -d 'Pause these specific tasks. Does not affect the default group, groups or any other tasks' -r
complete -c pueue -n "__fish_seen_subcommand_from pause" -s g -l group -d 'Pause a specific group' -r
complete -c pueue -n "__fish_seen_subcommand_from pause" -s a -l all -d 'Pause all groups!'
complete -c pueue -n "__fish_seen_subcommand_from pause" -s w -l wait -d 'Only pause the specified group and let already running tasks finish by themselves'
complete -c pueue -n "__fish_seen_subcommand_from pause" -s c -l children -d 'Also pause direct child processes of a task\'s main process. By default only the main process will get a SIGSTOP. This is useful when calling bash scripts, which start other processes themselves. This operation is not recursive!'
complete -c pueue -n "__fish_seen_subcommand_from pause" -s h -l help -d 'Prints help information'
complete -c pueue -n "__fish_seen_subcommand_from pause" -s V -l version -d 'Prints version information'
complete -c pueue -n "__fish_seen_subcommand_from kill" -d 'Kill these specific tasks' -r
complete -c pueue -n "__fish_seen_subcommand_from kill" -s g -l group -d 'Kill all running tasks in a group. This also pauses the group' -r
complete -c pueue -n "__fish_seen_subcommand_from kill" -s a -l all -d 'Kill all running tasks across ALL groups. This also pauses all groups'
complete -c pueue -n "__fish_seen_subcommand_from kill" -s c -l children -d 'Send the SIGTERM signal to all children as well. Useful when working with shell scripts'
complete -c pueue -n "__fish_seen_subcommand_from kill" -s h -l help -d 'Prints help information'
complete -c pueue -n "__fish_seen_subcommand_from kill" -s V -l version -d 'Prints version information'
complete -c pueue -n "__fish_seen_subcommand_from send" -d 'The id of the task' -r
complete -c pueue -n "__fish_seen_subcommand_from send" -d 'The input that should be sent to the process' -r
complete -c pueue -n "__fish_seen_subcommand_from send" -s h -l help -d 'Prints help information'
complete -c pueue -n "__fish_seen_subcommand_from send" -s V -l version -d 'Prints version information'
complete -c pueue -n "__fish_seen_subcommand_from edit" -d 'The id of the task' -r
complete -c pueue -n "__fish_seen_subcommand_from edit" -s p -l path -d 'Edit the path of the task'
complete -c pueue -n "__fish_seen_subcommand_from edit" -s h -l help -d 'Prints help information'
complete -c pueue -n "__fish_seen_subcommand_from edit" -s V -l version -d 'Prints version information'
complete -c pueue -n "__fish_seen_subcommand_from group" -s a -l add -d 'Add a group by name' -r
complete -c pueue -n "__fish_seen_subcommand_from group" -s r -l remove -d 'Remove a group by name. This will move all tasks in this group to the default group!' -r
complete -c pueue -n "__fish_seen_subcommand_from group" -s h -l help -d 'Prints help information'
complete -c pueue -n "__fish_seen_subcommand_from group" -s V -l version -d 'Prints version information'
complete -c pueue -n "__fish_seen_subcommand_from status" -s g -l group -d 'Only show tasks of a specific group' -r
complete -c pueue -n "__fish_seen_subcommand_from status" -s j -l json -d 'Print the current state as json to stdout. This does not include stdout/stderr of tasks. Use `log -j` if you want everything'
complete -c pueue -n "__fish_seen_subcommand_from status" -s h -l help -d 'Prints help information'
complete -c pueue -n "__fish_seen_subcommand_from status" -s V -l version -d 'Prints version information'
complete -c pueue -n "__fish_seen_subcommand_from log" -d 'View the task output of these specific tasks' -r
complete -c pueue -n "__fish_seen_subcommand_from log" -s l -l lines -d 'Only print the last X lines of each task\'s output. This is done by default if you\'re looking at multiple tasks' -r
complete -c pueue -n "__fish_seen_subcommand_from log" -s j -l json -d 'Print the resulting tasks and output as json. Can be very large!'
complete -c pueue -n "__fish_seen_subcommand_from log" -s f -l full -d 'Show the whole stdout and stderr output. This is the default if only a single task is being looked at'
complete -c pueue -n "__fish_seen_subcommand_from log" -s h -l help -d 'Prints help information'
complete -c pueue -n "__fish_seen_subcommand_from log" -s V -l version -d 'Prints version information'
complete -c pueue -n "__fish_seen_subcommand_from follow" -d 'The id of the task you want to watch. If no or multiple tasks are running, you have to specify the id. If only a single task is running, you can omit the id' -r
complete -c pueue -n "__fish_seen_subcommand_from follow" -s e -l err -d 'Show stderr instead of stdout'
complete -c pueue -n "__fish_seen_subcommand_from follow" -s h -l help -d 'Prints help information'
complete -c pueue -n "__fish_seen_subcommand_from follow" -s V -l version -d 'Prints version information'
complete -c pueue -n "__fish_seen_subcommand_from wait" -d 'This allows you to wait for specific tasks to finish' -r
complete -c pueue -n "__fish_seen_subcommand_from wait" -s g -l group -d 'Wait for all tasks in a specific group' -r
complete -c pueue -n "__fish_seen_subcommand_from wait" -s a -l all -d 'Wait for all tasks across all groups and the default group'
complete -c pueue -n "__fish_seen_subcommand_from wait" -s q -l quiet -d 'Don\'t show any log output while waiting'
complete -c pueue -n "__fish_seen_subcommand_from wait" -s h -l help -d 'Prints help information'
complete -c pueue -n "__fish_seen_subcommand_from wait" -s V -l version -d 'Prints version information'
complete -c pueue -n "__fish_seen_subcommand_from clean" -s s -l successful-only -d 'Only clean tasks that finished successfully'
complete -c pueue -n "__fish_seen_subcommand_from clean" -s h -l help -d 'Prints help information'
complete -c pueue -n "__fish_seen_subcommand_from clean" -s V -l version -d 'Prints version information'
complete -c pueue -n "__fish_seen_subcommand_from reset" -s c -l children -d 'Send the SIGTERM signal to all children as well. Useful when working with shell scripts'
complete -c pueue -n "__fish_seen_subcommand_from reset" -s f -l force -d 'Don\'t ask for any confirmation'
complete -c pueue -n "__fish_seen_subcommand_from reset" -s h -l help -d 'Prints help information'
complete -c pueue -n "__fish_seen_subcommand_from reset" -s V -l version -d 'Prints version information'
complete -c pueue -n "__fish_seen_subcommand_from shutdown" -s h -l help -d 'Prints help information'
complete -c pueue -n "__fish_seen_subcommand_from shutdown" -s V -l version -d 'Prints version information'
complete -c pueue -n "__fish_seen_subcommand_from parallel" -d 'The amount of allowed parallel tasks' -r
complete -c pueue -n "__fish_seen_subcommand_from parallel" -s g -l group -d 'Set the amount for a specific group' -r
complete -c pueue -n "__fish_seen_subcommand_from parallel" -s h -l help -d 'Prints help information'
complete -c pueue -n "__fish_seen_subcommand_from parallel" -s V -l version -d 'Prints version information'
complete -c pueue -n "__fish_seen_subcommand_from completions" -d 'The target shell' -r -f -a "bash elvish fish power-shell zsh"
complete -c pueue -n "__fish_seen_subcommand_from completions" -d 'The output directory to which the file should be written' -r
complete -c pueue -n "__fish_seen_subcommand_from completions" -s h -l help -d 'Prints help information'
complete -c pueue -n "__fish_seen_subcommand_from completions" -s V -l version -d 'Prints version information'
complete -c pueue -n "__fish_seen_subcommand_from help" -s h -l help -d 'Prints help information'
complete -c pueue -n "__fish_seen_subcommand_from help" -s V -l version -d 'Prints version information'

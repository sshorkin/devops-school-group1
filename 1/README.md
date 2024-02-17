# Task 1

- Write a Bash script that processes tasks from the JSON file.
- Include a check for the presence of the JSON file in the script.
- If the JSON file is missing, output an appropriate message.
- If the file is absent, display an error message and terminate the script execution.
- Retrieve the current date in a format consistent with the dates in the JSON file.
- Use a loop to iterate through the tasks in the JSON file.
- For each task, check if its deadline has passed by comparing the deadline date with the current date.
- If a task has a passed deadline, output information about it (id, title, description, status, deadline).
- Use a flag to track whether overdue tasks were found during the script execution.
- If no overdue tasks are found, output a message indicating the absence of overdue tasks.

## Script run syntax

    task-processor [-h|-f file-name|-o yes/no]"

        options:

    -h     Print this Help.
    -f     Point file name.
    -o     Set overdue flag yes/no.


#!/bin/sh
#
# Write a Bash script that processes tasks from the JSON file.
# Include a check for the presence of the JSON file in the script.
# If the JSON file is missing, output an appropriate message.
# If the file is absent, display an error message and terminate the script execution.
# Retrieve the current date in a format consistent with the dates in the JSON file.
# Use a loop to iterate through the tasks in the JSON file.
# For each task, check if its deadline has passed by comparing the deadline date with the current date.
# If a task has a passed deadline, output information about it (id, title, description, status, deadline).
# Use a flag to track whether overdue tasks were found during the script execution.
# If no overdue tasks are found, output a message indicating the absence of overdue tasks.
#

export CURRENT_DATE=$(date +"%Y-%m-%d")

SOURCE_FILE="tasks.json"
OVERDUE_FLAG="no"

EMPTY_OVERDUE_TASKS=false
OVERDUE_TASKS=[]
CURRENT_TASKS=[]

usage() {
   echo "Syntax: task-processor [-h|-f file-name|-o yes/no]"
   echo "options:"
   echo "h     Print this Help."
   echo "f     Point file name."
   echo "o     Set overdue flag yes/no."
   echo
}

check_file() {
    if [ ! -f "$SOURCE_FILE" ]; then
        echo "Error: Task file $SOURCE_FILE not found.\n"
        usage
        exit 1
    fi
}

check_utils() {
    if ! [ -x "$(command -v jq)" ]; then
        echo 'Error: jq is not installed.' >&2
        exit 1
    fi
}

build_tasks() {
    CURRENT_TASKS=$(jq '.tasks | map( . | select(.deadline >= $ENV.CURRENT_DATE))' < $SOURCE_FILE)
    OVERDUE_TASKS=$(jq '.tasks | map( . | select(.deadline < $ENV.CURRENT_DATE))' < $SOURCE_FILE)
    EMPTY_OVERDUE_TASKS=$(echo $OVERDUE_TASKS | jq 'isempty(.)')
}

show_overdue_tasks() {
    echo $OVERDUE_TASKS | jq -r '.[] | "Id: \(.id)", "Title: \(.title)", "Description: \(.description)", "Status: \(.status)", "Deadline: \(.deadline)", "---"'
}

show_current_tasks() {
    echo $CURRENT_TASKS | jq -r '.[] | "Id: \(.id)", "Title: \(.title)", "Description: \(.description)", "Status: \(.status)", "Deadline: \(.deadline)", "---"'
}

while getopts "hf:o:" option; do
    case $option in
        h) # help
        usage
        exit 0
        ;;
        f) # file name
        SOURCE_FILE=$OPTARG
        ;;
        o) # overdue flag
        OVERDUE_FLAG=$OPTARG
        ;;
    esac
done

check_file
check_utils
build_tasks

show_current_tasks

if [ "$OVERDUE_FLAG" = "yes" ]; then
    if [ "$EMPTY_OVERDUE_TASKS" = true ]; then 
        echo "No overdue tasks found."
        exit
    else
        echo "--------------"
        echo "Overdue tasks:"
        echo "--------------"
        show_overdue_tasks
    fi
fi

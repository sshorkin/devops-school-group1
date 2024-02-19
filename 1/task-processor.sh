#!/bin/sh

export CURRENT_DATE=$(date +"%Y-%m-%d")

SOURCE_FILE="tasks.json"
OVERDUE_FLAG="no"

EMPTY_OVERDUE_TASKS=false
OVERDUE_TASKS=[]
PASSED_TASKS=[]

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
    PASSED_TASKS=$(jq '.tasks | map( . | select(.deadline < $ENV.CURRENT_DATE))' < $SOURCE_FILE)
    OVERDUE_TASKS=$(jq '.tasks | map( . | select(.deadline >= $ENV.CURRENT_DATE))' < $SOURCE_FILE)
    EMPTY_OVERDUE_TASKS=$(echo $OVERDUE_TASKS | jq 'isempty(.)')
}

show_overdue_tasks() {
    echo $OVERDUE_TASKS | jq -r '.[] | "Id: \(.id)", "Title: \(.title)", "Description: \(.description)", "Status: \(.status)", "Deadline: \(.deadline)", "---"'
}

show_passed_tasks() {
    echo $PASSED_TASKS | jq -r '.[] | "Id: \(.id)", "Title: \(.title)", "Description: \(.description)", "Status: \(.status)", "Deadline: \(.deadline)", "---"'
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

show_passed_tasks

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

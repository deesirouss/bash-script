#!/bin/bash

# Display the top three most visited URLs for a given web server log file

LOG_FILE="${1}"

# make sure log file exist
if [[ ! -e "${LOG_FILE}" ]]
then
  echo "can not open ${LOG_FILE}" >&2
  echo "Usage: $0 ACCESS_LOG_FILE"
  exit 1
fi

cut -d '"' -f 2 ${LOG_FILE} | cut -d ' ' -f 2 | sort | uniq -c | sort -n | tail -3


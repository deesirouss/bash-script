#!/bin/bash

# this script pings a list of servers and reports their status

SERVER_FILE='/home/bibek/Documents/scripts/lesson6/servers'

if [[ ! -e "${SERVER_FILE}" ]]
then
  echo "Can not open "${SERVER_FILE}"" >&2
  exit 1
fi

for SERVER in $(cat ${SERVER_FILE})
do
  echo "Pinging ${SERVER}"
  ping -c 1 ${SERVER} &> /dev/null
  if [[ $? -ne 0 ]]
  then
    echo "can not reach to server ${SERVER}"
  else
    echo "${SERVER} up"
  fi
done



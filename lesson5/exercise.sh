#!/bin/bash

# count the number of failed logins by IP address
# if there are any IPs with over LIMIT failures, display the count, IP and Location

LIMIT='10'
LOG_FILE="${1}"

# make sure a file was supplied as an argument
if [[ ! -e "${LOG_FILE}" ]]
then
  echo "Cannot open logfile: ${LOG_FILE}" >&2
  exit 1
fi

# Display the CSV header
echo "Count IP Location"

# loop through the list of failed attempts and aorresponding IP addresses
grep 'Failed' syslog-sample | awk '{print $(NF - 3)}' | sort | uniq -c | sort -rn | while read COUNT IP
do

  # if the number of failed attempts is greater than the limit, display count, IP, and Location
  if [[ "${COUNT}" -gt "${LIMIT}" ]]
    then
      LOCATION=$(geoiplookup ${IP} | awk -F ", " '{print $2}')
      echo "${COUNT} ${IP} ${LOCATION}"
  fi
done
exit 0

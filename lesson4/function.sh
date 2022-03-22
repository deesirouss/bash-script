#!/bin/bash

# this function sends a message to syslog and to standrad output if verbose is true

log() {
	local MESSAGE="${@}"
	if [[ "${VERBOSE}" = 'true' ]]
	then
		echo "${MESSAGE}"

	fi
	logger -t function.sh "${MESSAGE}"
}

# this function creates a backup of a file. Returns non-zero status on error
backup_file() {
	local FILE="${1}"

	# make sure the file exists
	if [[ -f "${FILE}" ]]
	then 
		local BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"
		log "Backing up ${FILE} to ${BACKUP_FILE}"
		# the exit status of the function will be the exit status of the cp command
		cp -p ${FILE} ${BACKUP_FILE}
	else
		# the file does not exist, so return a non-zero status
		return 1
	fi


}

readonly VERBOSE='true'

log 'Hello'
backup_file '/etc/passwd'
if [[ $? -eq 0 ]]
then
	log 'File backup succeeded'
else
	log 'File Backup failed'
	exit 1
fi



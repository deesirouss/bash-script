#!/bin/bash

# disable local user 
# this script disables, deletes and/or archives users on the local system
ARCHIVE_DIR='/archive'

# make sure the script is being executed with superuser privileges
if [[ $UID -ne 0 ]]
then
  echo "Please run with sudo or as root" >&2
  exit 1
fi

# chech command execution
check () {
  local MESSAGE="${@}"
  if [[ $? -ne 0 ]]
    then
      echo "${MESSAGE}" >&2
      exit 1
    fi
}

# Display the usage and exit
usage () {
  echo "Usage: $0 [-dra] USER_NAME..." >&2
  echo "Disable a local Linux account" >&2
  echo '-d Specify delete the accounts instead of disabling' >&2
  echo '-r Specify removes the home directory associated with the account' >&2
  echo '-a Specify creates an archive of the home directory associated with the account' >&2
  exit 1

}

# Parse the options
while getopts dra OPTION
do
  case ${OPTION} in
    d)
      DELETE_USER='true'
      ;;
    r)
      REMOVE_HOME='-r'
      ;;
    a)
      ARCHIVE='true'
      ;;
    ?)
      usage
      ;;
  esac
done

# Remove the options while leaving the remaining arguments
shift "$(( ${OPTIND} - 1 ))"

# If the user doesn't supply at least one argument give them help
if [[ ${#} -lt 1 ]]
then
  echo "Please provide USER_NAME"
  usage
fi

# loop through all the usernames supplied as arguments
for USER in "${@}"
do
  echo "Processing user: ${USER}"

  # make sure the UID of the account is at least 1000.
  USERID=$(id -u ${USER})
  if [[ "${USERID}" -lt 1001 ]]
  then
    echo "Refusing to remove the ${USER} account with the UID ${USERID}" >&2
    exit 1
  fi

  # create an archive if requested to do so
  if [[ "${ARCHIVE}" = 'true' ]]
  then
    # make sure the ARCHIVE_DIR directory exits
    if [[ ! -d "${ARCHIVE_DIR}" ]]
    then
      echo "creating ${ARCHIVE_DIR} directory"
      mkdir -p ${ARCHIVE_DIR}
      # check if mkdir command executes
      check "Can not create ${ARCHIVE_DIR}"
    fi

    # archive the user's home directory and move it into the ARCHIVE_DIR
    HOME_DIR="/home/${USER}"
    ARCHIVE_FILE="${ARCHIVE_DIR}/${USER}.tgz"
    if [[ -d "${HOME_DIR}" ]]
    then
      echo "Archiving ${HOME_DIR} to ${ARCHIVE_FILE}"
      tar -zcf ${ARCHIVE_FILE} ${HOME_DIR} &> /dev/null
      # check if tar command executes
      check "Can not create ${ARCHIVE_FILE}"
    else
      echo "${HOME_DIR} does not exist or is not a directory" >&2
      exit 1
    fi
  fi

  if [[ "${DELETE_USER}" = 'true' ]]
  then
    # delete the user
    userdel ${REMOVE_HOME} ${USER} &> /dev/null
    # check if user get deleted 
    check "Can not delete ${USER} account" >&2
    echo "The account ${USER} was deleted"
  else
    chage -E 0 ${USER}
    # check if chage command executes
    check "The account ${USER} was not disabled"
    echo "The account ${USER} was disabled"
  fi
done
exit 0





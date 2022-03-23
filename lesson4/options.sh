#!/bin/bash

# This script generates a random password with options
# this user can set the password length with -l and add a special character with -s 
# Verbose mode can be enabled with -v option

usage() {
  echo "Usage: $0 [-vs] [-l LENGTH]" >&2
  echo "Generate a rndom password"
  echo '-l LENGTH Specify the password length'
  echo '-s        Append a special character to the password'
  echo '-v        Increase verbosity'
  exit 1
}

verbose() {
  local MESSAGE="${@}"
  if [[ "${VERBOSE}" = 'true' ]]
  then
    echo "${MESSAGE}"
  fi
}

# Set a defualt password length 
LENGTH=48

while getopts vl:s OPTION
do
  case ${OPTION} in
    v)
      VERBOSE='true'
      verbose 'Verbose mode on'
      ;;
    l)
      LENGTH="${OPTARG}"
      ;;
    s)
      USE_SPECIAL_CHAR='true'
      ;;
    ?)
      usage
      ;;
  esac
done

# remove the option while leaving the remaining arguments
shift "$(( OPTIND -1 ))"

if [[ $# -gt 0 ]]
then
  usage
fi

verbose 'Generating Password'
PASSWORD="$(date +%s%N${RANDOM} | sha256sum | head -c${LENGTH})"

if [[ "${USE_SPECIAL_CHAR}" = 'true' ]]
then
  verbose 'selecting special character'
  SPECIAL_CHAR="$(echo '!@#$%*()-=' | fold -w1 | shuf | head -c1)"
  PASSWORD="${PASSWORD}${SPECIAL_CHAR}"
fi
verbose 'Done'
verbose "Here is your password"
echo $PASSWORD
exit 0

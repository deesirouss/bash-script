#!/bin/bash

# the goal of this exercise is to create a shell script that adds users to the same linux system as the script is executed on thorugh arguments as username and fullname as comment
# since we will save all STDERR and STDOUT into std.err and std.out file, user only get information what they want

# e.g. sudo ./exercise.sh bibek1 Bibek Mishra 1> STD.OUT 2> STD.ERR

# make sure the script is being executed with superuser privilege
if [[ $UID -ne 0 ]]
then
  echo "Please run as root user or with sudo ${0} i.e sudo privilege" >&2
  exit 1
fi

# if the user doesn't supply at least one argument then give them help
if [[ ${#} -eq 0 ]]
then 
  echo "Usage: ${0} USER_NAME [COMMENT]..." >&2
  exit 1
fi

# the first parameter is username
USER_NAME=${1}

# the rest of the parameters are for the account comments
shift
COMMENT=${*}

# Create the user with the password
PASSWORD=$(date +%s%N | sha256sum | head -c48)
useradd -m -c "${COMMENT}" ${USER_NAME} -s /bin/bash &> /dev/null

# check to see if the useradd command succeeded
if [[ $? -ne 0 ]]
then
  echo "User can't be created" >&2
  exit 1
fi

echo ""
tail -3 /etc/passwd
echo ""

echo "${USER_NAME}:${PASSWORD}" | chpasswd &> /dev/null
if [[ $? -ne 0 ]]
then
  echo "error in setting password" >&2
  exit 1
fi

# force password change on first login
passwd -e ${USER_NAME} &> /dev/null

# Display username, password, and the host when the user was created
echo 
echo "User name is: ${USER_NAME}"
echo "Passowrd is: ${PASSWORD}"
host=$(hostname -I | cut -f1 -d' ')
echo "host IP is: ${host} amd host name is ${HOSTNAME}"

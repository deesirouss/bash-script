#!/bin/bash

# Making sure the script is being executed with superuser privileges
if [[ ${UID} -ne 0 ]]
then
  echo "You do not have sudo/ root privilege"
  echo "Please run with sudo or as root"
  exit 1
fi

# Get the username (login)
read -p "Enter the username for user you want to create: " USER_NAME

# get the full name for the user to be created
read -p "Enter the full name for user account you want to create: " COMMENT

# get the password
read -sp "Enter the password: " PASSWORD

# create the user
useradd -m -c "${COMMENT}" ${USER_NAME} -s /bin/bash

# chek if useradd command succeeded
if [ $? -ne 0 ]
then
  echo "user not created"
  exit 1
else
  echo "User created ${USER_NAME}"
  cat /etc/passwd | tail -n 3
fi

# set the password
echo "${USER_NAME}:${PASSWORD}" | chpasswd

# check if password set command succeeded
if [[ $? -ne 0 ]]
then
  echo "password is not set"
fi

# force the password change in first login 
passwd -e ${USER_NAME}

# display the username, password and host where the user is created
host=$(hostname -I | cut -f1 -d' ')
echo "Your host IP is ${host} and Hostname is ${HOSTNAME}"
echo "Your username is ${USER_NAME}"
echo "Your Password is ${PASSWORD}"


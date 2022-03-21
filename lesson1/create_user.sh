#!/bin/bash

# This script creates an account on the local system.
# User will be prompted for the account name and password

# Ask for the user name.
read -p 'Enter the username to create: ' USER_NAME

# Ask for the real name.
read -p 'Enter the name of the person this account is for: ' COMMENT

# Ask for the password
read -sp "Enter the password to use for this account: " PASSWORD

# Create the user
useradd -c "${COMMENT}" -m ${USER_NAME} -s /bin/bash

# Set password for the user
echo ${USER_NAME}:${PASSWORD} | chpasswd
# this step can be done using " echo ${PASSWORD} | password --stdin ${USER_NAME}" but not supported in ubuntu

# Force password change on the first login
passwd -e ${USER_NAME}
cat /etc/passwd | grep ${USER_NAME}

# Extra Steps

read -p "Do you want to delete the user ${USER_NAME}? y/n " value
if [[ "${value}" = 'y' || "${value}" = 'Y' ]];
then
  userdel -r "${USER_NAME}"
  echo "deleted user ${USER_NAME} \n"
elif [[ "${value}" = 'n' || "${value}" = 'N' ]];
then
  echo "You can login to the user account"
else
  echo "user not deleted, you can login to the user account"
fi
cat /etc/passwd | grep ${USER_NAME}

#!/bin/bash

# this script displays UID & username
# also varifie if user is root or not

# Display UID
echo "Your UID is $UID"

# Display username
user_name=`id -un`  # or user_name=$(id -un) or user_name=$(whoami)
echo "Your UserName is $user_name"

# Display if the user is root user or not
if [ "$UID" -eq 0 ]
then
  echo 'You are root user'
else
  echo 'You are not root user'
fi

#!/bin/bash

# Display the UID and username and compare if UID is equal to 1000
# if UID is equal to 1000 then display the username

# Display the UID
echo "Your UID is ${UID}"

# Only display id the UID does not match 1000
UID_TO_TEST='1000'
if [ $UID -ne $UID_TO_TEST ]
then
  echo "Your UID does not match $UID_TO_TEST"
  exit 1
fi

# Display the Username
USER_NAME=$(id -un)

# Test if the command succeeded
if [ $? -ne 0 ]
then
  echo "The id command did not execute successfully"
  exit 1
fi
echo "Your username is $USER_NAME"

# You can use a string test conditional
USER_NAME_TEST='bibek'
if [ $USER_NAME == $USER_NAME_TEST ]
then
  echo "Your username matches $USER_NAME_TEST"

# test for != (not equal) for the string 
else
  echo "Your username does not match $USER_NAME_TEST"
  exit 1
fi

exit 0

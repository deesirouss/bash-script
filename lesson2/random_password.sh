#!/bin/bash

# This script generates a list of random password

# A random number as a password
PASSWORD="${RANDOM}"
echo "${PASSWORD}"

# three random numbers together as password
PASSWORD="${RANDOM}${RANDOM}${RANDOM}"
echo "$PASSWORD"

# use the current date/time as the basis for the password
PASSWORD=$(date +%s)
echo "$PASSWORD"

# use the nanosecond as the basis for the password
PASSWORD=$(date +%s%N)
echo "$PASSWORD"

# use better password combining date, sha256sum and head commands
PASSWORD=$(date +%s%N | sha256sum | head -c32)
echo "$PASSWORD"

# use even better password combining date, random numbers sha256sum and head commands
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c48)
echo "$PASSWORD"

# appending special character at the end of the password
SPEACIAL_CHARACTER=$( echo "!@#$%&*()-=" | fold -w1 | shuf | head -c1 )
echo "${PASSWORD}${SPEACIAL_CHARACTER}"

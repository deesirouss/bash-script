#!/bin/bash

# theis script demonstrates I/O redirection

# redirect STDOUT to a file
FILE=/tmp/data
head -n1 /etc/passwd > ${FILE}

# redirect STDIN to a program
read LINE < ${FILE}
echo "LINE contains: ${LINE}"

# redirect STDOUT to a file, overwriting the file
tail -n1 /etc/passwd > ${FILE}
cat ${FILE}

# appending new contents/inforamtion to the end of file
head -n1 /etc/passwd >> ${FILE}
echo "${RANDOM}" >> ${FILE}
echo "the content in ${FILE} is"
cat ${FILE}

# redirect STDIN to a program, using FD 0.
read LINE 0< ${FILE}
echo 
echo "LINE contains: ${LINE}"

# Redirect STDOUT to a file using FD 1, overwritting the file
head -n3 /etc/passwd 1> ${FILE}
echo 
echo "Contents of ${FILE}"
cat ${FILE}

# redirect STDERR to a file using FD 2
ERR_FILE="/tmp/data.err"
head -n3 /etc/passwd /fakefile 2> ${ERR_FILE}

# redirect STDOUT and STDERR to a file
head -n3 /etc/passwd /fakefile &> ${FILE}
echo 
echo "the content in ${FILE} is"
cat ${FILE}

# redirect STDOUT and STDERR to a file using pipe
echo 
head -n3 /etc/passwd /fakefile |& cat -n

# Discard STDOUT
echo
echo "Discarding STDOUT"
head -n3 /etc/passwd /fakefile > /dev/null

# Discard STDERR
echo 
echo "Discarding STDERR"
head -n3 /etc/passwd /fakefile 2> /dev/null

# discarding both STDERR and STDOUT
echo "Discarding both STDOUT and STDERR"
head -n3 /etc/passwd /fakefile &> /dev/null

# cleanup
rm ${FILE} ${ERR_FILE} &> /dev/null

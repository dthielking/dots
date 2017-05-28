#!/bin/bash
PING=`which ping`
URL="www.google.com"

# Ping URL
${PING} -c 1 ${URL} > /dev/null 2> /dev/null


if [[ $? -eq 0 ]]
then
    echo "Online"
    exit 0
else
    echo "Offline"
    exit 33
fi

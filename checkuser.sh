#!/bin/bash
USERINFO=$(getent passwd $1)
echo "\nUser info:  $USERINFO"
if [ $USERINFO ]; then
   echo "\n$1 already exists"
else
   echo "\nNew user: $1"
fi


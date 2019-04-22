#!/bin/bash
# run using
# ./clonevm.sh nameofvm number
# ./duo.sh basecleanVM 2
name=$1
count=$2
number=1

while [ "$number" -lt $count ]; do
  newname="$name_$number"
  VBoxManage clonevm $name --name "$newname" --register
  number=$((number + 1))
done
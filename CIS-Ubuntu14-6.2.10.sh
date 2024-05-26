#!/bin/bash

cat /etc/passwd | egrep -v '^(root|halt|sync|shutdown)' | awk -F: '($7 != "/sbin/nologin" && $7 != "/bin/false") { print $1, $6 }' | while read user dir; do
  if [ ! -d "$dir" ]; then
    echo "The home directory ($dir) of user $user does not exist."
  else
    if [ "$(ls -A "$dir")" ]; then
      for file in "$dir"/.[!.]*.* "$dir"/*; do
        if [ ! -h "$file" -a -f "$file" ]; then
          file_perm=$(ls -ld "$file" | cut -d' ' -f1)
          if [ "${file_perm:6:1}" != "-" ]; then
            echo "Group Write permission set on file $file"
          fi
          if [ "${file_perm:9:1}" != "-" ]; then
            echo "Other Write permission set on file $file"
          fi
        fi
      done
    fi
  fi
done

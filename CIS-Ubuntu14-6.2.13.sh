#!/bin/bash

cat /etc/passwd | egrep -v '^(root|halt|sync|shutdown)' | awk -F: '($7 != "/sbin/nologin" && $7 != "/bin/false") { print $1, $6 }' | while read user dir; do
  if [ ! -d "$dir" ]; then
    echo "The home directory ($dir) of user $user does not exist."
  else
    for file in "$dir"/.netrc; do
      if [ ! -h "$file" -a -f "$file" ]; then
        file_perm=$(ls -ld "$file" | cut -d' ' -f1)
        if [ "${file_perm:4:1}" != "-" ]; then
          echo "Group Read set on $file"
        fi
        if [ "${file_perm:5:1}" != "-" ]; then
          echo "Group Write set on $file"
        fi
        if [ "${file_perm:6:1}" != "-" ]; then
          echo "Group Execute set on $file"
        fi
        if [ "${file_perm:7:1}" != "-" ]; then
          echo "Other Read set on $file"
        fi
        if [ "${file_perm:8:1}" != "-" ]; then
          echo "Other Write set on $file"
        fi
        if [ "${file_perm:9:1}" != "-" ]; then
          echo "Other Execute set on $file"
        fi
      fi
    done
  fi
done

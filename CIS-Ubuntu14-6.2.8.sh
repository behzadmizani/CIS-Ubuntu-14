#!/bin/bash
cat /etc/passwd | egrep -v '^(root|halt|sync|shutdown)' | awk -F: '($7 != "/usr/sbin/nologin" && $7 != "/bin/false") { print $1, $6 }' | while read user dir; do
  if [ ! -d "$dir" ]; then
    echo "The home directory ($dir) of user $user does not exist."
  else
    dirperm=$(ls -ld "$dir" | awk '{print $1}')
    if [ "${dirperm:6:1}" != "-" ]; then
      echo "Group Write permission set on the home directory ($dir) of user $user"
    fi
    if [ "${dirperm:8:1}" != "-" ]; then
      echo "Other Read permission set on the home directory ($dir) of user $user"
    fi
    if [ "${dirperm:9:1}" != "-" ]; then
      echo "Other Write permission set on the home directory ($dir) of user $user"
    fi
    if [ "${dirperm:10:1}" != "-" ]; then
      echo "Other Execute permission set on the home directory ($dir) of user $user"
    fi
  fi
done

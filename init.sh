#!/usr/bin/env bash

echo "Sourcing NVM"
. ~/.nvm/nvm.sh;

echo "Grabbing Assignment Files"
echo "ID: $ASSIGNMENTID"

cd /workspace
if [ ! -f /workspace/.delete-me-to-regen-assignment ]; then
  export URL="$(node /root/.novajs/assignment.js)"
  echo "URL: $URL"

  echo "I: git clone"
  git clone --depth=1 "$URL" STAGING

  # include hidden files
  echo "I: stage files"
  cp -rv STAGING/. ./

  echo "I: deleted staging"
  rm -r STAGING

  echo "true" > .delete-me-to-regen-assignment
else
  echo "I: Already Downloaded Assignment"
fi

cd /cloud9

echo "I: Spawing PM2"
pm2 start --name cloud9 server.js -- -p 80 -a -w "/workspace"

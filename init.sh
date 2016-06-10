#!/usr/bin/env bash

echo "Grabbing Assignment Files"
echo "ID: $ASSIGNMENTID"

cd /workspace
if [ ! "$(cat .delete-me-to-regen-assignment)" == "true" ]
then
  export URL="$(node /root/.novajs/assignment.js)"
  echo "URL: $URL"

  echo "git clone"
  git clone --depth=1 "$URL" STAGING

  # include hidden files
  echo "stage files"
  cp -rv STAGING/. ./

  echo "deleted staging"
  rm -r STAGING

  echo "true" > .delete-me-to-regen-assignment
else
  echo "Already Downloaded Assignment"
fi

cd /root

echo "Spawning supervisord to watch over cloud9 process."
supervisord -c "/etc/supervisor/supervisord.conf"

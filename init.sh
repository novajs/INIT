#!/usr/bin/env bash

# Give Rancher time?
sleep 3

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

# Tell API that we have X IP
IP=$(curl http://rancher-metadata/2015-12-19/self/container/ips/0)
echo "IP: ${IP}"
echo ${IP} > /tmp/rancher-ip

cd /cloud9

echo "I: Spawing PM2"
pm2 start --no-daemon --name cloud9 server.js -- -p 80 -a -w "/workspace"

#!/usr/bin/env bash

echo "I: Sourcing NVM"
. ~/.nvm/nvm.sh;

echo "I: Grabbing Assignment Files"
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
echo "I: Informing IDE of our IP."
echo "Auth: ${POST_AUTH}"


IP=""
while [ -z "$IP" ]
do
  PROPOSEDIP=$(curl http://rancher-metadata/latest/self/container/ips/0 2>/dev/null)
  
  if [ "${PROPOSEDIP}" -ne "Not found" ]; then
    IP="${PROPOSEDIP}"
  fi
  
  echo "I: Waiting for IP, got: '${PROPOSEDIP}'"
  sleep 1
done

echo ${IP} > /tmp/rancher-ip

echo "I: Got "
curl https://api.tritonjs.com/v1/workspaces/containerpostboot \
 -d "{ \"auth\": \"${POST_AUTH}\", \"ip\": \"${IP}\" }" \
 -H 'Content-Type: application/json'

echo "I: Fixing Collab on NFS"
rm /workspace/.c9/collab.db /root/.c9/collab.db # Fix old and possibly stale link.
ln -s /root/.c9/collab.db /workspace/.c9/collab.db

cd /cloud9

echo "I: Spawing PM2"
pm2 start --no-daemon --name cloud9 server.js -- -p 80 -l 0.0.0.0 -a : -w "/workspace" --collab

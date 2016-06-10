#!/usr/bin/env bash

echo "Grabbing Assignment Files"
echo "ID: $ASSIGNMENTID"

cd /workspace
export URL="$(node /root/.novajs/assignment.js)"
echo "URL: $URL"
git clone --depth=1 "$URL"
cd /root

echo "Spawning supervisord to watch over cloud9 process."
supervisord -c "/etc/supervisor/supervisord.conf"

#!/usr/bin/env bash

echo "Grabbing Assignment Files"
echo "ID: $ASSIGNMENTID"

pushd "/workspace"
git clone "$(node /root/assignment.js)"
popd

echo "Spawning supervisord to watch over cloud9 process."
supervisord -c "/etc/supervisor/supervisord.conf"

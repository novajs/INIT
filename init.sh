#!/usr/bin/env bash

echo "Grabbing Assignment Files"
# nodejs code here.

echo "Grabbing USER files."
# nodejs code here.

echo "Spawning supervisord to watch over cloud9 process."
supervisord -c "/etc/supervisor/supervisord.conf"

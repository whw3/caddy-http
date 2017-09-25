#!/bin/bash
if [[ -x /srv/init.sh ]]; then
    exec /srv/init.sh
fi

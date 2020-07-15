#!/bin/bash

GROUPNAME='puppetboard'
USERNAME='puppetboard'

LUID=${LOCAL_UID:-0}
LGID=${LOCAL_GID:-0}

if [ $LUID -eq 0 ]
then
    LUID=65534
fi

if [ $LGUID -eq 0 ]
then
    LGID=65534
fi

groupadd -o -g $LGID    $GROUPNAME >/dev/null 2>&1 ||
groupmod -o -g $LGID    $GROUPNAME >/dev/null 2>&1
useradd  -o -u $LUID -g $GROUPNAME -s /bin/false $USERNAME >/dev/null 2>&1 ||
usermod  -o -u $LUID -g $GROUPNAME -s /bin/false $USERNAME >/dev/null 2>&1
mkhomedir_helper $USERNAME

chown -R $USERNAME:$GROUPNAME /usr/src/app

exec gosu $USERNAME:$GROUPNAME gunicorn -b 0.0.0.0:${PUPPETBOARD_PORT} --workers="${PUPPETBOARD_WORKERS:-1}" -e SCRIPT_NAME="${PUPPETBOARD_URL_PREFIX:-}" --access-logfile=- puppetboard.app:app
# vim: set expandtab smarttab tabstop=4 shiftwidth=4 softtabstop=4:

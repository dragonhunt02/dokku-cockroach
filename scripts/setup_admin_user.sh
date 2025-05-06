#!/bin/bash

set -e

CERTS_DIR="/cockroach/certs"

user_already_exists() {
   cockroach sql --certs-dir=$CERTS_DIR --host=127.0.0.1 --execute "select username FROM [SHOW ROLES]" \
     | tail -n +2 \
     | grep "^${1}\$"
}

set_admin_user() {
  COCKROACH_USER="dokku"
  #$1"
  echo >&2 "Add user admin permissions to: $COCKROACH_USER"
  if [[ -z $COCKROACH_USER ]]; then
    return 0
  fi

  if [[ -z $(user_already_exists "$COCKROACH_USER") ]]; then
    local user_query="CREATE USER "$COCKROACH_USER""
    if [[ -n "$COCKROACH_PASSWORD" ]]; then
      user_query+=" WITH PASSWORD '$COCKROACH_PASSWORD'"
    fi
    cockroach sql --certs-dir=$CERTS_DIR --host=127.0.0.1 --execute "$user_query;"
  
    cockroach sql --certs-dir=$CERTS_DIR --host=127.0.0.1 --execute "GRANT ALL ON DATABASE "$COCKROACH_DATABASE" TO "$COCKROACH_USER";"
    cockroach sql --certs-dir=$CERTS_DIR --host=127.0.0.1 --execute "GRANT admin TO "$COCKROACH_USER";"

    echo >&2 "finished creating default user \"$COCKROACH_USER\""
  else
    echo >&2 "user \"$COCKROACH_USER\" already exists"
  fi
}

set_admin_user "$1"

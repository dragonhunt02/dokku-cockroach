#!/bin/bash

set -e

CERTS_DIR="/cockroach/certs"

user_already_exists() {
   cockroach sql --certs-dir=$CERTS_DIR --host=127.0.0.1 --execute "select username FROM [SHOW ROLES]" \
     | tail -n +2 \
     | grep "^${1}\$"
}

set_admin_user() {
  COCKROACH_USER=
  DATABASE_NAME="$1"
  NEW_USER="dokku"
  #$1"
  echo >&2 "Add user admin permissions to: $NEW_USER"
  if [[ -z $NEW_USER ]]; then
    return 0
  fi

  if [[ -z $(user_already_exists "$NEW_USER") ]]; then
    local user_query="CREATE USER "$NEW_USER""
    if [[ -n "$COCKROACH_PASSWORD" ]]; then
      user_query+=" WITH PASSWORD '$COCKROACH_PASSWORD'"
    fi
    cockroach sql --certs-dir=$CERTS_DIR --host=127.0.0.1 --execute "$user_query;"
  
    cockroach sql --certs-dir=$CERTS_DIR --host=127.0.0.1 --execute "GRANT ALL ON DATABASE "$DATABASE_NAME" TO "$NEW_USER";"
    cockroach sql --certs-dir=$CERTS_DIR --host=127.0.0.1 --execute "GRANT admin TO "$NEW_USER";"

    echo >&2 "finished creating default user \"$NEW_USER\""
  else
    echo >&2 "user \"$NEW_USER\" already exists"
  fi
}

set_admin_user "$1"

#!/bin/bash

set -e

CERTS_DIR="/cockroach/certs"

user_already_exists() {
   cockroach sql --certs-dir=$CERTS_DIR --host=127.0.0.1 --execute "select username FROM [SHOW ROLES]" \
     | tail -n +2 \
     | grep "^${1}\$"
}

create_default_user() {
  COCKROACH_USER="dokku"
  echo >&2 "Create user: $COCKROACH_USER"
  if [[ -z $COCKROACH_USER ]]; then
    return 0
  fi

  if [[ -z $(user_already_exists "$COCKROACH_USER") ]]; then
    cockroach cert create-client --certs-dir=${CERTS_DIR} --ca-key=${CERTS_DIR}/ca.key "$COCKROACH_USER"
  fi
}

create_default_user "$1"


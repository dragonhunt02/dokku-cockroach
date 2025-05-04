#!/bin/sh

set -e

CERTS_DIR="/.cockroach-certs"

mkdir -p $CERTS_DIR
cd $CERTS_DIR

# TODO: Review hostname usage
if [ ! -f "$CERTS_DIR/ca.crt" ]; then
    echo "Cockroach certificates not found. Generating new certificates..."
    cockroach cert create-ca --certs-dir=${CERTS_DIR} --ca-key=${CERTS_DIR}/ca.key
    cockroach cert create-node localhost $(hostname) --certs-dir=${CERTS_DIR} --ca-key=${CERTS_DIR}/ca.key
    cockroach cert create-client root --certs-dir=${CERTS_DIR} --ca-key=${CERTS_DIR}/ca.key
fi

chown -R cockroach:cockroach $CERTS_DIR
chmod -R 600 $CERTS_DIR

#cp /dokku-cockroach-certs/* .

#chown cockroach:cockroach server.key
#chmod 600 server.key

#chown cockroach:cockroach server.crt
#chmod 600 server.crt

#sed -i "s/^#ssl = off/ssl = on/" postgresql.conf
#sed -i "s/^#ssl_ciphers =.*/ssl_ciphers = 'AES256+EECDH:AES256+EDH'/" postgresql.conf

#!/bin/sh

set -e

CERTS_DIR="/cockroach/certs"

mkdir -p $CERTS_DIR
cd $CERTS_DIR

# TODO: Allow ca.key load from path argument
# TODO: Review hostname usage
rm -rf $CERTS_DIR/* || true
if [ ! -f "$CERTS_DIR/ca.crt" ]; then
    echo "Cockroach CA public key certificate not found. Generating new CA certificates..."
    #rm -rf $CERTS_DIR/* || true
    cockroach cert create-ca --certs-dir=${CERTS_DIR} --ca-key=${CERTS_DIR}/ca.key
fi
echo "Generating node certificates..."
# TODO check if node certs exist
cockroach cert create-node localhost 127.0.0.1 $(hostname) --certs-dir=${CERTS_DIR} --ca-key=${CERTS_DIR}/ca.key
cockroach cert create-client root --certs-dir=${CERTS_DIR} --ca-key=${CERTS_DIR}/ca.key

#cat /etc/passwd || true
echo "File owner key: $(stat -c '%U' $CERTS_DIR/ca.key)"
echo "File owner crt: $(stat -c '%U' $CERTS_DIR/ca.crt)"
echo "Current user: $(whoami)"
#chown -R cockroach:cockroach $CERTS_DIR
chmod -R 600 $CERTS_DIR

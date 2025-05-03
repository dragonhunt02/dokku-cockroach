#!/bin/sh

set -e

cd /.cockroach-certs

#cp ../certs/* .
chown cockroach:cockroach server.key
chmod 600 server.key

chown cockroach:cockroach server.crt
chmod 600 server.crt

#sed -i "s/^#ssl = off/ssl = on/" postgresql.conf
#sed -i "s/^#ssl_ciphers =.*/ssl_ciphers = 'AES256+EECDH:AES256+EDH'/" postgresql.conf

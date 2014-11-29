#!/bin/bash
#---------------------------------------------------------------------------
# @(#)$Id$
#title          :haproxy-crt-startssl.sh
#description    :Creates haproxy certificate file for specified domain
#author         :Danny W Sheehan
#date           :July 2014
#website        :www.ftmon.org  www.setuptips.com
#---------------------------------------------------------------------------
HAPROXY_CERTS="/etc/haproxy/certs.d"
CERTS_DIR="/etc/ssl/localcerts"
CA_BUNDLE_SRC="http://www.startssl.com/certs/class2/sha2/pem/sub.class2.server.sha2.ca.pem"
CA_BUNDLE="$CERTS_DIR/Startssl_Class_2_CA.pem"



USAGE="Usage: `basename $0` <domain>"

if [ $# -ne 1 ]
then
  echo $USAGE
  exit 1
fi

DOMAIN=$1

#
# Get the root and intermediate certificate bundle from CA.
#
if ! mkdir -p $CERTS_DIR; then
  exit 1
fi

cd $CERTS_DIR
if [[ ! -f "$CA_BUNDLE" ]]; then
   wget -q -t 2 --output-document=$CA_BUNDLE $CA_BUNDLE_SRC
fi



#
# decrypt, comment out if you don't encrypt your keys.
#
openssl rsa -in $DOMAIN.key -out $DOMAIN.ssl.key

#
# Combine certificates and keys the way haproxy likes it.
#
cat $DOMAIN.ssl.key $DOMAIN.pem ${CA_BUNDLE} > ${HAPROXY_CERTS}/$DOMAIN.combined.pem

chown haproxy  ${HAPROXY_CERTS}/$DOMAIN.combined.pem
chmod 600 ${HAPROXY_CERTS}/$DOMAIN.combined.pem


#
# Backout if there is something wrong with your certificates.
#
if ! haproxy -c -f /etc/haproxy/haproxy.cfg
then
  echo "ERROR: please remove ${HAPROXY_CERTS}/$DOMAIN.combined.pem"
  exit 1
fi

# comment out if you don't use encrypted keys.
rm $DOMAIN.ssl.key


#!/bin/sh

set -e

if [ "$#" -ne 1 ] ; then
  echo "Usage: Must supply a domain"
  exit 1
fi

if [ ! -e "cert.conf" ] ; then
  echo "Create config file, sample file: cert.conf.in"
  exit
fi

. cert.conf

DOMAIN=$1

mkdir -p certs
cd certs

cat > $DOMAIN.cnf <<EOF
[ req ]
prompt=no
distinguished_name=req_distinguished_name

[ req_distinguished_name ]
C=${COUNTRY}
ST=${STATE}
L=${LOCATION}
O=${ORGANIZATION}
CN=${DOMAIN}
emailAddress=${EMAIL}
EOF

cat > $DOMAIN.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = $DOMAIN
EOF

echo Generating key...
openssl genrsa -out $DOMAIN.key 4096
echo Generating Certificate Request...
openssl req -new -config $DOMAIN.cnf -key $DOMAIN.key -out $DOMAIN.csr
echo Generating Certificate...
openssl x509 -req -in $DOMAIN.csr -CA ../CA/myCA.pem -CAkey ../CA/myCA.key -CAcreateserial \
-out $DOMAIN.crt -days 825 -sha256 -extfile $DOMAIN.ext

rm ${DOMAIN}.ext
rm ${DOMAIN}.cnf
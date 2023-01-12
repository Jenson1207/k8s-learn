#!/bin/bash

openssl genrsa -out ca.key 4096

openssl req -x509 -new -nodes -sha512 -days 3650 -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=192.168.0.10:30008" -key ca.key -out ca.crt

openssl genrsa -out tls.key 4096

openssl req -sha512 -new -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=192.168.0.10:30008" -key tls.key -out tls.csr

cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = IP:192.168.0.10

[alt_names]
DNS.1=192.168.0.10:30008
DNS.2=192.168.0.10
EOF

openssl x509 -req -sha512 -days 3650 -extfile v3.ext -CA ca.crt -CAkey ca.key -CAcreateserial -in tls.csr -out tls.crt

openssl x509 -inform PEM -in tls.crt -out tls.cert

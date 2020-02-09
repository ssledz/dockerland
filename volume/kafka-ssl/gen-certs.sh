#!/bin/bash

PASSWORD=kafkatest

rm -rf secrets
mkdir secrets
cd secrets

set -o nounset \
    -o errexit \
    -o verbose \
    -o xtrace

# Generate CA key
openssl req -new -x509 -keyout snakeoil-ca-1.key -out snakeoil-ca-1.crt -days 365 \
  -subj '/CN=kafka/OU=None/O=None/L=Warsaw/S=Warsaw/C=PL' -passin pass:$PASSWORD -passout pass:$PASSWORD

# Kafkacat
openssl genrsa -des3 -passout "pass:$PASSWORD" -out kafkacat.client.key 1024
openssl req -passin "pass:$PASSWORD" -passout "pass:$PASSWORD" -key kafkacat.client.key -new \
  -out kafkacat.client.req -subj '/CN=kafka/OU=None/O=None/L=Warsaw/S=Warsaw/C=PL'
openssl x509 -req -CA snakeoil-ca-1.crt -CAkey snakeoil-ca-1.key -in kafkacat.client.req \
  -out kafkacat-ca1-signed.pem -days 9999 -CAcreateserial -passin "pass:$PASSWORD"



for i in broker producer consumer
do
  echo $i
  # Create keystores
  keytool -genkey -noprompt \
    -alias $i \
    -dname "CN=kafka, OU=TEST, O=CONFLUENT, L=PaloAlto, S=Ca, C=US" \
    -keystore kafka.$i.keystore.jks \
    -keyalg RSA \
    -storepass $PASSWORD \
    -keypass $PASSWORD

  # Create CSR, sign the key and import back into keystore
  keytool -keystore kafka.$i.keystore.jks -alias $i -certreq -file $i.csr -storepass $PASSWORD -keypass $PASSWORD

  openssl x509 -req -CA snakeoil-ca-1.crt -CAkey snakeoil-ca-1.key -in $i.csr -out $i-ca1-signed.crt \
    -days 9999 -CAcreateserial -passin pass:$PASSWORD

  keytool -keystore kafka.$i.keystore.jks -alias CARoot -import -file snakeoil-ca-1.crt -storepass $PASSWORD \
    -keypass $PASSWORD -noprompt

  keytool -keystore kafka.$i.keystore.jks -alias $i -import -file $i-ca1-signed.crt -storepass $PASSWORD \
    -keypass $PASSWORD

  # Create truststore and import the CA cert.
  keytool -keystore kafka.$i.truststore.jks -alias CARoot -import -file snakeoil-ca-1.crt \
    -storepass $PASSWORD -keypass $PASSWORD -noprompt

  echo "$PASSWORD" > ${i}_sslkey_creds
  echo "$PASSWORD" > ${i}_keystore_creds
  echo "$PASSWORD" > ${i}_truststore_creds
done

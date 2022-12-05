#!/bin/bash

PRIVATE_KEY_PATH="ssl/private.pem"
PUBLIC_KEY_PATH="ssl/public.pub"
PLAIN_DATA_PATH="message.txt"
SIGNED_DATA_PATH="data/data.signed"
ENCRYPTED_DATA_PATH="data/data.encrypted"
DECRYPTED_DATA_PATH="data/data.decrypted"

echo "[1] Private key creation"
openssl genrsa -out $PRIVATE_KEY_PATH 4096
# You can use SSL with AES secret by uncomment the following line (and comment the previous) :
# openssl genrsa -aes128 -out $PRIVATE_KEY_PATH 4096

echo "[2] Public key extraction"
openssl rsa -in $PRIVATE_KEY_PATH -pubout > $PUBLIC_KEY_PATH

echo "[3] Encrypt data"
openssl rsautl -encrypt -inkey $PUBLIC_KEY_PATH -pubin -in $PLAIN_DATA_PATH -out $ENCRYPTED_DATA_PATH

echo "[4] Sign with private key"
openssl dgst -sign $PRIVATE_KEY_PATH -keyform PEM -sha256 -out $SIGNED_DATA_PATH -binary $ENCRYPTED_DATA_PATH

echo "[5] Verify with public key"
openssl dgst -verify $PUBLIC_KEY_PATH -keyform PEM -sha256 -signature $SIGNED_DATA_PATH -binary $ENCRYPTED_DATA_PATH

echo "[6] Decrypt data"
openssl rsautl -decrypt -inkey $PRIVATE_KEY_PATH -in $ENCRYPTED_DATA_PATH > $DECRYPTED_DATA_PATH
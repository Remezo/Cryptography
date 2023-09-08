 #!/bin/sh

#OPENSSL=/usr/local/Cellar/openssl@1.1/1.1.1u/bin/openssl
OPENSSL=/usr/local/bin/openssl

openssl genpkey -algorithm ed25519 -aes256 > ca_privkey.pem
openssl req -new -x509 -key ca_privkey.pem -out ca_certificate.pem -days 365

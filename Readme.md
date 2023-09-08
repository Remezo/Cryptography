
## In this Repo, we are going to create a certificate authority and
## issue certificates using the openssl tool. We also learn how to use
## openssl for symmetric encryption.

### Symmetric Encryption using openssl

 You can use openssl to perform symmetric encryption and decryption as follows. Substitute file.txt with any file that you'd like to encrypt. 

 ```shell
openssl aes-256-cbc -e -in file.txt -out file.enc
openssl aes-256-cbc -d -in file.enc -out file.orig
```
 



### Creating the Certificate Authority's Certificates

Do-it-yourself. First, generate the private key for the CA. the -des3
option encrypts the private key using the DSA symmetric algorithm, so
the file is protected. Remember that compromising private keys
compromises the whole protocol. 
```shell
openssl genpkey -algorithm ed25519 -aes256 \> ca_privkey.pem 
```
Do-it-yourself. Next, generate a self-signed
certificate for the CA. The parameter -x509 generates a self-signed
certificate instead of a request for signing that another CA could
perform. 
``` shell
openssl req -new -x509 -key ca_privkey.pem -out ca_certificate.pem -days 365
``` 

### Creating a Server Certificate

Do-it-yourself. First, generate the private key that a server could use
for TLS. 
``` shell
openssl genpkey -algorithm ed25519 -aes256 \> serv_privkey.pem

```
Do-it-yourself. Next, generate a certificate signing request that should
be signed by the certification authority. The absence of the parameter
-x509 configures the scenario where we are generating a request, not a
self-signed certificate. 
```shell
openssl req -new -key serv_privkey.pem -out serv_certrequest.pem
```




### Creating and Using a Certificate Authority

First, download the ca.config file from the folder above. This file configures the
certification authority. Inspect the file and locate: 
* The private key
of the CA 
* The certificate (public key + identifier) of the CA
Do-it-yourself. 
* Finally, use your CA to sign the certificate request for
the TLS server. 
```shell 
touch index.txt touch serial.txt echo \"01\" \>\>
serial.txt openssl ca -config ca.config -out serv_certificate.pem -in
serv_certrequest.pem -days 365
```

### Sign and Verify Using OpenSSL

First create a second public-private pair using a different elliptic
curve (secp256k1)1 : 
``` shell
openssl ecparam -name secp256k1 \>serv2_privkey_params.pem 
openssl genpkey -paramfile serv2_privkey_params.pem -aes256 \> serv2_privkey.pem 
openssl req -new -key serv2_privkey.pem -out serv2_certrequest.pem openssl ca -config ca.config -out serv2_certificate.pem -in serv2_certrequest.pem -days 

```
Now issue the sign/verify commands. The first command creates a hash of the
file, the second command exports the public key out from the
certificate, and the third command performs the signature. 

``` shell
openssl dgst -sha256 -sign serv2_privkey.pem -out file.txt.SIG file.txt openssl x509
-noout -pubkey -in serv2_certificate.pem \> serv2_pubkey.pem 
openssl dgst -sha256 -verify serv2_pubkey.pem -signature file.txt.SIG file.txt
 ```

Unfortunately, sign/verify is not currently supported for Ed25519 in
OpenSSL.





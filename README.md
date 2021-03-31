# Personal CA

With this CA you can create self-signed certificate.
``` bash
# generate the CA key
openssl genrsa -des3 -out CA/myCA.key 2048

# generate the CA certificate
openssl req -x509 -new -nodes -key CA/myCA.key -sha256 -days 1825 -out CA/myCA.pem
```
Note: memorize or save the password for the CA.
On MacOS, add the CA to the system chain so any application will recognize it.

``` bash
sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" CA/myCA.pem
```

Then create any new certificate with the script create_cert.sh.

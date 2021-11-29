echo "generateing a self signed certificate for run docker registry"

echo -e "\n\n\n\n\n\n" >> $1/certdetails.txt

createCert(){
  mkdir -p $1/certs/ && openssl req \
  -newkey rsa:4096 -nodes -sha256 -keyout $1/certs/dockerRegistry.key \
  -x509 -days 3650 -out $1/certs/dockerRegistry.crt
}

createCert $1 < $1/certdetails.txt

echo -e "-v $1/certs:/certs \\
-e REGISTRY_HTTP_TLS_CERTIFICATE=$1/certs/dockerRegistry.crt \\
-e REGISTRY_HTTP_TLS_KEY=$1/certs/dockerRegistry.key" >> $1/executor.txt

rm $1/certdetails.txt
echo creating auth
mkdir $1/auth
docker run --entrypoint htpasswd httpd:2 -Bbn $2 $3 > $1/auth/htpasswd

echo -e "-v -v "$(pwd)"/auth:/auth \\
-e 'REGISTRY_AUTH=htpasswd' \\
-e 'REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm' \\
-e REGISTRY_AUTH_HTPASSWD_PATH=$1/auth/htpasswd \\" >> $1/executor.sh
echo auth created
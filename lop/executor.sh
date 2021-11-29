docker run -d -p 5000:5000 --restart=always --name lop \
-v lop/certs:/certs \
-e REGISTRY_HTTP_TLS_CERTIFICATE=lop/certs/dockerRegistry.crt \
-e REGISTRY_HTTP_TLS_KEY=lop/certs/dockerRegistry.key \
-v lop/auth:/auth \
-e 'REGISTRY_AUTH=htpasswd' \
-e 'REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm' \
-e REGISTRY_AUTH_HTPASSWD_PATH=lop/auth/htpasswd \
registry

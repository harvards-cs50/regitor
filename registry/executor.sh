docker run -d -p 5000:5000 --restart=always --name registry \
-v registry/certs:/certs \
-e REGISTRY_HTTP_TLS_CERTIFICATE=registry/certs/dockerRegistry.crt \
-e REGISTRY_HTTP_TLS_KEY=registry/certs/dockerRegistry.key \
-v registry/auth:/auth \
-e 'REGISTRY_AUTH=htpasswd' \
-e 'REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm' \
-e REGISTRY_AUTH_HTPASSWD_PATH=registry/auth/htpasswd \
registry

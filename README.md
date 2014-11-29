# haproxy ssl termination

Keep all your certificates for different domains under /etc/haproxy/certs.d one for each domain you are terminating.

You can keep a default certificate in */etc/haproxy/defaut.pem*.



*/etc/haproxy/haproxy.cfg* snippit
```
...
...
frontend www
  bind ${LB1}:80
  bind ${LB1}:443 ssl crt /etc/haproxy/default.pem crt /etc/haproxy/certs.d no-tls-tickets ciphers EECDH+ECDSA+AESGCM:EECDH+aRSA+AESGCM:EECDH+ECDSA+SHA384:EECDH+ECDSA+SHA256:EECDH+aRSA+SHA384:EECDH+aRSA+SHA256:EECDH+aRSA+RC4:EECDH:EDH+aRSA:RC4:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!SRP:!DSS:!RC4 no-sslv3
...
...
```

# install HAproxy SSL termination

# install nginx
package { 'nginx':
  ensure     => 'installed',
}

# free 80
exec { 'free port 80':
  command => "sudo service haproxy stop",
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}

# run certbot
exec { 'run certbot':
  command => "sudo certbot certonly --standalone --preferred-challenges http --http-01-port 80 -d synux.tech -d www.synux.tech",
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}

# Combine fullchain.pem and privkey.pem
exec { 'run certbot':
  command => "sudo mkdir -p /etc/haproxy/certs"
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}

exec { 'create the combined file':
  command => "DOMAIN='synux.tech' sudo -E bash -c 'cat /etc/letsencrypt/live/$DOMAIN/fullchain.pem /etc/letsencrypt/live/$DOMAIN/privkey.pem > /etc/haproxy/certs/$DOMAIN.pem'"
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}

exec { 'Secure access to the combined file':
  command => "sudo chmod -R go-rwx /etc/haproxy/certs"
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}

# update software packages list
exec { 'update packages':
  command => 'apt-get update',
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}

# install haproxy
package { 'haproxy':
  ensure     => 'installed',
}

file { 'config file':
  ensure  => file,
  path    => '/etc/haproxy/haproxy.cfg',
  content    =>
"global
        log /dev/log    local0
        log /dev/log    local1 notice
        chroot /var/lib/haproxy
        stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
        stats timeout 30s
        user haproxy
        group haproxy
        daemon

        # self edition
        maxconn 2048
        tune.ssl.default-dh-param 2048

        # Default SSL material locations
        ca-base /etc/ssl/certs
        crt-base /etc/ssl/private

        # See: https://ssl-config.mozilla.org/#server=haproxy&server-version=2.0.3&config=intermediate
        ssl-default-bind-ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
        ssl-default-bind-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
        ssl-default-bind-options ssl-min-ver TLSv1.2 no-tls-tickets

defaults
        log     global
        mode    http
        option  httplog
        option  dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
        errorfile 400 /etc/haproxy/errors/400.http
        errorfile 403 /etc/haproxy/errors/403.http
        errorfile 408 /etc/haproxy/errors/408.http
        errorfile 500 /etc/haproxy/errors/500.http
        errorfile 502 /etc/haproxy/errors/502.http
        errorfile 503 /etc/haproxy/errors/503.http
        errorfile 504 /etc/haproxy/errors/504.http

        # self edition
        option forwardfor
        option http-server-close

#--synux.tech-params-begin--
backend synux.tech-backend
        balance roundrobin
        server 387934-web-01 100.26.173.10:80 check
        server 387934-web-02 18.235.243.212:80 check
frontend synux.tech-frontend
        bind *:80
        mode http
        default_backend synux.tech-backend
#--synux.tech-params-end--


frontend www-http
   bind *:80
   reqadd X-Forwarded-Proto:\ http
   default_backend www-backend

frontend www-https
   bind *:443 ssl crt /etc/haproxy/certs/example.com.pem
   reqadd X-Forwarded-Proto:\ https
   acl letsencrypt-acl path_beg /.well-known/acme-challenge/
   use_backend letsencrypt-backend if letsencrypt-acl
   default_backend www-backend

backend www-backend
   redirect scheme https if !{ ssl_fc }
   server 387934-web-01 100.26.173.10:80 check
   server 387934-web-02 18.235.243.212:80 check

backend letsencrypt-backend
   server letsencrypt 127.0.0.1:54321"
}

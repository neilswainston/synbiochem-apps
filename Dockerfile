FROM jwilder/nginx-proxy:alpine

RUN { \
      echo 'client_max_body_size 0; proxy_connect_timeout 3600; proxy_send_timeout 3600; proxy_read_timeout 3600; send_timeout 3600;'; \
    } > /etc/nginx/conf.d/unrestricted_client_body_size.conf
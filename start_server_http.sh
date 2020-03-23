#!/usr/bin/env bash
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)

rm -rf PartsGenie
git clone https://github.com/neilswainston/PartsGenie.git
cd PartsGenie
docker build -t partsgenie .
cd ..

rm -rf CombiGenie
git clone https://github.com/neilswainston/CombiGenie.git
cd CombiGenie
docker build -t combigenie .
cd ..

cd synbiochem-apps

docker build -t nginx-proxy-unrestricted .

docker run --name nginx-proxy-unrestricted -d -p 80:80 -p 443:443 -v /var/run/docker.sock:/tmp/docker.sock:ro \
    -v certs:/etc/nginx/certs:ro \
    -v /etc/nginx/vhost.d \
    -v /usr/share/nginx/html \
    --label com.github.jrcs.letsencrypt_nginx_proxy_companion.nginx_proxy=true \
    nginx-proxy-unrestricted

docker run --name partsgenie -d -p :5000 -e VIRTUAL_HOST=parts.synbiochem.co.uk partsgenie

docker run --name combigenie -d -p :5000 -e VIRTUAL_HOST=combi.synbiochem.co.uk combigenie

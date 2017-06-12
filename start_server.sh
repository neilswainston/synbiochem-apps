#!/usr/bin/env bash
git clone https://github.com/neilswainston/PartsGenie.git
cd PartsGenie
docker build -t partsgenie .
cd ..

git clone https://github.com/synbiochem/CodonGenie.git
cd CodonGenie
docker build -t codongenie .
cd ..

docker run --name nginx-proxy -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy
docker run --name partsgenie -d -p :5000 -e VIRTUAL_HOST=test1.synbiochem.co.uk partsgenie
docker run --name codongenie -d -p :5000 -e VIRTUAL_HOST=test2.synbiochem.co.uk codongenie
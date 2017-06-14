#!/usr/bin/env bash
rm -rf PartsGenie
git clone https://github.com/neilswainston/PartsGenie.git
cd PartsGenie
docker build -t partsgenie .
cd ..

rm -rf CodonGenie
git clone https://github.com/synbiochem/CodonGenie.git
cd CodonGenie
docker build -t codongenie .
cd ..

rm -rf DEbrief
git clone https://github.com/synbiochem/DEbrief.git
cd DEbrief
docker build -t debrief .
cd ..

docker run --name nginx-proxy -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy
docker run --name partsgenie -d -p :5000 -e VIRTUAL_HOST=parts.synbiochem.co.uk partsgenie
docker run --name codongenie -d -p :5000 -e VIRTUAL_HOST=codon.synbiochem.co.uk codongenie
docker run --name debrief -d -p :5000 -e VIRTUAL_HOST=debrief.synbiochem.co.uk debrief
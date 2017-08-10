#!/usr/bin/env bash
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)

rm -rf PathwayGenie
git clone https://github.com/synbiochem/PathwayGenie.git
cd PathwayGenie
docker build -t pathwaygenie .
cd ..

rm -rf CodonGenie
git clone https://github.com/synbiochem/CodonGenie.git
cd CodonGenie
docker build -t codongenie .
cd ..

rm -rf DEbrief
git clone https://github.com/dnaplusplus/DEbrief.git
cd DEbrief
docker build -t debrief .
cd ..

docker run --name nginx-proxy -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy
docker run --name pathwaygenie -d -p :5000 -e VIRTUAL_HOST=pathway.synbiochem.co.uk pathwaygenie
docker run --name codongenie -d -p :5000 -e VIRTUAL_HOST=codon.synbiochem.co.uk codongenie
docker run --name debrief -d -p :5000 -e VIRTUAL_HOST=debrief.synbiochem.co.uk debrief

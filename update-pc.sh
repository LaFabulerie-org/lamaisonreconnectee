#!/bin/bash

docker compose -f docker-compose-pc.yml stop
git pull origin master
git submodule foreach 'git pull origin master'
./build_pc.sh
docker compose -f docker-compose-pc.yml up -d

#!/bin/bash

docker compose -f docker-compose.yml down
git pull origin master
git submodule foreach 'git pull origin master'
./build_pc.sh
docker compose -f docker-compose.yml up -d

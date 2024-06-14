#!/bin/bash

docker compose -f docker-compose-pc.yml down
git pull origin main
git submodule foreach 'git pull origin main'
./build_pc.sh
docker compose -f docker-compose-pc.yml up -d

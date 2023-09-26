#!/bin/bash

docker-compose -f docker-compose-rasp.yml stop
docker container prune -f
git pull origin master
git submodule foreach 'git pull origin master'
docker-compose -f docker-compose-rasp.yml build
docker-compose -f docker-compose-rasp.yml up -d
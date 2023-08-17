#!/bin/bash

docker-compose -f docker-compose-pc.yml stop
git pull --recurse-submodules origin master
docker-compose -f docker-compose-pc.yml build
docker-compose -f docker-compose-pc.yml up -d
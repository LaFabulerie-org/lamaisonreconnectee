#!/bin/bash

docker build --build-arg="STAGE=web" -t mrc_backend mrc-backend
docker build --build-arg="STAGE=web" -t mrc_nginx mrc-nginx
docker build --build-arg="STAGE=web" -t mrc_frontend mrc-frontend

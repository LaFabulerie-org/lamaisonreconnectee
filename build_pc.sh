#!/bin/bash

docker build --build-arg="STAGE=standalone" -t mrc_backend mrc-backend
docker build --build-arg="STAGE=standalone" -t mrc_nginx mrc-nginx
docker build --build-arg="STAGE=standalone" -t mrc_frontend mrc-frontend

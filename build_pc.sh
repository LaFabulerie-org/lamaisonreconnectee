#!/bin/bash

docker build --build-arg="STAGE=standalone" -t mrc_backend:latest mrc-backend
docker build --build-arg="STAGE=standalone" -t mrc_printer:latest -f mrc-hardware/Dockerfile.printer mrc-hardware
docker build --build-arg="STAGE=standalone" -t mrc_nginx:latest mrc-nginx
docker build --build-arg="STAGE=standalone" -t mrc_frontend:latest mrc-frontend

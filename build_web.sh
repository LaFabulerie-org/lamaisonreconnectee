#!/bin/bash

BACK=0.32
FRONT=0.23
NGINX=0.7

docker build --build-arg="STAGE=web" -t mrc_web_backend:${BACK} mrc-backend
docker tag mrc_web_backend:${BACK} registry.gitlab.com/maison-reconnectee/mrc/mrc_web_backend:${BACK}
docker push registry.gitlab.com/maison-reconnectee/mrc/mrc_web_backend:${BACK}

docker build --build-arg="STAGE=web" -t mrc_web_frontend:${FRONT} mrc-frontend
docker tag mrc_web_frontend:${FRONT} registry.gitlab.com/maison-reconnectee/mrc/mrc_web_frontend:${FRONT}
docker push registry.gitlab.com/maison-reconnectee/mrc/mrc_web_frontend:${FRONT}

docker build --build-arg="STAGE=web" -t mrc_web_nginx:${NGINX} mrc-nginx
docker tag mrc_web_nginx:${NGINX} registry.gitlab.com/maison-reconnectee/mrc/mrc_web_nginx:${NGINX}
docker push registry.gitlab.com/maison-reconnectee/mrc/mrc_web_nginx:${NGINX}

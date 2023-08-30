FROM fholzer/nginx-brotli

ARG STAGE

RUN rm /etc/nginx/conf.d/default.conf
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./$STAGE/nginx.django.conf /etc/nginx/conf.d/django.conf
COPY ./$STAGE/nginx.angular.conf /etc/nginx/conf.d/angular.conf


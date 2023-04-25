#!/bin/sh
set -o allexport
source /.env
set +o allexport

envsubst  '${NGINX_SERVER_NAME},${NGINX_ROOT}' < /etc/nginx/conf.d/laravel.conf.template > /etc/nginx/conf.d/default.conf

nginx -g "daemon off;"
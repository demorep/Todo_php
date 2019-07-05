#!/bin/bash
sed -i "s/{{ APP_HOSTNAME }}/$APP_HOST/g" /etc/nginx/conf.d/default.conf
sed -i "s/{{ APP_PORT }}/$APP_PORT/g" /etc/nginx/conf.d/default.conf

nginx "-g" "daemon off;"

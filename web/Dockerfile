FROM nginx:1.10

ADD ./web/vhost.conf /etc/nginx/conf.d/default.conf

WORKDIR /var/www
# build from the parent directory

COPY ./src/ /var/www/

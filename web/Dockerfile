FROM nginx:1.10

COPY ./web/vhost.conf.tpl /etc/nginx/conf.d/default.conf
COPY ./web/docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh
WORKDIR /var/www
# build from the parent directory

COPY ./src/ /var/www/

CMD ["/docker-entrypoint.sh"]

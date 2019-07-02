FROM php:7-fpm as dependencies

COPY ./app/dependencies-install.sh /tmp/dependencies-install.sh
RUN bash /tmp/dependencies-install.sh
WORKDIR /var/www

FROM dependencies as install 

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#Build from the parent directory
COPY ./src/ /var/www/
RUN composer install 
RUN chmod -R 777 storage
RUN php artisan key:generate
#RUN php artisan migrate:refresh

FROM dependencies
COPY --from=install /var/www/ /var/www/


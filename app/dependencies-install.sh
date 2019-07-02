#!/bin/bash

set -x 

apt-get update && apt-get install -y libmcrypt-dev libssl-dev mysql-client git vim cron zip unzip \
    && pecl install mcrypt-1.0.2 && docker-php-ext-enable mcrypt && docker-php-ext-install pdo_mysql

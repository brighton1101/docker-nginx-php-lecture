# Image Name:Tag
FROM php:8.0.3-fpm-buster

# RUN: {valid shell command}
# - installing nginx
# - installing gettext
RUN apt-get update && apt-get install -y nginx && apt-get install -y gettext
RUN apt-get install -y git

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Create a place for the source code to live within our container
ENV APP_LOCATION=/home/laravel
RUN mkdir -p ${APP_LOCATION}
# COPY (host machine) (container)
COPY . ${APP_LOCATION}

# Install dependencies using Composer
WORKDIR ${APP_LOCATION}
RUN composer install
RUN php artisan key:generate


# Linux permissions commands
RUN chgrp -R www-data ${APP_LOCATION}
RUN chmod -R ug+rwx ${APP_LOCATION}

# Copy over nginx config
#  /etc/nginx/nginx.conf is standard for nginx
COPY nginx.conf.template /etc/nginx/nginx.conf.template

# Start nginx and php
CMD /bin/bash -c "envsubst '\$PORT' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf" && nginx && php-fpm


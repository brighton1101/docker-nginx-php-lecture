# Base image to be pulled from Dockerhub
# 
# php is the base name of the image and will
# pull from here: https://hub.docker.com/_/php
# 
# 8.0.3-fpm-buster is the image tag. We are using
# this image because we need a php cgi server to
# connect the http service to our laravel app.
# See here for more info on php-fpm:
# https://www.php.net/manual/en/install.fpm.php
FROM php:8.0.3-fpm-buster


# Because this is a Linux container (specifically,
# a Debian container) we can use the apt-get package
# manager to install nginx. You don't need to be super
# familiar with Linux - just know that this is
# downloading nginx for us.
RUN apt-get update && \
    apt-get install -y nginx


# Create a place for the src code to live within
# the container
ENV APP_LOCATION=/home/laravel
RUN mkdir -p ${APP_LOCATION}
COPY . ${APP_LOCATION}


# Filesystem permissions... I wouldn't worry
# about understanding this too much right now,
# just know you will get an error if you don't
# include this
RUN chgrp -R www-data ${APP_LOCATION}
RUN chmod -R ug+rwx ${APP_LOCATION}


# Copy over the nginx.conf file to confiugre
# nginx. It is important that our document
# root in nginx.conf matches ${APP_LOCATION}/public
COPY nginx.conf /etc/nginx/nginx.conf


# The default commands to run when the
# container starts. Nginx will run as a
# background process and php-fpm will run
# forever.
CMD nginx && php-fpm

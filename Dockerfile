FROM ubuntu:18.04

MAINTAINER Dolly Aswin <dolly.aswin@gmail.com>

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install php -y
RUN apt-get install php-{bcmath,curl,bz2,fpm,gd,intl,json,mbstring,mysql,opcache,xml,zip} -y
RUN apt-get -y install librabbitmq-dev
RUN apt-get -y install php-amqp
RUN apt-get remove apache2

# Nginx
RUN apt-get install nginx -y
RUN apt-get install nginx-extras

# Configure Nginx
RUN rm /etc/nginx/sites-enabled/default
RUN mkdir -p /var/www/dev/web-front-end
RUN mkdir -p /var/www/dev/api
ADD ./nginx/dev /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/dev /etc/nginx/sites-enabled/dev

CMD service php7.2-fpm start && nginx

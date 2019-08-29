FROM ubuntu:18.04

MAINTAINER Dolly Aswin <dolly.aswin@gmail.com>

ENV TZ=Asia/Jakarta
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update --fix-missing -y
RUN apt-get upgrade -y
RUN apt-get install rsync openssh-client curl zip unzip -y

RUN apt-get -y install software-properties-common
RUN add-apt-repository -y ppa:ondrej/nginx
RUN add-apt-repository -y ppa:ondrej/php
RUN apt-get update
RUN apt-get -y install php7.3
RUN apt-get -y install php7.3-fpm

RUN apt-get install -y \
    php7.3-gd \
    php7.3-intl \
    php7.3-mysql \
    php7.3-mbstring \
    php7.3-xml \
    php7.3-curl \
    php7.3-common \
    php7.3-cli \
    php7.3-bcmath \
    php7.3-zip 

# Install PHP 7.3 Redis
RUN apt-get install -y php7.3-redis

# Install PHP RabbitMQ
RUN apt-get -y install librabbitmq-dev
RUN apt-get -y install php-amqp

RUN apt-get -y install git
RUN sed -i -e "s/;\?daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.3/fpm/php-fpm.conf 

# Nginx
RUN apt-get install nginx -y
#RUN apt-get install nginx-extras -y
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

# Configure Nginx
RUN rm /etc/nginx/sites-enabled/default
RUN mkdir -p /var/www/dev/web-front-end/current
RUN mkdir -p /var/www/dev/api/current
ADD ./nginx/dev /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/dev /etc/nginx/sites-enabled/dev

CMD service php7.3-fpm start && nginx
#EXPOSE 9000
#CMD ["php-fpm"]

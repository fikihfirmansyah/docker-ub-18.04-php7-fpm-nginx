FROM ubuntu:18.04
ENV  APPPATH=/var/www/dev
WORKDIR ${APPPATH}

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
RUN apt-get -y install php7.4
RUN apt-get -y install php7.4-fpm

RUN apt-get install -y \
    php7.4-gd \
    php7.4-intl \
    php7.4-mysql \
    php7.4-pgsql \
    php7.4-mbstring \
    php7.4-xml \
    php7.4-curl \
    php7.4-common \
    php7.4-cli \
    php7.4-bcmath \
    php7.4-zip \
    php-igbinary

# Install PHP 7.4 Redis
RUN apt-get install -y php7.4-redis

# Install PHP RabbitMQ
RUN apt-get -y install libssl-dev
RUN apt-get -y install libsodium-dev
RUN apt-get -y install librabbitmq-dev
RUN apt-get -y install php-zmq
RUN apt-get -y install php-amqp

RUN apt-get -y install git
RUN apt-get -y install vim
RUN sed -i -e "s/;\?daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.4/fpm/php-fpm.conf 

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

CMD service php7.4-fpm start && nginx
#EXPOSE 9000
#CMD ["php-fpm"]

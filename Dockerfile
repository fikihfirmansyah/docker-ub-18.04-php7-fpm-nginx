FROM ubuntu:18.04

MAINTAINER Dolly Aswin <dolly.aswin@gmail.com>

ENV TZ=Asia/Jakarta
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install rsync openssh-client curl zip unzip -y
RUN apt-get install php-fpm -y
RUN apt-get install php-bcmath \
    php-curl \
    php-bz2 \
    php-gd \
    php-intl \
    php-json \
    php-mbstring \
    php-mysql \
    php-opcache \
    php-xml \
    php-redis \
    php-zip -y
RUN apt-get -y install librabbitmq-dev
RUN apt-get -y install php-amqp
RUN sed -i -e "s/;\?daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.2/fpm/php-fpm.conf 

# Nginx
RUN apt-get install nginx -y
#RUN apt-get install nginx-extras -y
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

# Configure Nginx
RUN rm /etc/nginx/sites-enabled/default
RUN mkdir -p /var/www/dev/web-front-end
RUN mkdir -p /var/www/dev/api
ADD ./nginx/dev /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/dev /etc/nginx/sites-enabled/dev

CMD service php7.2-fpm start && nginx
#EXPOSE 9000
#CMD ["php-fpm"]

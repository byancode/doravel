FROM fedora:35

WORKDIR /var/www

RUN dnf -y update
RUN dnf -y upgrade --refresh
RUN dnf -y install dnf-plugins-core
RUN dnf -y install \
    http://rpms.remirepo.net/fedora/remi-release-$(rpm -E %fedora).rpm

RUN dnf -y install \
    supervisor \
    openssl \
    cronie \
    expect \
    unzip \
    spawn \
    wget \
    git \
    jq

RUN dnf config-manager --set-enabled remi
RUN dnf module reset php

ARG PHP_VERSION=8.1
RUN dnf -y module install php:remi-${PHP_VERSION}
RUN dnf -y install \
    php \
    php-gd \
    php-cli \
    php-zip \
    php-fpm \
    php-intl \
    php-devel \
    php-pgsql \
    php-mcrypt \
    php-mysqlnd \
    php-mbstring \
    php-memcache \
    php-imagick \
    php-opcache \
    php-swoole \
    php-bcmath \
    php-xdebug \
    php-xmlrpc \
    php-redis \
    php-curl \
    php-pear \
    php-json

RUN dnf -y module enable nginx:mainline
RUN dnf -y install nginx

RUN dnf clean all

RUN wget https://getcomposer.org/composer-stable.phar -O /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer

RUN mkdir -p /var/soketi

ARG NVM_VERSION=0.39.1
ARG NODE_VERSION="--lts"

RUN curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash
RUN source /root/.bashrc && \
    nvm install $(echo $NODE_VERSION) && \
    npm install -g @soketi/soketi && \
    npm install -g yarn

COPY ./config/blacklist.ini /etc/php.d/opcache-default.blacklist
COPY ./config/supervisord.conf /etc/supervisord.conf
COPY ./config/soketi.json /var/soketi/config.json
COPY ./config/opcache.ini /etc/php.d/opcache.ini
COPY ./config/sancert.cnf /etc/ssl/sancert.cnf
COPY ./services/ /var/config/

COPY ./run/git-pull /git-pull
COPY ./run/deploy   /deploy
COPY ./run/start    /start

RUN chmod +x /git-pull
RUN chmod +x /deploy
RUN chmod +x /start

RUN sed -e 's/listen.allowed_clients/;listen.allowed_clients/' -i /etc/php-fpm.d/www.conf
RUN sed -e 's/listen.acl_users/;listen.acl_users/' -i /etc/php-fpm.d/www.conf
RUN sed -e 's/listen =.*/listen = 0.0.0.0:9000/' -i /etc/php-fpm.d/www.conf

COPY ./nginx/mime.types /etc/nginx/mime.types
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

RUN rm -f /etc/nginx/conf.d/php-fpm.conf

COPY ./nginx/conf.d/    /etc/nginx/conf.d/
COPY ./nginx/sites/     /etc/nginx/sites-available/

RUN mkdir /run/php-fpm

COPY ./www /var/www

EXPOSE 80
EXPOSE 90
EXPOSE 443
EXPOSE 444
EXPOSE 6002
EXPOSE 8000
EXPOSE 9000

ENTRYPOINT ["/start"]
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

ENV PHP_UPLOAD_MAX_FILESIZE=1G
ENV PHP_MAX_EXECUTION_TIME=600
ENV PHP_MEMORY_LIMIT=512M
ENV PHP_POST_MAX_SIZE=8M

RUN sed -e 's/upload_max_filesize =.*/upload_max_filesize='$PHP_UPLOAD_MAX_FILESIZE'/' -i /etc/php.ini
RUN sed -e 's/max_execution_time =.*/max_execution_time='$PHP_MAX_EXECUTION_TIME'/' -i /etc/php.ini
RUN sed -e 's/post_max_size =.*/post_max_size='$PHP_POST_MAX_SIZE'/' -i /etc/php.ini
RUN sed -e 's/memory_limit =.*/memory_limit='$PHP_MEMORY_LIMIT'/' -i /etc/php.ini

COPY ./config/opcache.blacklist /etc/php.d/opcache-default.blacklist
COPY ./config/supervisord.conf /etc/supervisord.conf
COPY ./config/soketi.json /var/soketi/config.json
COPY ./config/opcache.ini /etc/php.d/opcache.ini
COPY ./config/sancert.cnf /etc/ssl/sancert.cnf

COPY ./config/doravel-schedule.conf /var/config/doravel-schedule.conf
COPY ./config/doravel-deploy.conf /var/config/doravel-deploy.conf
COPY ./config/doravel-octane.conf /var/config/doravel-octane.conf
COPY ./config/doravel-soketi.conf /var/config/doravel-soketi.conf
COPY ./config/doravel-nginx.conf /var/config/doravel-nginx.conf
COPY ./config/doravel-fpm.conf /var/config/doravel-fpm.conf

COPY ./git-pull /git-pull
COPY ./deploy /deploy
COPY ./start /start

ENV OPCACHE_ENABLE=1
RUN OPCACHE_FILE=$(find /etc/php.d -name '*-opcache.ini') && \
    cp -f /etc/php.d/opcache.ini $OPCACHE_FILE && \
    sed -e 's/opcache.enable=.*/opcache.enable='$OPCACHE_ENABLE'/' -i $OPCACHE_FILE && \
    sed -e 's/opcache.enable_cli=.*/opcache.enable_cli='$OPCACHE_ENABLE'/' -i $OPCACHE_FILE

RUN chmod +x /git-pull
RUN chmod +x /deploy
RUN chmod +x /start

RUN sed -e 's/listen.allowed_clients/;listen.allowed_clients/' -i /etc/php-fpm.d/www.conf
RUN sed -e 's/listen.acl_users/;listen.acl_users/' -i /etc/php-fpm.d/www.conf
RUN sed -e 's/listen =.*/listen = 0.0.0.0:9000/' -i /etc/php-fpm.d/www.conf

COPY ./nginx/mime.types /etc/nginx/mime.types
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

COPY ./nginx/sites/fpm.conf /etc/nginx/sites-available/fpm.conf
COPY ./nginx/conf.d/upstream.conf /etc/nginx/conf.d/upstream.conf
COPY ./nginx/sites/site.conf /etc/nginx/sites-available/site.conf
COPY ./nginx/sites/soketi.conf /etc/nginx/sites-available/soketi.conf
COPY ./nginx/sites/ssl-fpm.conf /etc/nginx/sites-available/ssl-fpm.conf
COPY ./nginx/sites/ssl-site.conf /etc/nginx/sites-available/ssl-site.conf
COPY ./nginx/sites/ssl-soketi.conf /etc/nginx/sites-available/ssl-soketi.conf

RUN rm -f /etc/nginx/conf.d/php-fpm.conf
RUN mkdir /run/php-fpm

ENV GIT_NAME="Byancode"
ENV GIT_EMAIL="byancode@gmail.com"

RUN git config --global user.name "$GIT_NAME"
RUN git config --global user.email "$GIT_EMAIL"

COPY ./www /var/www

EXPOSE 80
EXPOSE 90
EXPOSE 443
EXPOSE 444
EXPOSE 6002
EXPOSE 8000
EXPOSE 9000

ENTRYPOINT ["/start"]
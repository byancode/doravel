FROM fedora:35
# TODO - cambiar de fedora a alpine

WORKDIR /var/www

RUN dnf -y update && \
    dnf -y upgrade --refresh && \
    dnf -y install dnf-plugins-core && \
    dnf -y install http://rpms.remirepo.net/fedora/remi-release-$(rpm -E %fedora).rpm && \
    dnf -y install \
    supervisor \
    openssl \
    cronie \
    expect \
    unzip \
    spawn \
    wget \
    git \
    jq

ARG PHP_VERSION=8.2
RUN dnf config-manager --set-enabled remi && \
    dnf module reset php && \
    dnf -y module install php:remi-${PHP_VERSION} &&\
    dnf -y install \
    php \
    php-gd \
    php-cli \
    php-zip \
    php-fpm \
    php-intl \
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
    php-json && \
    dnf -y module enable nginx:mainline && \
    dnf -y install nginx && \
    dnf clean all

ARG NVM_VERSION=0.39.3
ARG NODE_VERSION="--lts"

RUN wget https://getcomposer.org/composer-stable.phar -O /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer && \
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash && \
    source /root/.bashrc && \
    nvm install $(echo $NODE_VERSION) && \
    npm install -g yarn

COPY ./config/opcache.blacklist /etc/php.d/opcache.blacklist
COPY ./config/supervisord.conf /etc/supervisord.conf
COPY ./config/opcache.ini /etc/php.d/opcache.ini
COPY ./config/sancert.cnf /etc/ssl/sancert.cnf
COPY ./services/ /var/config/

COPY ./run /xbin

COPY ./nginx/mime.types /etc/nginx/mime.types
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

COPY ./nginx/conf.d/    /etc/nginx/conf.d/
COPY ./nginx/sites/     /etc/nginx/sites-available/

RUN chmod +x /xbin/* && \
    sed -e 's/listen.allowed_clients/;listen.allowed_clients/' -i /etc/php-fpm.d/www.conf && \
    sed -e 's/listen.acl_users/;listen.acl_users/' -i /etc/php-fpm.d/www.conf && \
    sed -e 's/listen =.*/listen = 0.0.0.0:9000/' -i /etc/php-fpm.d/www.conf && \
    rm -f /etc/nginx/conf.d/php-fpm.conf && \
    mkdir /run/php-fpm

EXPOSE 80
EXPOSE 90
EXPOSE 443
EXPOSE 444
EXPOSE 6002
EXPOSE 8000
EXPOSE 9000

CMD ["/xbin/start"]
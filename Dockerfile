FROM byancode/php:8.1


WORKDIR /var/www


ENV ETC_PATH=/usr/local/etc \
    PHP_FPM_FILE=${ETC_PATH}/php-fpm.d/www.conf


RUN apk update; \
    apk add --no-cache \
        supervisor \
        expect \
        nodejs \
        nginx \
        npm \
        git \
        jq \
    ; \
    apk cache clean; \
    \
    curl -o /usr/local/bin/composer https://getcomposer.org/composer-stable.phar; \
    chmod +x /usr/local/bin/composer; \
    \
    mv "${PHP_FPM_FILE}.default" "${PHP_FPM_FILE}"; \
    sed -e 's/listen.allowed_clients/;listen.allowed_clients/' -i $PHP_FPM_FILE; \
    sed -e 's/listen.acl_users/;listen.acl_users/' -i $PHP_FPM_FILE; \
    sed -e 's/listen =.*/listen = 0.0.0.0:9000/' -i $PHP_FPM_FILE;


COPY ./data/php/conf.d/* ${ETC_PATH}/php/conf.d/
COPY ./data/supervisor/* ${ETC_PATH}/
COPY ./data/services/* /var/services/
COPY ./data/scripts/* /usr/local/bin/
COPY ./data/nginx/ /etc/nginx/
COPY ./data/ssl/* /etc/ssl/


EXPOSE 80
EXPOSE 90
EXPOSE 443
EXPOSE 444


CMD ["doravel-start"]
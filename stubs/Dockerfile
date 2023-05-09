FROM byancode/doravel:php-8.1

ENV GIT_EMAIL='__GIT_EMAIL__' \
    GIT_NAME='__GIT_NAME__' \
    GIT_AUTO_PULL=false \
    # Laravel
    LARAVEL_AUTO_SCHEDULE=true \
    # PHP
    PHP_OPCACHE_ENABLE=true \
    PHP_UPLOAD_MAX_FILESIZE=1G \
    PHP_MAX_EXECUTION_TIME=60 \
    PHP_POST_MAX_SIZE=1G \
    PHP_MEMORY_LIMIT=512M \
    # NPM
    NPM_AUTO_INSTALL=false \
    NPM_AUTO_BUILD=false \
    # Env
    APP_ENV=prod

COPY . /var/www
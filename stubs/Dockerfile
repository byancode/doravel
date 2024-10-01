FROM byancode/doravel:1.0.0

ENV APP_ENV=local

RUN set -eux; \
    apk add --no-cache \
        libuv \
    ; \
    builder \
    # packages are removed after installation
    # https://pkgs.alpinelinux.org/packages
    --add-pkg "coreutils" \
    --add-pkg "gmp-dev" \
    --add-pkg "gcc" \
    # https://github.com/composer/composer/tags
    --composer "2.7.9" \
    # https://nginx.org/en/download.html
    --nginx "1.27.1" \
    # https://github.com/PCRE2Project/pcre2/tags
    --pcre2 "10.43" \
    # https://github.com/madler/zlib/tags
    --zlib "1.3.1" \
    # https://github.com/libgd/libgd/tags
    --libgd "2.3.3" \
    # https://github.com/openssl/openssl/tags
    --openssl "3.3.0" \
    # https://nginx.org/en/docs/configure.html
    --nginx-with "openssl=/tmp/openssl" \
    --nginx-with "pcre=/tmp/pcre2" \
    --nginx-with "zlib=/tmp/zlib" \
    --nginx-with "pcre-jit" \
    --nginx-with "stream" \
    --nginx-with "threads" \
    --nginx-with "poll_module" \
    --nginx-with "select_module" \
    --nginx-with "http_ssl_module" \
    --nginx-with "stream_ssl_module" \
    --nginx-with "http_slice_module" \
    --nginx-with "http_gunzip_module" \
    --nginx-with "http_image_filter_module" \
    --nginx-without "http_grpc_module" \
    # https://unofficial-builds.nodejs.org/download/release/
    --node "22.2.0" \
    # https://github.com/php/php-src/tags
    --php "8.3.12" \
    # PHP WITH
	--php-with "mhash" \
	--php-with "mhash" \
	--php-with "pear" \
	--php-with "pic" \
	--php-with "sodium=shared" \
	--php-with "password-argon2" \
	--php-with "pdo-sqlite=/usr" \
	--php-with "pdo-mysql=mysqlnd" \
	--php-with "pdo-pgsql" \
	--php-with "sqlite3=/usr" \
	--php-with "iconv=/usr" \
	--php-with "readline" \
	--php-with "openssl" \
	--php-with "curl" \
	--php-with "zlib" \
	--php-with "bz2=/usr" \
	--php-with "zip" \
	--php-with "avif" \
	--php-with "webp" \
	--php-with "jpeg" \
    # PHP ENABLE
	--php-enable "mbstring" \
	--php-enable "mysqlnd" \
	--php-enable "session" \
	--php-enable "phpdbg" \
	--php-enable "ctype" \
	--php-enable "phar" \
	--php-enable "pdo" \
	--php-enable "gd" \
	--php-enable "fpm" \
	--php-enable "ftp" \
	--php-enable "exif" \
	--php-enable "intl" \
	--php-enable "pcntl" \
	--php-enable "shmop" \
	--php-enable "bcmath" \
	--php-enable "opcache" \
	--php-enable "sockets" \
	--php-enable "fileinfo" \
	--php-enable "tokenizer" \
	--php-enable "short-tags" \
	--php-enable "opcache-jit" \
	--php-enable "phpdbg-readline" \
	--php-enable "option-checking=fatal" \
    # https://pecl.php.net/package/swoole
    --php-extension "swoole=5.1.1" \
    # https://pecl.php.net/package/redis
    --php-extension "redis=6.0.2" \
    # https://pecl.php.net/package/uv
    --php-extension "uv=0.3.0" \
;

# COPY . /var/www
FROM alpine:3.17

# dependencies required for running "phpize"
# these get automatically installed and removed by "docker-php-ext-*" (unless they're already installed)
ENV PHPIZE_DEPS \
		autoconf \
		dpkg-dev dpkg \
		file \
		g++ \
		gcc \
		libc-dev \
		make \
		pkgconf \
		re2c

ENV ETC_PATH=/usr/local/etc
ENV PHP_INI_DIR=${ETC_PATH}/php
# Apply stack smash protection to functions using local buffers and alloca()
# Make PHP's main executable position-independent (improves ASLR security mechanism, and has no performance impact on x86_64)
# Enable optimization (-O2)
# Enable linker optimization (this sorts the hash buckets to improve cache locality, and is non-default)
# https://github.com/docker-library/php/issues/272
# -D_LARGEFILE_SOURCE and -D_FILE_OFFSET_BITS=64 (https://www.php.net/manual/en/intro.filesystem.php)
ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
ENV PHP_CPPFLAGS="$PHP_CFLAGS"
ENV PHP_LDFLAGS="-Wl,-O1 -pie"

ARG PHP_VERSION=8.2.2
ENV PHP_URL="https://www.php.net/distributions/php-${PHP_VERSION}.tar.xz" \
    PHP_BINARY_FILE="/binaries/php-${PHP_VERSION}.tar.xz"

COPY ./data/php/conf.d/* ${ETC_PATH}/php/conf.d/
COPY ./data/php/composer /usr/local/bin/composer
COPY ./data/supervisor/* ${ETC_PATH}/
COPY ./data/services/* /var/services/
COPY ./data/scripts/* /usr/local/bin/
COPY ./data/docker/* /usr/local/bin/
COPY ./data/php/binaries/ /binaries/
COPY ./data/nginx/ /etc/nginx/
COPY ./data/ssl/* /etc/ssl/


RUN apk add --no-cache \
		ca-certificates \
        supervisor \
		openssl \
        nodejs \
        expect \
        nginx \
		curl \
        npm \
        git \
		tar \
		xz \
        jq \
    ; \
    \
    set -eux; \
    mkdir -p "$PHP_INI_DIR/conf.d"; \
    \
	apk add --no-cache --virtual .fetch-deps gnupg; \
	\
	mkdir -p /usr/src; \
	cd /usr/src; \
	\
    if [ -f "${PHP_BINARY_FILE}" ]; then \
        cp   ${PHP_BINARY_FILE} /usr/src/php.tar.xz; \
        rm -Rf /binaries; \
    else \
	    docker-php-download; \
    fi; \
	\
	apk del --no-network .fetch-deps; \
    \
    set -eux; \
	apk add --no-cache --virtual .build-deps \
		$PHPIZE_DEPS \
		argon2-dev \
		coreutils \
		curl-dev \
		openssl-dev \
		gnu-libiconv-dev \
		libsodium-dev \
		libxml2-dev \
		linux-headers \
		oniguruma-dev \
		readline-dev \
        libzip-dev \
		sqlite-dev \
        # install icu-uc icu-io icu-i18n
        icu-dev \
		zlib-dev \
		pcre-dev \
	; \
    \
    rm -vf /usr/include/iconv.h; \
    \
    export \
		CFLAGS="$PHP_CFLAGS" \
		CPPFLAGS="$PHP_CPPFLAGS" \
		LDFLAGS="$PHP_LDFLAGS" \
	; \
	docker-php-source extract; \
    cd /usr/src/php; \
	gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
	./configure \
		--build="$gnuArch" \
		--with-config-file-path="$PHP_INI_DIR" \
		--with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
# make sure invalid --configure-flags are fatal errors instead of just warnings
		--enable-option-checking=fatal \
# https://github.com/docker-library/php/issues/439
		--with-mhash \
# https://github.com/docker-library/php/issues/822
		--with-pic \
# --enable-mbstring is included here because otherwise there's no way to get pecl to use it properly (see https://github.com/docker-library/php/issues/195)
		--enable-mbstring \
# --enable-mysqlnd is included here because it's harder to compile after the fact than extensions are (since it's a plugin for several extensions, not an extension in itself)
		--enable-mysqlnd \
# https://wiki.php.net/rfc/argon2_password_hash
		--with-password-argon2 \
# https://wiki.php.net/rfc/libsodium
		--with-sodium=shared \
# always build against system sqlite3 (https://github.com/php/php-src/commit/6083a387a81dbbd66d6316a3a12a63f06d5f7109)
		--with-pdo-sqlite=/usr \
		--with-sqlite3=/usr \
		--with-iconv=/usr \
		--with-readline \
		--with-openssl \
		--with-curl \
		--with-zlib \
		--with-zip \
# https://github.com/docker-library/php/pull/1259
		--enable-session \
		--enable-phpdbg \
		--enable-ctype \
		--enable-phar \
		--enable-pdo \
#		--enable-fpm \
		--enable-intl \
		--enable-bcmath \
		--enable-opcache \
		--enable-sockets \
		--enable-fileinfo \
		--enable-tokenizer \
		--enable-short-tags \
		--enable-opcache-jit \
		--enable-phpdbg-readline \
# in PHP 7.4+, the pecl/pear installers are officially deprecated (requiring an explicit "--with-pear")
		--with-pear \
# bundled pcre does not support JIT on s390x
# https://manpages.debian.org/bullseye/libpcre3-dev/pcrejit.3.en.html#AVAILABILITY_OF_JIT_SUPPORT
		$(test "$gnuArch" = 's390x-linux-musl' && echo '--without-pcre-jit') \
	; \
	make -j "$(nproc)"; \
	find -type f -name '*.a' -delete; \
	make install; \
	find \
		/usr/local \
		-type f \
		-perm '/0111' \
		-exec sh -euxc ' \
			strip --strip-all "$@" || : \
		' -- '{}' + \
	; \
	make clean; \
# https://github.com/docker-library/php/issues/692 (copy default example "php.ini" files somewhere easily discoverable)
	cp -v php.ini-* "$PHP_INI_DIR/"; \
    cp -v php.ini-production "$PHP_INI_DIR/php.ini"; \
    cd /; \
	docker-php-source delete; \
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --no-cache $runDeps; \
    \
    pecl update-channels; \
    \
    docker-pecl-install xdebug --zend;  \
    docker-swoole-install; \
    docker-pecl-install redis; \
	rm -rf /tmp/pear ~/.pearrc; \
    \
    docker-php-ext-enable \
        opcache \
        sodium \
    ; \
    apk del --no-network .build-deps; \
    rm -f /usr/src/php.tar.xz; \
	php --version;

WORKDIR /var/www

EXPOSE 80
EXPOSE 443
EXPOSE 8000

CMD ["doravel-start"]

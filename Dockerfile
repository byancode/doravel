FROM alpine:3.20

ENV ETC_PATH=/usr/local/etc
ENV PHP_INI_DIR=${ETC_PATH}/php
ENV DOCKER_CONTAINER=1

# Apply stack smash protection to functions using local buffers and alloca()
# Make PHP's main executable position-independent (improves ASLR security mechanism, and has no performance impact on x86_64)
# Enable optimization (-O2)
# Enable linker optimization (this sorts the hash buckets to improve cache locality, and is non-default)
# https://github.com/docker-library/php/issues/272
# -D_LARGEFILE_SOURCE and -D_FILE_OFFSET_BITS=64 (https://www.php.net/manual/en/intro.filesystem.php)
ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
ENV PHP_CPPFLAGS="$PHP_CFLAGS"
ENV PHP_LDFLAGS="-Wl,-O1 -pie"

ARG UV_VERSION=0.3.0
ARG GUM_VERSION=0.14.4
ARG PHP_VERSION=8.2.2
ARG SSH2_VERSION=1.4.1
ARG NODE_VERSION=22.2.0
ARG REDIS_VERSION=6.0.2
ARG SWOOLE_VERSION=5.1.1

ENV PHP_URL="https://www.php.net/distributions/php-${PHP_VERSION}.tar.xz"
ENV PHP_BINARY_FILE="${PHP_INI_DIR}/binaries/php-${PHP_VERSION}.tar.xz"

COPY ./docker/php/* ${ETC_PATH}/php/
COPY ./docker/supervisor/* ${ETC_PATH}/
COPY ./docker/bin/* /usr/local/bin/
COPY ./docker/nginx/ /etc/nginx/
COPY ./docker/ssl/* /etc/ssl/


RUN apk add --no-cache \
		ca-certificates \
		inotify-tools \
        supervisor \
		openssl \
        expect \
		docker \
        nginx \
		bash \
		htop \
		curl \
        git \
		tar \
		xz \
        jq \
        yq \
    ; \
    \
	apk add --no-cache --virtual .fnm-deps libstdc++ libgcc; \
	export SHELL="/bin/ash"; \
    curl -fsSL "https://vanaware.github.io/fnm-alpine/install.sh" | sh; \
	\
	/root/.local/share/fnm/fnm install $NODE_VERSION; \
	/root/.local/share/fnm/fnm default $NODE_VERSION; \
	\
	apk del --no-network .fnm-deps; \
    set -eux; \
    mkdir -p "$PHP_INI_DIR/conf.d"; \
    \
	curl -fsSL "https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}/gum_${GUM_VERSION}_x86_64.apk" -o /tmp/gum.apk; \
	apk add --no-cache --allow-untrusted /tmp/gum.apk; \
	rm -f /tmp/gum.apk; \
	\
	apk add --no-cache --virtual .fetch-deps gnupg; \
	\
	mkdir -p /usr/src; \
	cd /usr/src; \
	\
    if [ -f "${PHP_BINARY_FILE}" ]; then \
        cp  "${PHP_BINARY_FILE}" /usr/src/php.tar.xz; \
        rm -Rf "${PHP_INI_DIR}/binaries"; \
    else \
	    docker-php-download; \
    fi; \
	\
	apk del --no-network .fetch-deps; \
    \
    set -eux; \
	apk add --no-cache --virtual .build-deps \
		argon2-dev \
		build-base \
		coreutils \
		curl-dev \
		libpng-dev \
		libxslt-dev \
		openssl-dev \
		libedit-dev \
		bzip2-dev \
		libjpeg-turbo-dev \
		gnu-libiconv-dev \
		postgresql-dev \
		libsodium-dev \
		libxml2-dev \
		linux-headers \
		oniguruma-dev \
		readline-dev \
        libzip-dev \
		sqlite-dev \
		icu-data-full \
		mysql-dev \
        icu-dev \
		zlib-dev \
		pcre-dev \
		autoconf \
		libc-dev \
		dpkg-dev \
		pkgconf \
		gd-dev \
		bison \
		dpkg \
		file \
		make \
		re2c \
		g++ \
		gcc \
	; \
    \
    rm -vf /usr/include/iconv.h; \
    \
    export \
		CPPFLAGS="$PHP_CPPFLAGS" \
		LDFLAGS="$PHP_LDFLAGS" \
		CFLAGS="$PHP_CFLAGS" \
	; \
	docker-php-source extract; \
    cd /usr/src/php; \
	gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
	./configure \
		--build="$gnuArch" \
		--with-config-file-path="$PHP_INI_DIR" \
		--with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
		--enable-option-checking=fatal \
		--with-mhash \
		--with-pic \
		--enable-mbstring \
		--enable-mysqlnd \
		--with-password-argon2 \
		--with-sodium=shared \
		--with-pdo-sqlite=/usr \
		--with-pdo-mysql=mysqlnd \
		--with-pdo-pgsql \
		--with-sqlite3=/usr \
		--with-iconv=/usr \
		--with-readline \
		--with-openssl \
		--with-curl \
		--with-zlib \
		--with-bz2=/usr \
		--with-zip \
		--with-avif \
		--with-webp \
		--with-jpeg \
		--enable-session \
		--enable-phpdbg \
		--enable-ctype \
		--enable-phar \
		--enable-pdo \
		--enable-gd \
#		--enable-fpm \
		--enable-ftp \
		--enable-exif \
		--enable-intl \
		--enable-pcntl \
		--enable-shmop \
		--enable-bcmath \
		--enable-opcache \
		--enable-sockets \
		--enable-fileinfo \
		--enable-tokenizer \
		--enable-short-tags \
		--enable-opcache-jit \
		--enable-phpdbg-readline \
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
    docker-pecl-build swoole ${SWOOLE_VERSION}; \
    docker-pecl-build redis ${REDIS_VERSION}; \
    docker-pecl-build ssh2 ${SSH2_VERSION}; \
    docker-pecl-build uv ${UV_VERSION}; \
	rm -rf /tmp/pear ~/.pearrc; \
    \
    docker-php-ext-enable \
        opcache \
        sodium \
    ; \
    apk del --no-network .build-deps; \
    rm -f /usr/src/php.tar.xz;

WORKDIR /var/www

EXPOSE 80
EXPOSE 443
EXPOSE 5173
EXPOSE 8000

CMD ["doravel-start"]
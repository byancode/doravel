FROM alpine:3.20

ENV DOCKER_CONTAINER=1

ARG UV_VERSION=0.3.0
ARG GUM_VERSION=0.14.4
ARG PHP_VERSION=8.2.2
ARG SSH2_VERSION=1.4.1
ARG NODE_VERSION=22.2.0
ARG REDIS_VERSION=6.0.2
ARG SWOOLE_VERSION=5.1.1

COPY docker/bin/* /usr/local/bin/
COPY .doravel/* /root/.doravel/
COPY docker/php/* /tmp/php/
COPY bin/* /usr/local/bin/

RUN export SHELL="/bin/ash"; \
	set -eux;\
	\
	apk add --no-cache \
		ca-certificates \
		inotify-tools \
        supervisor \
		openssl \
        expect \
		docker \
        nginx \
        nano \
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
	apk add --no-cache --virtual .build-deps \
		argon2-dev \
		build-base \
		coreutils \
		curl-dev \
		bzip2-dev \
		libpng-dev \
		libxslt-dev \
		openssl-dev \
		libedit-dev \
		libjpeg-turbo-dev \
		gnu-libiconv-dev \
		postgresql-dev \
		libsodium-dev \
		libxml2-dev \
		linux-headers \
		icu-data-full \
		oniguruma-dev \
		readline-dev \
        libzip-dev \
		sqlite-dev \
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
		gnupg \
		libgcc \
		libstdc++ \
	; \
	\
    curl -fsSL "https://vanaware.github.io/fnm-alpine/install.sh" | sh; \
	\
	/root/.local/share/fnm/fnm install $NODE_VERSION; \
	/root/.local/share/fnm/fnm default $NODE_VERSION; \
    \
	curl -fsSL "https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}/gum_${GUM_VERSION}_x86_64.apk" -o /tmp/gum.apk; \
	\
	apk add --no-cache --allow-untrusted /tmp/gum.apk; \
	\
	mkdir -p /usr/src; \
	cd /usr/src; \
	\
    cp "/tmp/php/binaries/php-${PHP_VERSION}.tar.xz" /usr/src/php.tar.xz; \
    \
	tar -Jxf /usr/src/php.tar.xz -C /usr/src/php --strip-components=1; \
    cd /usr/src/php; \
	\
	gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
	\
	./configure \
		--build="$gnuArch" \
		--enable-option-checking=fatal \
		--with-config-file-path="/root/.doravel/php" \
		--with-config-file-scan-dir="/root/.doravel/php/conf.d" \
		--with-mhash \
		--with-pear \
		--with-pic \
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
		--enable-mbstring \
		--enable-mysqlnd \
		--enable-session \
		--enable-phpdbg \
		--enable-ctype \
		--enable-phar \
		--enable-pdo \
		--enable-gd \
		--enable-fpm \
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
    \
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --no-cache $runDeps; \
    \
    php-build-extension swoole ${SWOOLE_VERSION}; \
    php-build-extension redis ${REDIS_VERSION}; \
    php-build-extension ssh2 ${SSH2_VERSION}; \
    php-build-extension uv ${UV_VERSION}; \
	\
    apk del --no-network .build-deps; \
    rm -vf /usr/include/iconv.h; \
    rm -f  /usr/src/php.tar.xz; \
	rm -rf /root/.pearrc; \
	rm -rf /usr/src/php; \
	rm -rf /tmp/*;

WORKDIR /var/www

EXPOSE 8000
EXPOSE 9000
EXPOSE 5173
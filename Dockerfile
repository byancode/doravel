FROM alpine:3.20

ENV APP_ENV=local
ENV DORAVEL_ISOLATED=0
ENV DORAVEL_INSTALLED=0
ENV DORAVEL_CONTAINER=1

ENV SHELL=/bin/ash
ENV ENV=/root/.ashrc
ENV TERM=xterm-256color


ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
ENV PHP_CPPFLAGS="$PHP_CFLAGS"
ENV PHP_LDFLAGS="-Wl,-O1 -pie"

ARG GUM_VERSION=0.14.4

WORKDIR /var/www

COPY docker/supervisor/ /etc/supervisor/
COPY docker/functions/* /usr/local/bin/
COPY docker/doravel/* /usr/doravel/bin/
COPY docker/bin/* /usr/local/bin/
COPY .planning/ /root/.planning/
COPY .doravel/ /root/.doravel/
COPY .vscode/ /root/.vscode/
COPY .flows/ /root/.flows/
COPY bin/* /usr/local/bin/
COPY stubs/ /root/.stubs/
COPY docker/root/* /root/

RUN apk add --no-cache \
		ca-certificates \
		docker-compose \
		inotify-tools \
        supervisor \
		openssl \
		docker \
		unzip \
        nano \
		bash \
		htop \
		curl \
		grep \
		sudo \
        git \
		tar \
		xz \
        jq \
        yq \
    ; \
	curl -L "https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}/gum_${GUM_VERSION}_x86_64.apk" \
		 -o /tmp/gum.apk; \
	apk add --no-cache --allow-untrusted /tmp/gum.apk; \
	\
	mkdir -p /var/www; \
	rm -rf /var/www/*; \
	cd /var/www; \
	\
	/usr/doravel/bin/new .; \
	\
	apk cache -v clean; \
	apk cache -v purge; \
	rm -f /tmp/*;

EXPOSE 8000
EXPOSE 9000
EXPOSE 5173
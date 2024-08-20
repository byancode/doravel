#!/bin/bash

# VERSIONS=('8.1.18' '8.1.19' '8.1.20' '8.2.5' '8.2.6' '8.2.7')
TAG='php'
VERSIONS=('8.1.26' '8.1.29' '8.2.13' '8.2.15' '8.2.20' '8.3.0' '8.3.2' '8.3.8')
# VERSIONS=('8.1.26' '8.2.13' '8.2.15' '8.3.0' '8.3.2')
# VERSIONS=('8.1.29' '8.2.20' '8.3.8')
# VERSIONS=('8.1.26')
REPOSITORY='byancode/doravel'
SWOOLE_VERSION='5.1.3'
REDIS_VERSION='6.0.2'
NODE_VERSION='22.2.0'

for PHP_VERSION in "${VERSIONS[@]}"; do
    echo "Building PHP ${PHP_VERSION}...";
    docker build \
        --tag $REPOSITORY:$TAG \
        --build-arg "PHP_VERSION=${PHP_VERSION}" \
        --build-arg "NODE_VERSION=${NODE_VERSION}" \
        --build-arg "REDIS_VERSION=${REDIS_VERSION}" \
        --build-arg "SWOOLE_VERSION=${SWOOLE_VERSION}" \
        --no-cache \
    .;

    docker tag $REPOSITORY:$TAG $REPOSITORY:$TAG-$PHP_VERSION;
    docker push $REPOSITORY:$TAG-$PHP_VERSION;

    PHP_MINOR_VERSION=$(echo "${PHP_VERSION}" | cut -d "." -f 1,2);

    docker tag $REPOSITORY:$TAG-$PHP_VERSION $REPOSITORY:$TAG-$PHP_MINOR_VERSION;
    docker push $REPOSITORY:$TAG-$PHP_MINOR_VERSION;
done

docker push $REPOSITORY:$TAG;

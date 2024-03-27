#!/bin/bash

# VERSIONS=('8.1.18' '8.1.19' '8.1.20' '8.2.5' '8.2.6' '8.2.7')
TAG='php'
VERSIONS=('8.1.26' '8.2.13' '8.2.15' '8.3.0' '8.3.2')
#VERSIONS=('8.1.26')
REPOSITORY='byancode/doravel'
SWOOLE_VERSION='5.1.1'
REDIS_VERSION='6.0.2'

for VERSION in "${VERSIONS[@]}"; do
    echo "Building PHP ${VERSION}...";
    docker build \
        --tag $REPOSITORY:$TAG \
        --build-arg "PHP_VERSION=${VERSION}" \
        --build-arg "REDIS_VERSION=${REDIS_VERSION}" \
        --build-arg "SWOOLE_VERSION=${SWOOLE_VERSION}" \
    .;

    docker tag $REPOSITORY:$TAG $REPOSITORY:$TAG-$VERSION;
    docker push $REPOSITORY:$TAG-$VERSION;

    SHORT_VERSION=$(echo "${VERSION}" | cut -d "." -f 1,2);

    docker tag $REPOSITORY:$TAG-$VERSION $REPOSITORY:$TAG-$SHORT_VERSION;
    docker push $REPOSITORY:$TAG-$SHORT_VERSION;
done

docker push $REPOSITORY:$TAG;

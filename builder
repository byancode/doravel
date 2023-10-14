#!/bin/bash

# VERSIONS=('8.1.18' '8.1.19' '8.1.20' '8.2.5' '8.2.6' '8.2.7')
TAG='php'
# VERSIONS=('8.1.18' '8.1.19' '8.1.20' '8.2.5' '8.2.6' '8.2.7')
VERSIONS=('8.1.24' '8.2.11')
REPOSITORY='byancode/doravel'

for VERSION in "${VERSIONS[@]}"; do
    echo "Building PHP ${VERSION}...";
    docker build --tag $REPOSITORY:$TAG --build-arg "PHP_VERSION=${VERSION}" .;

    docker tag $REPOSITORY:$TAG $REPOSITORY:$TAG-$VERSION;
    docker push $REPOSITORY:$TAG-$VERSION;

    SHORT_VERSION=$(echo "${VERSION}" | cut -d "." -f 1,2);

    docker tag $REPOSITORY:$TAG-$VERSION $REPOSITORY:$TAG-$SHORT_VERSION;
    docker push $REPOSITORY:$TAG-$SHORT_VERSION;
done

docker push $REPOSITORY:$TAG;

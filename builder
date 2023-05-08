#!/bin/bash

# VERSIONS=('8.1.18' '8.2.5')
VERSIONS=('8.1.18')
REPOSITORY='byancode/doravel-next'

for VERSION in "${VERSIONS[@]}"; do
    echo "Building PHP ${VERSION}...";
    docker build --tag $REPOSITORY --build-arg "PHP_VERSION=${VERSION}" .;
    docker tag $REPOSITORY $REPOSITORY:${VERSION};
    SHORT_VERSION=$(echo "${VERSION}" | cut -d "." -f 1,2);
    docker tag $REPOSITORY $REPOSITORY:${SHORT_VERSION};
    # docker push $REPOSITORY:${VERSION};
    # docker push $REPOSITORY:${SHORT_VERSION};
done
# docker push $REPOSITORY
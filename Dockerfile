ARG PHP_VERSION=8.3
ARG DISTRO="alpine"

FROM docker.io/tiredofit/nginx-php-fpm:${PHP_VERSION}-${DISTRO}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ENV \
    NGINX_SITE_ENABLED=laravel \
    PHP_ENABLE_CREATE_SAMPLE_PHP=FALSE \
    PHP_ENABLE_CURL=TRUE \
    PHP_ENABLE_INTL=TRUE \
    PHP_ENABLE_LDAP=TRUE \
    PHP_ENABLE_OPENSSL=TRUE \
    PHP_ENABLE_PDO_SQLITE=TRUE \
    PHP_ENABLE_POSIX=TRUE \
    PHP_ENABLE_SIMPLEXML=TRUE \
    PHP_ENABLE_TOKENIZER=TRUE \
    PHP_ENABLE_ZIP=TRUE \
    IMAGE_NAME=tiredofit/laravel \
    IMAGE_REPO_URL=https://github.com/tiredofit/docker-laravel

RUN source /assets/functions/00-container && \
    set -x && \
    package update && \
    package upgrade && \
    package install .laravel-build-deps \
                                        nodejs \
                                        npm \
                                        yarn \
                                        && \
    php-ext prepare && \
    php-ext reset && \
    php-ext enable core && \
    package cleanup

COPY install/ /

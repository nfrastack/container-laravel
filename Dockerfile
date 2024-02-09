
ARG PHP_VERSION=8.2
ARG DISTRO="alpine"

FROM docker.io/tiredofit/nginx-php-fpm:${PHP_VERSION}-${DISTRO}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

RUN source /assets/functions/00-container && \
    set -x && \
    package install .laravel-run-deps \
                    nodejs \
                    npm \
                    yarn \
                    && \
    package update && \
    package upgrade && \
    package cleanup

COPY install/ /
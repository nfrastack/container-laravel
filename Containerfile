# SPDX-FileCopyrightText: © 2026 Nfrastack <code@nfrastack.com>
#
# SPDX-License-Identifier: MIT

ARG BASE_IMAGE

FROM ${BASE_IMAGE}

LABEL \
        org.opencontainers.image.title="Laravel" \
        org.opencontainers.image.description="Containerized base image with Nginx, PHP-FPM to run Laravel applications" \
        org.opencontainers.image.url="https://hub.docker.com/r/nfrastack/laravel" \
        org.opencontainers.image.documentation="https://github.com/nfrastack/container-laravel/blob/main/README.md" \
        org.opencontainers.image.source="https://github.com/nfrastack/container-laravel.git" \
        org.opencontainers.image.authors="Nfrastack <code@nfrastack.com>" \
        org.opencontainers.image.vendor="Nfrastack <https://www.nfrastack.com>" \
        org.opencontainers.image.licenses="MIT"

COPY CHANGELOG.md /usr/src/container/CHANGELOG.md
COPY LICENSE /usr/src/container/LICENSE
COPY README.md /usr/src/container/README.md

ARG \
    NODE_VERSION=24

ENV \
    IMAGE_NAME=nfrastack/laravel \
    IMAGE_REPO_URL=https://github.com/nfrastack/container-laravel

RUN echo "" && \
    BUILD_ENV=" \
                10-nginx/NGINX_SITE_ENABLED=laravel \
                10-nginx/NGINX_WEBROOT_SUFFIX=/public \
                10-nginx/NGINX_INDEX_FILE=index.php \
                10-nginx/NGINX_ENABLE_DENY_HIDDEN_FILES=TRUE \
                10-nginx/NGINX_ENABLE_EXPLOIT_PROTECTION=TRUE \
                20-php-fpm/PHP_CREATE_SAMPLE_PHP=FALSE \
                20-php-fpm/PHP_MODULE_ENABLE_LDAP=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_PDO_SQLITE=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_POSIX=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_ZIP=TRUE \
              " \
              && \
    LARAVEL_BUILD_DEPS_DEBIAN=" \
                              " \
                              && \
    LARAVEL_RUN_DEPS_DEBIAN=" \
                                jpegoptim \
                                nodejs \
                                optipng \
                                pngquant \
                            " \
                            && \
    LARAVEL_BUILD_DEPS_ALPINE=" \
                              " \
                              && \
    LARAVEL_RUN_DEPS_ALPINE=" \
                                jpegoptim \
                                nodejs \
                                npm \
                                sed \
                                optipng \
                                pngquant \
                                yarn \
                            " \
                            && \
    source /container/base/functions/container/build && \
    container_build_log image && \
    package repo add node ${NODE_VERSION} && \
    package update && \
    package upgrade && \
    package install \
                        LARAVEL_BUILD_DEPS \
                        LARAVEL_RUN_DEPS \
                        && \
    \
    php-ext prepare && \
    php-ext reset && \
    php-ext enable core && \
    package cleanup

COPY rootfs/ /

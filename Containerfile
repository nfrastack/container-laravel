# SPDX-FileCopyrightText: © 2025 Nfrastack <code@nfrastack.com>
#
# SPDX-License-Identifier: MIT

ARG \
    BASE_IMAGE \
    DISTRO \
    DISTRO_VARIANT

FROM ${BASE_IMAGE}:${DISTRO}_${DISTRO_VARIANT}

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
    IMAGE_NAME=nfrastack/laravel \
    IMAGE_REPO_URL=https://github.com/nfrastack/container-laravel

RUN echo "" && \
    LARAVEL_BUILD_DEPS_ALPINE=" \
                               " \
                               && \
    LARAVEL_RUN_DEPS_ALPINE=" \
                                jpegoptim \
                                nodejs \
                                npm \
                                optipng \
                                pngquant \
                                yarn \
                            " \
                            && \
    source /container/base/functions/container/build && \
    container_build_log image && \
    package update && \
    package upgrade && \
    package install \
                        LARAVEL_RUN_DEPS \
                        && \
    php-ext prepare && \
    php-ext reset && \
    php-ext enable core && \
    package cleanup

COPY rootfs/ /

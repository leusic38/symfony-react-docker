FROM php:fpm-alpine

#ENV COMPOSER_ALLOW_SUPERUSER 1
#ENV PHP_XDEBUG_DEFAULT_ENABLE ${PHP_XDEBUG_DEFAULT_ENABLE:-1}
#ENV PHP_XDEBUG_REMOTE_ENABLE ${PHP_XDEBUG_REMOTE_ENABLE:-1}
#ENV PHP_XDEBUG_REMOTE_HOST ${PHP_XDEBUG_REMOTE_HOST:-"127.0.0.1"}
#ENV PHP_XDEBUG_REMOTE_PORT ${PHP_XDEBUG_REMOTE_PORT:-9001}
#ENV PHP_XDEBUG_REMOTE_AUTO_START ${PHP_XDEBUG_REMOTE_AUTO_START:-1}
#ENV PHP_XDEBUG_REMOTE_CONNECT_BACK ${PHP_XDEBUG_REMOTE_CONNECT_BACK:-1}
#ENV PHP_XDEBUG_IDEKEY ${PHP_XDEBUG_IDEKEY:-IDEA}
#ENV PHP_XDEBUG_PROFILER_ENABLE ${PHP_XDEBUG_PROFILER_ENABLE:-0}
#ENV PHP_XDEBUG_PROFILER_OUTPUT_DIR ${PHP_XDEBUG_PROFILER_OUTPUT_DIR:-"/tmp"}

RUN apk update \
    && apk add  --no-cache git curl libmcrypt libmcrypt-dev openssh-client icu-dev fish openssl\
    libxml2-dev freetype-dev libpng-dev libjpeg-turbo-dev g++ make autoconf \
    libzip-dev\
    postgresql-dev \
    && docker-php-ext-install -j$(nproc) pgsql \
    && docker-php-ext-install -j$(nproc) pdo_pgsql\
    && docker-php-source extract \
    && pecl install xdebug redis \
    && docker-php-ext-enable xdebug redis \
    && docker-php-source delete \
    && docker-php-ext-install soap intl zip \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
    && rm -rf /tmp/*

COPY apps/api-symfo /usr/src/api-symfo
COPY docker/build-php/xdebug.ini /usr/local/etc/php/conf.d/xdebug-dev.ini

ENV USER=apiuser
ENV UID=1000
ENV GID=1000

#RUN addgroup --gid $GID $USER $USER
RUN adduser \
    --disabled-password \
    --gecos "" \
    --uid "$UID" \
    "$USER"
USER $USER
WORKDIR /usr/src/api-symfo

#RUN chown -R $USER $HOME/.composer
RUN PATH=$PATH:/usr/src/api-symfo/vendor/bin:bin

EXPOSE 9000


CMD ["php-fpm", "-F"]

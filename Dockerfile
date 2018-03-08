FROM php:7.1-fpm

# Install PHP extensions and PECL modules.
RUN apt-get update && deps=" \
        apt-utils \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng12-dev \
        libcurl4-openssl-dev \
        libicu-dev \
        libmcrypt-dev \
        libssl-dev \
        wget \
        git \
        vim \
    " \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -q $deps \
    && docker-php-ext-install opcache mcrypt intl \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && pecl install redis xdebug-2.5.0 \
    && docker-php-ext-enable redis xdebug \
    && rm -r /var/lib/apt/lists/*

RUN mkdir /webmedia \
   && mkdir -p /webmedia_cache/cache \
   && chmod -R 777 /webmedia_cache/cache

# Copy all into the container
COPY ./ /

WORKDIR /var/www/

EXPOSE 9000


FROM php:7.2-fpm
RUN apt-get update \
    && apt-get install -yq \
        libfreetype6-dev \
        libmcrypt-dev \
        libjpeg-dev \
        libpng-dev \
        libicu-dev \
        libldap2-dev \
        libxml2-dev \
    && docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-freetype-dir=/usr/include/freetype2 \
        --with-png-dir=/usr/include \
        --with-jpeg-dir=/usr/include \
    && docker-php-ext-install gd intl ldap mysqli opcache pdo_mysql soap zip \
    && echo no | pecl install -o -f redis \
    && docker-php-ext-enable redis \
    && rm -rf /tmp/pear /var/cache/apt/* /var/lib/apt/*

FROM php:7.2-fpm-alpine
RUN docker-php-ext-install curl gd intl json ldap mbstring mysqli opcache pdo_mysql readline soap xml zip \
    && pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis

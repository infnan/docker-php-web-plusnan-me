FROM php:7.2-fpm-alpine
RUN docker-php-ext-install gd intl ldap mysqli opcache pdo_mysql soap zip \
    && pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis

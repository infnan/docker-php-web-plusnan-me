FROM php:7.2-fpm

# Add nginx user & group
RUN usermod -u 105 _apt \
    && groupadd -g 101 nginx \
    && useradd -u 100 -g 101 -s /sbin/nologin -p NP nginx

# Install basic exts
RUN apt update \
    && apt install -yq \
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
    && docker-php-ext-install gd intl ldap mysqli opcache pdo_mysql soap zip
    
# Install redis
RUN pecl install -o -f redis \
    && docker-php-ext-enable redis
    
# Install imagick
RUN apt install --no-install-recommends -y libmagickwand-dev \
    && pecl install imagick \
    && docker-php-ext-enable imagick

# https://roboslang.blog/post/2017-12-06-cron-docker/
# https://stackoverflow.com/a/54356073

# Install cron
RUN apt install --no-install-recommends -y cron
ADD crontab /etc/cron.d/cron
RUN chown nginx:nginx /etc/cron.d/cron
RUN chmod 0644 /etc/cron.d/cron
RUN crontab -u nginx /etc/cron.d/cron
RUN chmod u+s /usr/sbin/cron
RUN touch /var/log/cron.log

# Cleanup
RUN rm -rf /tmp/pear /var/cache/apt/* /var/lib/apt/*

# Run as nginx
RUN sed -i 's/www-data/nginx/g' /usr/local/etc/php-fpm.d/www.conf
RUN chown -R nginx:nginx /var/www/html
USER nginx

# Run the command on container startup
CMD crontab -u nginx /etc/cron.d/cron && cron && tail -f /var/log/cron.log

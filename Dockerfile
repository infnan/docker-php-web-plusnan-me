FROM php:7.2-cli
RUN usermod -u 105 _apt \
    && groupadd -g 101 nginx \
    && useradd -u 100 -g 101 -s /sbin/nologin -p NP nginx \
    && apt-get update \
    && apt install --no-install-recommends -y cron \
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

# https://roboslang.blog/post/2017-12-06-cron-docker/
# https://stackoverflow.com/a/54356073

# Add crontab file in the cron directory
ADD crontab /etc/cron.d/cron
# Give execution rights on the cron job
RUN chown nginx:nginx /etc/cron.d/cron
RUN chmod 0644 /etc/cron.d/cron
# Apply cron job
RUN crontab -u nginx /etc/cron.d/cron
RUN chmod u+s /usr/sbin/cron
# Create the log file to be able to run tail
RUN touch /var/log/cron.log
# Run the command on container startup
CMD cron && tail -f /var/log/cron.log

USER nginx

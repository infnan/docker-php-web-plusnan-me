# docker-php-web-plusnan-me
Php-fpm docker image used for web.plusnan.me

## Tags
* `7.2`: Forked from `php:7.2-fpm`
* `7.2-cli`: Forked from `php:7.2-cli` with `cron` installed.
* `7.2-cron`: Forked from `php:7.2-cli` with a running `cron`.
* `latest`: Just garbage

## Changes from the official image
* Installed some components: gd intl ldap mysqli opcache pdo_mysql soap zip redis
* Add a user `nginx` in order to work with [nginx](https://hub.docker.com/_/nginx).
* Set user to `nginx`.
* `7.2-cli` has `cron` installed and the configuration file is placed at `/etc/cron.d/cron`.

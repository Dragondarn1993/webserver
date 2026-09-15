FROM php:8.5-apache

# Download and activate the mlocati helper script
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Install all required extensions and dependencies
RUN install-php-extensions \
    apcu \
    bcmath \
    calendar \
    dba \
    exif \
    ftp \
    gd \
    gettext \
    gmp \
    igbinary \
    imagick \
    intl \
    ldap \
    mongodb \
    mysqli \
    pcntl \
    pdo_mysql \
    pdo_pgsql \
    pdo_sqlite \
    pgsql \
    redis \
    shmop \
    soap \
    sockets \
    sysvmsg \
    sysvsem \
    sysvshm \
    tidy \
    xsl \
    zip

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

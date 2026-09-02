FROM alpine:3.24.1
LABEL maintainer="Dragondarn"
LABEL description="Web Server"

EXPOSE 80 443

# Setup apache and php
RUN apk --no-cache --update \
    add apache2 \
    apache2-ssl \
    curl \
    php85-apcu \
    php85-bcmath \
    php85-calendar \
    php85-Core \
    php85-ctype \
    php85-curl \
    php85-date \
    php85-dba \
    php85-dom \
    php85-exif \
    php85-fileinfo \
    php85-filter \
    php85-ftp \
    php85-gd \
    php85-gettext \
    php85-gmp \
    php85-hash \
    php85-iconv \
    php85-igbinary \
    php85-imagick \
    php85-intl \
    php85-json \
    php85-ldap \
    php85-libxml \
    php85-mbstring \
    php85-mongodb \
    php85-mysqli \
    php85-mysqlnd \
    php85-openssl \
    php85-pcntl \
    php85-pcre \
    php85-PDO \
    php85-pdo_mysql \
    php85-pdo_pgsql \
    php85-pdo_sqlite \
    php85-pgsql \
    php85-Phar \
    php85-posix \
    php85-random \
    php85-readline \
    php85-redis \
    php85-Reflection \
    php85-session \
    php85-shmop \
    php85-SimpleXML \
    php85-soap \
    php85-sockets \
    php85-sodium \
    php85-SPL \
    php85-sqlite3 \
    php85-standard \
    php85-sysvmsg \
    php85-sysvsem \
    php85-sysvshm \
    php85-tidy \
    php85-tokenizer \
    php85-xml \
    php85-xmlreader \
    php85-xmlwriter \
    php85-xsl \
    php85-zip \
    php85-zlib \
    tzdata \
    && mkdir /htdocs

COPY linkstack /htdocs
COPY configs/apache2/httpd.conf /etc/apache2/httpd.conf
COPY configs/apache2/ssl.conf /etc/apache2/conf.d/ssl.conf
COPY configs/php/php.ini /etc/php8.5/php.ini

RUN chown 2000:2000 /etc/ssl/apache2/server.pem
RUN chown 2000:2000 /etc/ssl/apache2/server.key

RUN chown -R 2000:2000 /htdocs
RUN find /htdocs -type d -print0 | xargs -0 chmod 0755
RUN find /htdocs -type f -print0 | xargs -0 chmod 0644

COPY --chmod=0755 docker-entrypoint.sh /usr/local/bin/

USER 2000:2000

HEALTHCHECK CMD curl -f http://localhost -A "HealthCheck" || exit 1

# Set console entry path
WORKDIR /htdocs

CMD ["docker-entrypoint.sh"]

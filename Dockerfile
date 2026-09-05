# Basis: PHP + Apache
FROM php:8.5-apache

ENV DEBIAN_FRONTEND=noninteractive

# Systemabhängigkeiten für Erweiterungen
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential autoconf pkg-config git unzip wget ca-certificates \
    libzip-dev libpng-dev libjpeg62-turbo-dev libfreetype6-dev libwebp-dev \
    libonig-dev libicu-dev libxml2-dev libxslt1-dev libssl-dev \
    libmagickwand-dev imagemagick \
    libldap2-dev libsasl2-dev \
    libgmp-dev libsqlite3-dev default-libmysqlclient-dev \
    libpq-dev zlib1g-dev libbz2-dev libtidy-dev \
    && rm -rf /var/lib/apt/lists/*

# Configure / build / enable extensions
RUN set -eux; \
    # GD konfigurieren (JPEG/Freetype/WebP)
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp; \
    # LDAP ggf. konfigurieren (Pfad-Einstellung trägt Kompatibilität bei Debian-basierten images)
    docker-php-ext-configure ldap --with-libdir=/usr/lib/x86_64-linux-gnu || true; \
    # Intl braucht libicu (installiert oben)
    \
    # Kompilieren/Installieren zahlreicher core-Extensions
    docker-php-ext-install -j"$(nproc)" \
        bcmath calendar exif ftp gettext gmp intl mbstring \
        mysqli pcntl pdo_mysql pdo_pgsql pdo_sqlite pgsql phar posix readline shmop \
        soap sockets sodium sysvmsg sysvsem sysvshm tidy tokenizer \
        xml xmlreader xmlwriter xsl zip zlib sqlite3 gd; \
    \
    # PECL-Extensions installieren und aktivieren
    pecl channel-update pecl.php.net; \
    pecl install apcu igbinary imagick redis mongodb || (echo "PECL install failed"; exit 1); \
    docker-php-ext-enable apcu igbinary imagick redis mongodb; \
    \
    # Apache modules
    a2enmod rewrite headers expires; \
    \
    # Aufräumen (listen löschen bereits oben)
    rm -rf /tmp/pear

# Optional: eigene php.ini (falls du Einstellungen anpassen willst)
# COPY ./php.ini /usr/local/etc/php/php.ini

EXPOSE 80

CMD ["apache2-foreground"]

FROM php:8.3.36-apache

# WITH_GD=1 include GD con JPEG/FreeType/PNG; 0 (default) la esclude
ARG WITH_GD=0

# 1. Installazione dipendenze di sistema (rimosso libc-client)
RUN apt-get update && apt-get install -y \
    libmagickwand-dev --no-install-recommends \
    libkrb5-dev \
    libxml2-dev \
    libxslt1-dev \
    libssl-dev \
    curl \
    libcurl4-openssl-dev \
    zip \
    unzip \
    && if [ "$WITH_GD" = "1" ]; then \
        apt-get install -y --no-install-recommends libfreetype6-dev libjpeg62-turbo-dev libpng-dev; \
    fi \
    && rm -rf /var/lib/apt/lists/*

# 2. Configurazione e installazione moduli PHP standard (rimosso imap)
RUN if [ "$WITH_GD" = "1" ]; then \
        docker-php-ext-configure gd --with-freetype --with-jpeg; \
    fi \
    && docker-php-ext-install -j$(nproc) \
    calendar \
    exif \
    ftp \
    gettext \
    mysqli \
    pdo_mysql \
    shmop \
    sockets \
    sysvmsg \
    sysvsem \
    sysvshm \
    xsl \
    $( [ "$WITH_GD" = "1" ] && echo gd )

# 3. Installazione Imagick tramite PECL
RUN pecl install imagick \
    && docker-php-ext-enable imagick

# Abilitiamo il modulo rewrite di Apache per i permalink/htaccess
RUN a2enmod rewrite

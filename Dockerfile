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

# Abilitiamo i moduli Apache necessari:
# - rewrite: permalink/riscritture URL
# - headers: direttive Header/RequestHeader negli .htaccess
# - expires: cache/expires sempre via .htaccess
RUN a2enmod rewrite headers expires

# Gli .htaccess devono poter sovrascrivere la configurazione.
# La base ha AllowOverride None nel blocco <Directory /var/www/> di
# apache2.conf; il file qui sotto viene incluso in coda (conf-enabled),
# quindi vince e abilita AllowOverride All SOLO sul document root
# (non su / o /usr/share, come farebbe un sed globale).
COPY apache/security.conf /etc/apache2/conf-available/php-hardening.conf
RUN a2enconf php-hardening

FROM php:7.3-fpm-alpine

# Install packages
# RUN apk --no-cache add php7 php7-fpm php7-mysqli php7-json php7-openssl php7-curl \
#     php7-zlib php7-xml php7-phar php7-intl php7-dom php7-pdo php7-psql php7-xmlreader php7-ctype php7-session \
#     php7-mbstring php7-gd php7-imap nginx supervisor curl

RUN apk --no-cache add nginx supervisor curl
# Install dev dependencies
RUN apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    curl-dev \
    imagemagick-dev \
    libtool \
    libxml2-dev \
    postgresql-dev \
    sqlite-dev

# Install production dependencies
RUN apk add --no-cache \
    bash \
    curl \
    g++ \
    gcc \
    git \
    imagemagick \
    libc-dev \
    libpng-dev \
    make \
    mysql-client \
    nodejs \
    npm \
    yarn \
    openssh-client \
    postgresql-libs \
    rsync \
    zlib-dev \
    libzip-dev \
    imap-dev

RUN docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-configure imap --with-imap-ssl
RUN docker-php-ext-install \
    curl \
    iconv \
    mbstring \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    pdo_sqlite \
    pcntl \
    tokenizer \
    xml \
    gd \
    zip \
    bcmath \
    imap

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer 

# install and enable php extension for phpBolt
COPY config_docker/bolt.so /usr/local/etc/php/ext/bolt.so
RUN echo "extension='/usr/local/etc/php/ext/bolt.so'" >> /usr/local/etc/php/conf.d/docker-php-ext-bolt.ini

# Install npm
RUN mkdir -p ~/.npm
RUN chown -R www-data:www-data ~/.npm

RUN apk add nano
RUN apk add sox
RUN echo -e "post_max_size=60M\nupload_max_filesize=60M\nmemory_limit=128M" > "/usr/local/etc/php/conf.d/custom.ini"

FROM phusion/baseimage:0.9.22
MAINTAINER 4 All Digital  "joe@4alldigital.com"

# Required to run some apt-get commands (fix for Unable to locate package php5 issue)
ENV DEBIAN_FRONTEND noninteractive

# Ensure UTF-8
RUN locale-gen en_GB.UTF-8
ENV LANG       en_GB.UTF-8
ENV LC_ALL     en_GB.UTF-8

RUN apt-get -y update && \
    apt-get install -y --no-install-recommends software-properties-common python-software-properties && \
    add-apt-repository ppa:ondrej/php && \
    rm -fr /tmp/* /var/lib/apt/lists/* /var/tmp/* \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get clean

RUN apt-get update \
    && apt-get -q install -y --no-install-recommends \
        php7.2-fpm \
        php7.2-cli \
        php7.2-common \
        php-redis \
        php7.2-curl \
        php7.2-mysql \
        php7.2-gd \
        php7.2-zip \
        php7.2-xml \
        php7.1-mcrypt \
        php7.2-mbstring \
        php7.2-soap \
        php7.2-json \
        php7.2-opcache \
        php7.2-bcmath \
        php7.2-pspell \
        php7.2-sqlite3 \
        php7.2-dev pkg-config php-pear && \
    # libs
    apt-get update \
    && apt-get -q install -y --no-install-recommends \
        libcurl4-openssl-dev \
        libmcrypt-dev \
        libxml2-dev \
        libjpeg-dev \
        libjpeg62 \
        libfreetype6-dev \
        libmysqlclient-dev \
        libmagickwand-dev \
        libgmp-dev \
        libicu-dev \
        libpspell-dev \
        librecode-dev \
        libxpm-dev \
        libssl-dev \
        build-essential \
        supervisor \
        imagemagick \
        ssh \
        git \
        ssmtp \
        mysql-client \
        zip unzip \
        rsync \
        php-mysql && \
     pecl install apcu-5.1.3 && \
    # Install Composer
    cd $HOME && \
        curl -sS https://getcomposer.org/installer | php && \
        chmod +x composer.phar && \
        mv composer.phar /usr/local/bin/composer && \
        /usr/local/bin/composer self-update && \
    # cleanup
    rm -fr /tmp/* /var/lib/apt/lists/* /var/tmp/* \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get clean

# Install useful Drush
RUN /usr/local/bin/composer global require drush/drush:8.1.16 && \
    ln -s /root/.composer/vendor/drush/drush/drush /usr/local/bin/drush

RUN mkdir /root/.drush/

RUN mkdir -p /app/web
WORKDIR /app/web

COPY ./config/php-fpm.conf /etc/php/7.2/fpm/php-fpm.conf
COPY ./config/www.conf /etc/php/7.2/fpm/pool.d/www.conf
COPY ./config/docker.conf /etc/php/7.2/fpm/pool.d/docker.conf
COPY ./config/php.ini /etc/php/7.2/fpm/php.ini
COPY ./config/cli-php.ini /etc/php/7.2/fpm/cli-php.ini
COPY ./config/htaccess /tmp/.htaccess

RUN mkdir -p /var/run/php/ && touch /var/run/php/php7.2-fpm.pid

# Accept Symfony pseudo TTY session
RUN touch /root/.bashrc && \
    echo "export TERM=xterm-256color" >> /root/.bashrc

# Internal Port Expose
EXPOSE 9000

CMD ["/usr/sbin/php-fpm7.2","--fpm-config","/etc/php/7.2/fpm/php-fpm.conf"]

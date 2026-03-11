FROM phusion/baseimage:master-amd64
MAINTAINER 4 All Digital  "joe@4alldigital.com"

# Required to run some apt-get commands (fix for Unable to locate package php5 issue)
ENV DEBIAN_FRONTEND noninteractive

# Ensure UTF-8
RUN locale-gen en_GB.UTF-8
ENV LANG       en_GB.UTF-8
ENV LC_ALL     en_GB.UTF-8

RUN apt-get -y update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    rm -fr /tmp/* /var/lib/apt/lists/* /var/tmp/* \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get clean

RUN apt-get update \
    && apt-get -q install -y --no-install-recommends \
        php8.0-fpm \
        php8.0-cli \
        php8.0-common \
        php8.0-redis \
        php8.0-curl \
        php8.0-mysql \
        php8.0-gd \
        php8.0-zip \
        php8.0-xml \
        php8.0-mcrypt \
        php8.0-mbstring \
        php8.0-soap \
        php8.0-opcache \
        php8.0-bcmath \
        php8.0-pspell \
        php8.0-sqlite3 \
        php8.0-dev pkg-config php-pear
    # libs
RUN apt-get update \
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
        php-mysql
    # Install Composer
RUN cd $HOME && \
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
RUN /usr/local/bin/composer global require drush/drush:^10.0.0 && \
    ln -s /root/.config/composer/vendor/drush/drush/drush /usr/local/bin/drush

RUN mkdir /root/.drush/

RUN mkdir -p /app/web
WORKDIR /app/web

RUN mkdir -p /var/log/supervisor && \
    usermod -u 1000 www-data && \
    usermod -a -G users www-data

COPY ./config/php-fpm.conf /etc/php/8.0/fpm/php-fpm.conf
COPY ./config/www.conf /etc/php/8.0/fpm/pool.d/www.conf
COPY ./config/docker.conf /etc/php/8.0/fpm/pool.d/docker.conf
COPY ./config/php.ini /etc/php/8.0/fpm/php.ini
COPY ./config/cli-php.ini /etc/php/8.0/fpm/cli-php.ini
COPY ./config/htaccess /tmp/.htaccess
COPY ./config/mysql.conf /etc/mysql/conf.d/mysql.cnf
COPY ./config/mysql.conf /etc/mysql/conf.d/test.cnf

RUN mkdir -p /var/run/php/ && touch /var/run/php/php8.0-fpm.pid

# Accept Symfony pseudo TTY session
RUN touch /root/.bashrc && \
    echo "export TERM=xterm-256color" >> /root/.bashrc

# Internal Port Expose
EXPOSE 9000

CMD ["/usr/sbin/php-fpm8.0","--fpm-config","/etc/php/8.0/fpm/php-fpm.conf"]

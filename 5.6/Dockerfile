FROM phusion/baseimage:0.9.22
MAINTAINER 4 All Digital  "joe@4alldigital.com"

# Required to run some apt-get commands (fix for Unable to locate package php5 issue)
ENV DEBIAN_FRONTEND noninteractive

# Ensure UTF-8
RUN locale-gen en_GB.UTF-8
ENV LANG       en_GB.UTF-8
ENV LC_ALL     en_GB.UTF-8

ENV XHPROF_VERSION 0.9.4
ENV XDEBUG_VERSION 2.4.0
ENV XDEBUG_MD5 a9bc9c6b9e8bc913fb1f7c6f6d19f6222d430414

RUN apt-get -y update && apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update -y && \
    rm -fr /tmp/* /var/lib/apt/lists/* /var/tmp/* \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get clean

RUN apt-get -q install -y --no-install-recommends php5.6-fpm php5.6-curl curl\
    build-essential php5.6-dev php5.6-xdebug wget php5.6-mcrypt php5.6-gd imagemagick\
    php5.6-xsl php5.6-imap php5.6-pgsql php5.6-mysql mysql-client ssmtp\
    php5.6-common php-pear nginx-extras php5.6-redis php5.6-json php5.6-cli supervisor\
    msmtp mailutils libncurses-dev zlib1g-dev php5.6-json openssh-server make\
    libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl libxslt1-dev libgd2-xpm-dev\
    libgeoip-dev libxrender1 libssl-dev libbz2-dev libcurl4-openssl-dev\
    libfreetype6 libfreetype6-dev libfontconfig libfontconfig1 libexpat-dev git && \
    apt-get autoremove

# Install XHPROF
RUN curl -L -o /root/xhprof.tgz https://pecl.php.net/get/xhprof-$XHPROF_VERSION.tgz && \
    cd /root && \
    mkdir -p /usr/src/xhprof && \
    tar -zxvf xhprof.tgz -C /usr/src/xhprof --strip-components=1 && \
    cd /usr/src/xhprof/extension && \
    phpize && \
    ./configure --with-php-config=/usr/bin/php-config && \
    make  && \
    make install && \
    cd /root && \
    rm -fr /root/xhprof-$XHPROF_VERSION.tgz && \
# Install XDEBUG
    set -x \
    && curl -SL "http://xdebug.org/files/xdebug-$XDEBUG_VERSION.tgz" -o xdebug.tgz \
    && echo "$XDEBUG_MD5  xdebug.tgz" | shasum -c - \
    && mkdir -p /usr/src/xdebug \
    && tar -xf xdebug.tgz -C /usr/src/xdebug --strip-components=1 \
    && rm xdebug.* \
    && cd /usr/src/xdebug \
    && phpize \
    && ./configure \
    && make -j"$(nproc)" \
    && make install \
    && make clean && \
# Install PHPREDIS
    wget https://github.com/phpredis/phpredis/archive/develop.tar.gz && tar -xvf develop.tar.gz && \
    cd phpredis-develop &&\
    phpize &&\
    ./configure &&\
    make && make install && \
# Install Composer
    cd $HOME && \
    curl -sS https://getcomposer.org/installer | php && \
    chmod +x composer.phar && \
    mv composer.phar /usr/local/bin/composer && \
    /usr/local/bin/composer self-update && \
# Cleanup build
    apt-get autoremove -y

RUN mkdir -p /var/run/sshd /var/log/supervisor && \
    usermod -u 1000 www-data && \
    usermod -a -G users www-data

COPY config/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Install useful Drush
RUN /usr/local/bin/composer global require drush/drush:8.1.2 && \
    ln -s /root/.config/composer/vendor/drush/drush/drush /usr/local/bin/drush

# Setup SSH for behat usage between containers
RUN echo 'root:root' | chpasswd && \
    sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    mkdir -p /root/.ssh/

RUN drush @none dl utf8mb4_convert-7.x

COPY ./config/php-fpm.conf /etc/php5/fpm/php-fpm.conf
COPY ./config/20-xdebug.ini /etc/php5/fpm/conf.d/20-xdebug.ini

COPY ./ssh/moduli /etc/ssh/moduli
COPY ./ssh/ssh_config /etc/ssh/ssh_config
COPY ./ssh/ssh_host_dsa_key /etc/ssh/ssh_host_dsa_key
COPY ./ssh/ssh_host_dsa_key.pub /etc/ssh/ssh_host_dsa_key.pub
COPY ./ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_ecdsa_key
COPY ./ssh/ssh_host_ecdsa_key.pub /etc/ssh/ssh_host_ecdsa_key.pub
COPY ./ssh/ssh_host_ed25519_key /etc/ssh/ssh_host_ed25519_key
COPY ./ssh/ssh_host_ed25519_key.pub /etc/ssh/ssh_host_ed25519_key.pub
COPY ./ssh/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key
COPY ./ssh/ssh_host_rsa_key.pub /etc/ssh/ssh_host_rsa_key.pub
COPY ./ssh/sshd_config /etc/ssh/sshd_config

chmod 400 /etc/ssh/ssh_*

# Internal Port Expose
EXPOSE 9000 22

CMD ["/usr/bin/supervisord"]

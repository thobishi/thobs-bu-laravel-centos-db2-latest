FROM centos:latest

LABEL maintainer="BU Thobishi Moreko thobishi@borwaubora.co.za"
LABEL version="0.1"

USER root

RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY* \
    && yum -y install epel-release \
    && yum -y install nano \
    && yum -y install httpd \
    && systemctl enable httpd.service
RUN rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    && yum -y install yum-utils \
    && yum -y update
RUN yum-config-manager --enable remi-php71 \
    && yum install -y php php-mbstring php-dom php-xml git php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-fileinfo zip unzip php71-php-zip*
RUN cd /tmp \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && cd /var/www/html \
    && /usr/local/bin/composer create-project --prefer-dist laravel/laravel laravel \
    && cd /var/www/html/laravel \
    && /usr/local/bin/composer require "cooperl/laravel-ibmi":"^5.6.0" \
    && /bin/php artisan vendor:publish --force --all
RUN chmod -R 755 /var/www/html/ \
    && chmod -R 757 /var/www/html/laravel/storage
EXPOSE 80

CMD ["-D", "FOREGROUND"]
ENTRYPOINT ["/usr/sbin/httpd"]

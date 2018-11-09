FROM jefferyb/openshift-ubuntu:latest

MAINTAINER Jeffery Bagirimvano

ENV SUMMARY="Apache with latest PHP on Ubuntu using OpenShift specific guidelines." \
    DESCRIPTION="Apache with latest PHP on Ubuntu using OpenShift specific guidelines." \
    PHP_VERSION="7.2"

### Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="https://github.com/jefferyb/openshift-ubuntu-php" \
      run='docker run -itd --name ubuntu-php -u 123456 -p 8080:8080 jefferyb/openshift-ubuntu-php' \
      io.k8s.display-name="Apache with latest PHP on Ubuntu" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="php,ubuntu,starter-arbitrary-uid,starter,arbitrary,uid"

USER root

RUN apt-get update && apt-get dist-upgrade -y && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  apache2 \
  php \
  libapache2-mod-php \
  php-common \
  php-mbstring \
  php-xmlrpc \
  php-soap \
  php-gd \
  php-xml \
  php-mysql \
  php-cli \
  php-zip \
  php-pear \
  php-fpm \
  php-dev \
  php-curl \
  less \
  vim \
  wget \
  curl \
  ipmitool \
  bzip2 \
  git \
  patch \
  tar \
  unzip && \
  apt-get clean

ENV DOCUMENT_ROOT='' \
    APP_ROOT=/var/www/html \
    PHP_INI_DIR=/etc/php/${PHP_VERSION}/apache2 \
    PATH=/usr/local/bin:${PATH} HOME=${APP_ROOT}

COPY bin/ /usr/local/bin/

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer; \
# Configure apache
  echo "Configure apache"; \
  sed -i 's/80/8080/g' /etc/apache2/ports.conf; \
  sed -i 's/80/8080/g' /etc/apache2/sites-available/000-default.conf; \
  a2enmod rewrite; \
# Time Zone
  echo "Configure Time Zone"; \
  echo "date.timezone=${PHP_TIMEZONE:-UTC}" > $PHP_INI_DIR/conf.d/date_timezone.ini; \
# Display errors in stderr
  echo "Display errors in stderr"; \
  echo "display_errors=stderr" > $PHP_INI_DIR/conf.d/display-errors.ini; 

RUN chmod -R u+x /usr/local/bin && \
    chgrp -R 0 ${APP_ROOT} \
      /var/log/apache2 \
      /var/run/apache2 \
      /etc/apache2/sites-available && \
    chmod -R g=u ${APP_ROOT} \
      /etc/passwd \
      /var/log/apache2 \
      /var/run/apache2 \
      /etc/apache2/sites-available

### Containers should NOT run as root as a good practice
USER 10001

WORKDIR ${APP_ROOT}

EXPOSE 8080

### user name recognition at runtime w/ an arbitrary uid - for OpenShift deployments
ENTRYPOINT [ "uid_entrypoint" ]
# VOLUME ${APP_ROOT}
CMD [ "run" ]

# ref: https://github.com/RHsyseng/container-rhel-examples/blob/master/starter-arbitrary-uid/Dockerfile.centos7
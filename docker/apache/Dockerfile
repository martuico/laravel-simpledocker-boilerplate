FROM ubuntu:18.04
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install curl language-pack-en-base -y && locale-gen en_US.UTF-8 && export LANG=en_US.UTF-8 && export LC_ALL=en_US.UTF-8
RUN apt-get install software-properties-common -y && LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php && apt-get update

RUN apt-get install apache2 php7.2 libapache2-mod-php7.2 -y && a2enmod rewrite headers
RUN apt-get install php7.2-xml php7.2-mbstring php7.2-intl php7.2-mysql php7.2-curl php7.2-gd php7.2-sqlite3 zip php7.2-soap -y

# Composer install
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php && php -r "unlink('composer-setup.php');" && cp composer.phar bin/composer

COPY . /var/www/code
ADD . /var/www/code
WORKDIR /var/www/code

RUN chown -R www-data:www-data /var/www
# RUN chown -R www-data:www-data /var/www/code/storage
# RUN chown -R www-data:www-data /var/www/code/bootstrap/cache

RUN chmod -R 755 /var/www/
RUN find /var/www/ -type d -exec chmod 755 {} \;
RUN find /var/www/ -type f -exec chmod 644 {} \;

RUN apt-get update
RUN apt-get install git cron -y
# ADD crontab /etc/cron.d/crontab
# RUN chmod 0644 /etc/cron.d/crontab

# Install imagemagick
# RUN sed -i '/^#\sdeb-src /s/^#//' "/etc/apt/sources.list" && \
# 	apt-get update && apt-get build-dep imagemagick -y && \
# 	apt-get install wget -y && wget https://www.imagemagick.org/download/ImageMagick.tar.gz && \
# 	tar xf ImageMagick.tar.gz && \
# 	cd ImageMagick-7* && ./configure && make && make install && \
# 	ldconfig /usr/local/lib

#wkhtmltopdf
# RUN apt-get install wkhtmltopdf wget -y && \
# 	apt-get remove --purge wkhtmltopdf -y && \
# 	wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz && \
# 	tar vxf wkhtmltox-0.12.3_linux-generic-amd64.tar.xz && \
# 	cp wkhtmltox/bin/wk* /usr/local/bin/ && \
# 	ln -s /usr/local/bin/wkhtmltopdf /usr/bin/wkhtmltopdf

ADD site.conf /etc/apache2/sites-enabled/000-default.conf

ADD start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]

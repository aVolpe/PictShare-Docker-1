FROM ishakuta/docker-nginx-php5
MAINTAINER Christian Haschek <christian@haschek.at>

RUN apt-get update && apt-get install -y php5-gd

WORKDIR /opt
RUN curl -O https://codeload.github.com/chrisiaut/pictshare/zip/master

RUN apt-get install -y unzip
RUN unzip master
RUN mv pictshare-master pictshare && rm master

RUN apt-get install -y php5-fpm

WORKDIR /opt/pictshare
RUN chmod +x bin/ffmpeg

ADD pictshare.conf /etc/nginx/sites-available/default
ADD pictshare.conf /etc/nginx/sites-enabled/default

RUN chown -R www-data:www-data /opt/pictshare
RUN sed -i -e 's/2M/50M/g' /etc/php5/fpm/php.ini
RUN sed -i -e 's/ 8M/ 50M/g' /etc/php5/fpm/php.ini

EXPOSE 80

VOLUME /opt/pictshare/upload

ADD pictshare.sh /opt/
RUN chmod +x /opt/pictshare.sh

ENTRYPOINT ["/opt/pictshare.sh"]
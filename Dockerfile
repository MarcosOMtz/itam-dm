## Esta imagen es una modificación de la rocker/hadleyverse

## Iniciamos con la imagen de rstudio dada por rocker
FROM debian:testing

MAINTAINER "Adolfo J. De Unánue" adolfo.deunanue@itam.mx

## Actualizamos
RUN apt-get update -qq \
&& apt-get dist-upgrade -y

RUN apt-get update -qq \
&& apt-get install -y --no-install-recommends \
  ed \
  less \
  littler \
  locales \
  r-base \
  r-base-dev \
  vim-tiny \
  wget \
&& cd /tmp/ \
&& wget http://dirk.eddelbuettel.com/code/debian/testing/littler_0.2.0.2-1_amd64.deb \
&& dpkg -i littler_0.2.0.2-1_amd64.deb \
&& rm littler_0.2.0.2-1_amd64.deb \
&& ln -s /usr/share/doc/littler/examples/install.r /usr/local/bin/install.r \
&& ln -s /usr/share/doc/littler/examples/install2.r /usr/local/bin/install2.r \
&& ln -s /usr/share/doc/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
&& ln -s /usr/share/doc/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
&& install.r docopt \
&& rm -rf /tmp/downloaded_packages/

## Establecemos un repo por default de CRAN
RUN echo 'options("repos"="http://cran.rstudio.com", encoding="UTF-8")' >> /etc/R/Rprofile.site

## Creamos un usuario docker
RUN useradd docker
RUN addgroup docker staff

## Arreglamos el locale
RUN echo "es_MX.UTF-8 UTF-8" >> /etc/locale.gen \
&& locale-gen es_MX.utf8 \
&& /usr/sbin/update-locale LANG=es_MX.UTF-8
ENV LC_ALL es_MX.UTF-8

## Evitamos que apt esté preguntando
ENV DEBIAN-FRONTEND noninteractive
ENV PATH /usr/lib/rstudio-server/bin/:$PATH

## Instalamos RstudioServer
RUN apt-get update && apt-get install -y \
  git \
  libcurl4-openssl-dev \
  psmisc \
  supervisor \
  sudo \
&& wget -q http://ftp.us.debian.org/debian/pool/main/o/openssl/libssl0.9.8_0.9.8o-4squeeze14_amd64.deb \
&& dpkg -i libssl0.9.8_0.9.8o-4squeeze14_amd64.deb && rm libssl0.9.8_0.9.8o-4squeeze14_amd64.deb \
&& (wget -q https://s3.amazonaws.com/rstudio-server/current.ver -O currentVersion.txt \
&& ver=$(cat currentVersion.txt) \
&& wget -q http://download2.rstudio.org/rstudio-server-${ver}-amd64.deb \
&& dpkg -i rstudio-server-${ver}-amd64.deb \
&& rm rstudio-server-*-amd64.deb currentVersion.txt )

## Script que configura el ambiente
COPY userconf.sh /usr/bin/userconf.sh

## Configure persistent daemon serving RStudio-server on (container) port 8787
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8787
## To have a container run a persistent task, we use the very simple supervisord as recommended in Docker documentation.
CMD ["/usr/bin/supervisord"]

## Agregamos los binarios de CRAN y actualizamos
RUN echo 'deb http://debian-r.debian.net/debian-r/ unstable main' >> /etc/apt/sources.list
#RUN gpg --keyserver keyserver.ubuntu.com --recv-keys AE05705B842492A68F75D64E01BF7284B26DD379
#RUN gpg --export AE05705B842492A68F75D64E01BF7284B26DD379  | apt-key add -
#RUN gpg --check-sigs AE05705B842492A68F75D64E01BF7284B26DD379

## Necesitamos el deb-src para poder hacer apt-get build-dep
RUN echo 'deb-src http://debian-r.debian.net/debian-r/ unstable main' >> /etc/apt/sources.list \
&& echo 'deb-src http://http.debian.net/debian testing main' >> /etc/apt/sources.list


## Necesitamos pandoc
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ghostscript \
    imagemagick \
    lmodern \
    pandoc \
    pandoc-citeproc \
    texlive-fonts-recommended \
    texlive-humanities \
    texlive-latex-extra \
    libcairo2-dev \
    libxt-dev


## Instalamos las depenencias de R con build-dep
RUN apt-get update && apt-get build-dep -y \
    r-cran-rgl \
    r-cran-rjava \
    r-cran-rmysql \
    r-cran-rpostgresql \
    r-cran-rsqlite \
    r-cran-rsqlite.extfuns \
    r-cran-xml

RUN install2.r -r http://bioconductor.org/packages/2.13/bioc \
    BiocInstaller \
    && rm -rf /tmp/downloaded_packages/


## Instalamos las bibliotecas que probablemente necesitemos en el curso
RUN install2.r --error --deps TRUE \
    devtools \
    dplyr \
    ggplot2 \
    httr \
    knitr \
    Rcpp \
    reshape2 \
    rmarkdown \
    roxygen2 \
    testthat \
    ggvis \
    lubridate \
    plyr \
    reshape2 \
    randomForest \
    rmarkdown \
    shiny \
    zoo \
    xts \
    arules \
#    arulesViz \
    twitteR \
    party \
    tidyr && \
    rm -rf /tmp/downloaded_packages/

## Agregamos un repositorio de reshape para tener siempre las últimas versiones (al parecer hay bugs en la versión de CRAN)
RUN installGithub.r hadley/reshape \
&& rm -rf /tmp/downloaded_packages/

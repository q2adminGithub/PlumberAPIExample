FROM rocker/r-ver:latest

# install os dependencies
RUN apt-get update -qq
RUN apt-get install -y --no-install-recommends \
  git-core \
  libssl-dev \
  libcurl4-gnutls-dev \
  curl \
  libsodium-dev \
  libxml2-dev \
  && rm -rf /var/lib/apt/lists/*

# install pak alternatives to install.packages
RUN Rscript -e "install.packages('pak', repos = sprintf('https://r-lib.github.io/p/pak/stable'))"

# install latest plumber from github main branch
RUN Rscript -e "pak::pkg_install('rstudio/plumber@main')"

# install other R packages
RUN Rscript -e "pak::pkg_install(c('logger','tictoc','fs','magrittr','yaml'))"
RUN Rscript -e "pak::pkg_install(c('testthat', 'httr'))"

# setup workspace
COPY . /app

WORKDIR /app

ENTRYPOINT ["Rscript"]

CMD ["app.R"]
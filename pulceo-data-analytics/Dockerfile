FROM rocker/verse:4.4.3
# RUN apt-get update && apt-get install -y \
#     libcurl4-openssl-dev \
#     libssl-dev \
#     libxml2-dev \
#     pandoc \
#     && rm -rf /var/lib/apt/lists/*
COPY /app/pda.R /app/pda.R
COPY pulceo-data-analytics-offloading.Rmd /app/pulceo-data-analytics-offloading.Rmd
WORKDIR /app
EXPOSE 8181
RUN R -e "install.packages(c('plumber', 'rjson', 'kableExtra'), repos='http://cran.us.r-project.org')"
CMD ["R", "-e", "pr <- plumber::plumb('pda.R'); pr$run(host='0.0.0.0', port=8181)"]
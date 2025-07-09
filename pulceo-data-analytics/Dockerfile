FROM rocker/verse:4.4.3
RUN apt-get upds.te && apt-get install -y libhiredis-dev libhiredis1.1.0 && apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /pulceo-data-analytics/prs
RUN R -e "install.packages(c('plumber', 'DT', 'kableExtra', 'gridExtra', 'ggpubr', 'redux'), repos='http://cran.us.r-project.org')"
COPY /prs/prs.R /pulceo-data-analytics/prs/prs.R
COPY /prs/prs-worker.R  /pulceo-data-analytics/prs/worker.R
COPY /prs/prs.sh /pulceo-data-analytics/prs/prs.sh
COPY pulceo-data-analytics.Rmd /pulceo-data-analytics/pulceo-data-analytics.Rmd
COPY pulceo-data-analytics.Rproj /pulceo-data-analytics/pulceo-data-analytics.Rproj
ENV REDIS_HOST=localhost
ENV PORT=6379
EXPOSE 8181
CMD ["sh", "/pulceo-data-analytics/prs/prs.sh"]

FROM rocker/verse:4.4.3
RUN apt-get update && apt-get install -y libhiredis-dev libhiredis1.1.0 && apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /pulceo-data-analytics/app
RUN R -e "install.packages(c('plumber', 'rjson', 'kableExtra', 'gridExtra', 'ggpubr', 'redux'), repos='http://cran.us.r-project.org')"
COPY /app/pda.R /pulceo-data-analytics/app/pda.R
COPY /app/worker.R  /pulceo-data-analytics/app/worker.R
COPY /app/pda.sh /pulceo-data-analytics/app/pda.sh
COPY pulceo-data-analytics.Rmd /pulceo-data-analytics/pulceo-data-analytics.Rmd
ENV REDIS_HOST=localhost
ENV PORT=6379
EXPOSE 8181
CMD ["sh", "/pulceo-data-analytics/app/pda.sh"]
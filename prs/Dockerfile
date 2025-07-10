FROM rocker/verse:4.4.3
RUN apt-get update && apt-get install -y libhiredis-dev libhiredis1.1.0 && apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /pulceo-data-analytics/prs
RUN R -e "install.packages(c('plumber', 'DT', 'kableExtra', 'gridExtra', 'ggpubr', 'redux'), repos='http://cran.us.r-project.org')"
COPY src .
RUN mkdir /rmarkdown
ENV RMARKDOWN_DIR=/rmarkdown
ENV REDIS_HOST=localhost
ENV PORT=6379
EXPOSE 8181
CMD ["sh", "/pulceo-data-analytics/prs/prs.sh"]

FROM rocker/verse:4.4.3
WORKDIR /app
RUN R -e "install.packages(c('plumber', 'rjson', 'kableExtra', 'gridExtra', 'ggpubr', 'redux'), repos='http://cran.us.r-project.org')"
COPY /app/pda.R /app/pda.R
COPY pulceo-data-analytics-offloading.Rmd /app/pulceo-data-analytics-offloading.Rmd
EXPOSE 8181
# CMD ["Rscript", "worker.R"]
CMD ["R", "-e", "pr <- plumber::plumb('pda.R'); pr$run(host='0.0.0.0', port=8181)"]
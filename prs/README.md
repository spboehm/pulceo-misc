# Pulceo-Data-Analytics (Renderer)

## How to run

Start the middleware:

```bash
docker-compose -f ../middleware/docker-compose.yml up -d
```

Start the background worker:

```bash
Rscript prs-worker.R
```

Start the web server (RESTful API):

```bash
R -e "pr <- plumber::plumb('prs.R'); pr\$run(host='0.0.0.0', port=8181)"
```

Run with docker:

```bash
docker run -d \
    -e PULCEO_DATA_DIR="/tmp/psm-data" \
    -e RMARKDOWN_DIR="/rmarkdown" \
    -e REDIS_HOST=middleware-redis-1 \
    -e REDIS_PORT=6379 \
    -p 8181:8181 \
    -v $PWD/../pulceo-data-analytics:/rmarkdown:ro \
    -v /tmp/psm-data:/tmp/psm-data:rw \
    --network middleware_pulceo-redis \
    --name pulceo-report-service \
    pulceo-report-service:latest
```

```bash
docker pull ghcr.io/spboehm/pulceo-report-service:latest
```

## How to build

```bash
docker build -t pulceo-report-service:latest .
```

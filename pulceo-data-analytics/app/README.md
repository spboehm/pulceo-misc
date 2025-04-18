# Pulceo-Data-Analytics (Renderer)

## How to run

Start the middleware:

```bash
docker-compose -f ../middleware/docker-compose.yml up -d
```

Start the background worker:
```bash
Rscript worker.R
```

Start the web server (RESTful API):
```bash
R -e "pr <- plumber::plumb('pda.R'); pr\$run(host='0.0.0.0', port=8181)"
```

Run with docker:

```bash
docker run -d \
    -e REDIS_HOST=middleware-redis-1 \
    -e REDIS_PORT=6379 \
    -p 8181:8181 \
    --network middleware_pulceo-redis \
    --name pulceo-data-analytics \
    pda:latest
```

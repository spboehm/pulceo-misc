#!/bin/bash
trap 'kill $(cat worker.pid); rm -f worker.pid; exit' SIGINT SIGTERM
nohup Rscript prs-worker.R > prs-worker.log 2>&1 &
echo $! > worker.pid
R -e "pr <- plumber::plumb('prs.R'); pr\$run(host='0.0.0.0', port=8181)"

#!/bin/bash
nohup Rscript worker.R > pda-worker.log 2>&1 &
R -e "pr <- plumber::plumb('pda.R'); pr\$run(host='0.0.0.0', port=8181)"

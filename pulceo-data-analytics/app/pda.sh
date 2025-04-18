#!/bin/bash
nohup Rscript worker.R &
R -e "pr <- plumber::plumb('pda.R'); pr\$run(host='0.0.0.0', port=8181)"

#!/bin/bash
TMP_PATH="/tmp/ios-microos"
mkdir -p -m 0777 $TMP_PATH
mkisofs -full-iso9660-filenames -o $TMP_PATH/combustion.iso -V combustion combustion-ignition
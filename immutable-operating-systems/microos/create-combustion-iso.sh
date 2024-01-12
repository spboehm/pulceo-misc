#!/bin/bash
TMP_PATH="/tmp/ios-microos"
mkdir -p -m 0777 $TMP_PATH
rm -rf /tmp/ios-microos/*
for i in {0..2}
do
    cp -R combustion-ignition $TMP_PATH/combustion-ignition-${i}
    cp vars/server${i}.env $TMP_PATH/combustion-ignition-${i}/combustion/server.env
    mkisofs -full-iso9660-filenames -o $TMP_PATH/combustion-${i}.iso -V combustion $TMP_PATH/combustion-ignition-${i}
done

#!/bin/bash

echo "starting run.sh"

SAXON="/utils/saxon.jar"
CMV="/utils/cmv-cmd.jar"

echo "Dev script to auto-transform XSLT while editing the XSLT"
echo "start watch for modifications in $XSLT"
echo "result will be shown in $XML.result.xml"
while inotifywait -q -e modify $XSLT; do
    java -jar $SAXON $XML $XSLT -o:$XML.result.xml

    if [[ ! -z "$PROFILE" ]]; then
        VGATE=${GATE:="BASIC"}
        echo "CMM-VALIDATOR USING GATE: $VGATE"
        java -jar $CMV $XML.result.xml $PROFILE $VGATE
    fi
done

#!/bin/bash

echo "starting run.sh"

cd "$(dirname "$0")"

SAXON="/utils/saxon.jar"

echo "Dev script to auto-transform XSLT while editing the XSLT"
echo "start watch for modifications in $XSLT"
echo "result will be shown in $XML.result.xml"
while inotifywait -q -e modify $XSLT; do
    java -jar $SAXON $XML $XSLT -o:$XML.result.xml
done

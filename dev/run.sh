#!/bin/bash
cd "$(dirname "$0")"

XSLT="../transformations/datacite/from-ddi-3.1/ddi_3_1-datacite_3_1.xsl"
XML="../examples/ddi-3.1/example-1.xml"

echo "Dev script to auto-transform XSLT while editing the XSLT"
echo "start watch for modifications in $XSLT"
echo "result will be shown in $XML.result.xml"
while inotifywait -q -e modify $XSLT; do
    java -jar /home/olof/utils/saxon/saxon-he-10.5.jar $XML $XSLT -o:$XML.result.xml
done

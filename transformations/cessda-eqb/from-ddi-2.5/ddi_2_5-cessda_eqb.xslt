<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:c="ddi:codebook:2_5"
    xmlns:meta="transformation:metadata"
    xmlns:ddi="http://www.ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/codebook.xsd"   
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xsi:schemaLocation="ddi:codebook:2_5 http://www.ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/codebook.xsd" xmlns="ddi:codebook:2_5"
    exclude-result-prefixes=""
    version="2.0">

    <xsl:output method="xml" indent="yes" />

    <!-- root template -->
    <xsl:template match="/c:codeBook" > 
        <codeBook>
            <xsl:apply-templates select="./c:stdyDscr"/>
        </codeBook>
    </xsl:template>
    
    <xsl:template match="c:stdyDscr">
        <stdyDscr>
            <citation>
                <xsl:copy-of select="./c:citation/c:titlStmt"/>
            </citation>
        </stdyDscr>
    </xsl:template>
</xsl:stylesheet>
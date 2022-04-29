<?xml version="1.0" encoding="UTF-8"?>
<!-- ddi2-5-to-meta-share.xsl -->
<!-- converts a DDI 2.5 intance to Meta-Share -->

<xsl:stylesheet 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:xml="http://www.w3.org/XML/1998/namespace" 
 xmlns:meta="transformation:metadata"
 xmlns:c="ddi:codebook:2_5" 
 xmlns:ddi="http://www.ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/codebook.xsd" 
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 version="2.0" 
 exclude-result-prefixes="#all">

    <meta:metadata>
        <identifier>ddi-2.5-to-metashare</identifier>
        <title>DDI 2.5 to Meta-Share</title>
        <description>Convert DDI Codebook (2.5) to Meta-Share</description>
        <outputFormat>XML</outputFormat>
    </meta:metadata>

    <xsl:output method="xml" indent="yes" />

    <xsl:template match="/">
        <resourceInfo>
            <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
            <xsl:namespace name="xsd">http://www.w3.org/2001/XMLSchema</xsl:namespace>
            <xsl:attribute name="xsi:schemaLocation">http://www.ilsp.gr/META-XMLSchema http://metashare.ilsp.gr/META-XMLSchema/v3.0/META-SHARE-Resource.xsd</xsl:attribute>
            <xsl:apply-templates select="//c:stdyDscr" />
        </resourceInfo>
    </xsl:template>

    <xsl:template match="c:stdyDscr">
        <distributionInfo>
            <xsl:copy-of select="meta:mapLiteral('availability', c:dataAccs/c:setAvail/c:avlStatus)" />
        </distributionInfo>
        <resourceCreationInfo>
            <xsl:copy-of select="meta:mapLiteral('resourceCreator', c:citation/c:rspStmt/c:AuthEnty)" />
        </resourceCreationInfo>
        <identificationInfo>
            <xsl:copy-of select="meta:mapLiteral('identifier', c:citation/c:titlStmt/c:IDNo)" />
            <xsl:copy-of select="meta:mapLiteral('resourceName', c:citation/c:titlStmt/c:titl)" />
            <xsl:copy-of select="meta:mapLiteral('resourceName', c:citation/c:titlStmt/c:altTitl)" />
            <xsl:copy-of select="meta:mapLiteral('description', c:stdyInfo/c:abstract)" />
        </identificationInfo>
        <relationInfo>
            <xsl:copy-of select="meta:mapLiteral('relationType', c:othrStdyMat)" />
            <xsl:copy-of select="meta:mapLiteral('targetResourceNameURI', c:othrStdyMat)" />
        </relationInfo>
    </xsl:template>
    <xsl:function name="meta:mapLiteral">
    <xsl:param name="element" />
    <xsl:param name="content" />

    <xsl:for-each select="$content">
        <xsl:element name="{$element}">
        <xsl:copy-of select="@xml:lang" />
        <xsl:value-of select ="." />
        </xsl:element>
    </xsl:for-each> 
    </xsl:function>
</xsl:stylesheet>
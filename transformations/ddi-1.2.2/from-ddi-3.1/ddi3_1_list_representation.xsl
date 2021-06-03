<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.icpsr.umich.edu/DDI" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:g="ddi:group:3_1" xmlns:d="ddi:datacollection:3_1" xmlns:dce="ddi:dcelements:3_1"
    xmlns:c="ddi:conceptualcomponent:3_1" xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:a="ddi:archive:3_1" xmlns:m1="ddi:physicaldataproduct/ncube/normal:3_1"
    xmlns:ddi="ddi:instance:3_1" xmlns:m2="ddi:physicaldataproduct/ncube/tabular:3_1"
    xmlns:o="ddi:organizations:3_1" xmlns:l="ddi:logicalproduct:3_1"
    xmlns:m3="ddi:physicaldataproduct/ncube/inline:3_1" xmlns:pd="ddi:physicaldataproduct:3_1"
    xmlns:cm="ddi:comparative:3_1" xmlns:s="ddi:studyunit:3_1" xmlns:r="ddi:reusable:3_1"
    xmlns:pi="ddi:physicalinstance:3_1" xmlns:ds="ddi:dataset:3_1" xmlns:pr="ddi:profile:3_1"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:util="https://code.google.com/p/ddixslt/#util" version="2.0"
    xsi:schemaLocation="http://www.icpsr.umich.edu/DDI http://www.icpsr.umich.edu/DDI/Version1-2-2.xsd">

    <!-- 
    Output a property list defined by variable representation as:
    
     - Key = type[code, numeric, string, date] 
     - Value = variable name
    -->

    <!-- output -->
    <xsl:output method="text" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

    <!-- param -->
    <xsl:param name="delimiter">###</xsl:param>

    <xsl:template match="ddi:DDIInstance">
        <!-- code -->
        <xsl:variable name="code">
            <xsl:for-each select="*//l:Variable/l:Representation/l:CodeRepresentation">
                <xsl:call-template name="varName"/>
            </xsl:for-each>
            <xsl:text>&#10;</xsl:text>
        </xsl:variable>
        <xsl:text>code=</xsl:text>
        <xsl:value-of select="$code"/>

        <!-- numeric -->
        <xsl:variable name="numeric">
            <xsl:for-each select="*//l:Variable/l:Representation/l:NumericRepresentation">
                <xsl:call-template name="varName"/>
            </xsl:for-each>
            <xsl:text>&#10;</xsl:text>
        </xsl:variable>
        <xsl:text>numeric=</xsl:text>
        <xsl:value-of select="$numeric"/>

        <!-- string -->
        <xsl:variable name="string">
            <xsl:for-each select="*//l:Variable/l:Representation/l:TextRepresentation">
                <xsl:call-template name="varName"/>
            </xsl:for-each>
            <xsl:text>&#10;</xsl:text>
        </xsl:variable>
        <xsl:text>string=</xsl:text>
        <xsl:value-of select="$string"/>

        <!-- date -->
        <xsl:variable name="date">
            <xsl:for-each select="*//l:Variable/l:Representation/l:DateTimeRepresentation">
                <xsl:call-template name="varName"/>
            </xsl:for-each>
            <xsl:text>&#10;</xsl:text>
        </xsl:variable>
        <xsl:text>date=</xsl:text>
        <xsl:value-of select="$date"/>
    </xsl:template>

    <xsl:template name="varName">
        <xsl:value-of select="../../l:VariableName"/>
        <xsl:if test="position() != last()">
            <xsl:value-of select="$delimiter"/>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>

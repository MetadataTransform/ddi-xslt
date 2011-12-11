<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : ddi-datacite.xsl
    Created on : den 11 december 2011, 22:29
    Description: extract metadata from DDI 3.1 to DataCite metadata
    
    DOC: http://schema.datacite.org/meta/kernel-2.2/doc/DataCite-MetadataKernel_v2.2.pdf
-->

<xsl:stylesheet 
                xmlns="http://www.w3.org/1999/xhtml"
		xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:g="ddi:group:3_1"
                xmlns:d="ddi:datacollection:3_1"
                xmlns:dce="ddi:dcelements:3_1"
                xmlns:c="ddi:conceptualcomponent:3_1"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:a="ddi:archive:3_1"
                xmlns:m1="ddi:physicaldataproduct/ncube/normal:3_1"
                xmlns:ddi="ddi:instance:3_1 http://www.ddialliance.org/sites/default/files/schema/ddi3.1/instance.xsd"
                xmlns:m2="ddi:physicaldataproduct/ncube/tabular:3_1"
                xmlns:o="ddi:organizations:3_1"
                xmlns:l="ddi:logicalproduct:3_1"
                xmlns:m3="ddi:physicaldataproduct/ncube/inline:3_1"
                xmlns:pd="ddi:physicaldataproduct:3_1"
                xmlns:cm="ddi:comparative:3_1"
                xmlns:s="ddi:studyunit:3_1"
                xmlns:r="ddi:reusable:3_1"
                xmlns:pi="ddi:physicalinstance:3_1"
                xmlns:ds="ddi:dataset:3_1"
                xmlns:pr="ddi:profile:3_1"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://datacite.org/schema/kernel-2.2 http://schema.datacite.org/meta/kernel-2.2/metadata.xsd"
                version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <!-- If no DOI is present in the DDI-instace provide this as a paramater-->
    <xsl:param name="doi"></xsl:param>
    
    <xsl:template match="//s:StudyUnit">
        <resource>
            <identifier identifierType="DOI"><xsl:value-of select="$doi"/></identifier>
            
            <titles>
                <title><xsl:value-of select="r:Citation/r:Title"/></title>
            </titles>
        </resource>
    </xsl:template>

</xsl:stylesheet>

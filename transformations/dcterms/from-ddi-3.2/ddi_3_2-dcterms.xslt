<?xml version="1.0" encoding="UTF-8"?>
<!--
    
Description:
XSLT Stylesheet for conversion between DDI-L version 3.2 and dc/dcterms

This file is free software: you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation, either
version 3 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library.  If not, see <http://www.gnu.org/licenses/>.

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:dc2="ddi:dcelements:3_2" 
    xmlns:g="ddi:group:3_2" 
    xmlns:d="ddi:datacollection:3_2"                 
    xmlns:c="ddi:conceptualcomponent:3_2"                 
    xmlns:a="ddi:archive:3_2"
    xmlns:m1="ddi:physicaldataproduct/ncube/normal:3_2" 				
    xmlns:m2="ddi:physicaldataproduct/ncube/tabular:3_2" 
    xmlns:m3="ddi:physicaldataproduct/ncube/inline:3_2" 
    xmlns:ddi="ddi:instance:3_2"
    xmlns:l="ddi:logicalproduct:3_2" 				
    xmlns:pd="ddi:physicaldataproduct:3_2"
    xmlns:p="ddi:physicaldataproduct:3_2"
    xmlns:cm="ddi:comparative:3_2" 
    xmlns:s="ddi:studyunit:3_2" 
    xmlns:r="ddi:reusable:3_2" 
    xmlns:pi="ddi:physicalinstance:3_2" 
    xmlns:ds="ddi:dataset:3_2" 
    xmlns:pr="ddi:profile:3_2"
    xmlns:meta="transformation:metadata"
    xsi:schemaLocation="ddi:instance:3_2 https://ddialliance.org/Specification/DDI-Lifecycle/3.2/XMLSchema/instance.xsd"
    exclude-result-prefixes="#all"
    version="2.0">
    <meta:metadata>
        <identifier>ddi-3.2-to-dcterms</identifier>
        <title>DDI 3.2 to Dcterms</title>
        <description>Convert DDI Lifecycle (3.2) to Dcterms</description>
        <outputFormat>XML</outputFormat>
        <parameters>
            <parameter name="root-element" format="xs:string" description="Root element"/>
        </parameters>
    </meta:metadata>
    
    <xsl:output method="xml" indent="yes" />
    <xsl:param name="root-element">metadata</xsl:param>
    
    <xsl:template match="/">
        <xsl:element name="{$root-element}">
            <xsl:namespace name="xs">http://www.w3.org/2001/XMLSchema</xsl:namespace>
            <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
            <xsl:namespace name="dcterms">http://purl.org/dc/terms/</xsl:namespace>

            <xsl:copy-of select="meta:mapLiteral('dcterms:identifier', //s:StudyUnit/r:Citation/r:InternationalIdentifier/r:IdentifierContent)" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:title', //s:StudyUnit/r:Citation/r:Title/r:String)" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:alternative', //s:StudyUnit/r:Citation/r:AlternativeTitle/r:String)" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:language', //s:StudyUnit/r:Citation/r:Language)" />
            <xsl:apply-templates select="//s:StudyUnit//r:Creator" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:abstract', //s:StudyUnit/r:Abstract/r:Content)" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:subject', //s:StudyUnit/r:Coverage/r:TopicalCoverage/r:Subject)" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:subject', //s:StudyUnit/r:Coverage/r:TopicalCoverage/r:Keyword)" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:format', //s:StudyUnit/PhysicalDataProduct/p:PhysicalStructureScheme/p:PhysicalStructure/p:Format)" />

            <xsl:apply-templates select="//pi:PhysicalInstance/pi:GrossFileStructure/pi:OverallRecordCount" />
            <xsl:apply-templates select="//pi:PhysicalInstance/pi:GrossFileStructure/pi:CaseQuantity" />
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="r:Creator|a:Individual">
        <xsl:choose>
          <xsl:when test="r:CreatorName">
             <xsl:copy-of select="meta:mapLiteral('dcterms:creator', ./r:CreatorName/r:String)" />
          </xsl:when>
          <xsl:when test="r:CreatorReference">
            <xsl:variable name="id" select="./r:CreatorReference/r:ID" />
            <xsl:apply-templates select="//a:Individual[./r:ID=$id]" />
          </xsl:when>
          <xsl:when test="a:IndividualIdentification">
             <xsl:copy-of select="meta:mapLiteral('dcterms:creator', ./a:IndividualIdentification/a:IndividualName/a:FullName/r:String)" />
          </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="pi:OverallRecordCount">
        <dcterms:extent>
            <xsl:text>records: </xsl:text>
            <xsl:value-of select="."/>
        </dcterms:extent>
    </xsl:template>

    <xsl:template match="pi:CaseQuantity">
        <dcterms:extent>
            <xsl:text>cases: </xsl:text>
            <xsl:value-of select="."/>
        </dcterms:extent>
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
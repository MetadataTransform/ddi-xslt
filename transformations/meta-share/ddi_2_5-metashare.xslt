<?xml version="1.0" encoding="UTF-8"?>
<!-- ddi2-5-to-meta-share.xsl -->
<!-- converts a DDI 2.5 intance to Meta-Share -->

<xsl:stylesheet version="2.0" 
    xmlns:xsl       ="http://www.w3.org/1999/XSL/Transform"

    xmlns:si        ="http://www.w3schools.com/rdf/" 
    xmlns:owl       ="http://www.w3.org/2002/07/owl#" 
    xmlns:skosclass ="http://ddialliance.org/ontologies/skosclass"
    xmlns:xml       ="http://www.w3.org/XML/1998/namespace" 

    xmlns:skos      ="http://www.w3.org/2004/02/skos/core#" 

    xmlns:meta="transformation:rdf"
    xmlns:c="ddi:codebook:2_5"
    xmlns:ddi     ="http://www.ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/codebook.xsd"


    xmlns:ms="http://www.ilsp.gr/META-XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xsi:schemaLocation="http://www.ilsp.gr/META-XMLSchema http://metashare.ilsp.gr/META-XMLSchema/v3.0/META-SHARE-Resource.xsd" xmlns="http://www.ilsp.gr/META-XMLSchema"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"

    exclude-result-prefixes="#all">

    <meta:metadata>
        <identifier>ddi-2.5-to-metashare</identifier>
        <title>DDI 2.5 to RDF/XML</title>
        <description>Convert DDI Codebook (2.5) to Meta-Share</description>
        <outputFormat>XML</outputFormat>
    </meta:metadata>

    <xsl:param name="root-element">resourceInfo</xsl:param> 


    <xsl:output method="xml" indent="yes"/>

    <xsl:param name="studyURI">
        <xsl:choose>
            <xsl:when test="//c:stdyDscr/c:citation/c:titlStmt/c:IDNo!=''">
                <xsl:value-of select="//c:stdyDscr/c:citation/c:titlStmt/c:IDNo[@agency='DataCite']"/>
            </xsl:when>
            <xsl:when test="//c:codeBook/@ID">
                <xsl:value-of select="//c:codeBook/@ID"/>
            </xsl:when>
        </xsl:choose>
    </xsl:param>


    <xsl:template match="/">
        <xsl:element name="{$root-element}">
            <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
            <xsl:namespace name="xsd">http://www.w3.org/2001/XMLSchema</xsl:namespace>
            <xsl:namespace name="schemaLocation">http://www.ilsp.gr/META-XMLSchema http://metashare.ilsp.gr/META-XMLSchema/v3.0/META-SHARE-Resource.xsd</xsl:namespace>

            <xsl:apply-templates select="//c:stdyDscr" />
        </xsl:element>
    </xsl:template>

    <xsl:template match="c:stdyDscr">
        <IdentificationInfo>
            <xsl:for-each select="$studyURI">
                <identifier>
                    <xsl:value-of select="." />
                </identifier>
            </xsl:for-each>

            <xsl:for-each select="c:citation/c:titlStmt/c:titl|c:citation/c:titlStmt/c:altTitl|c:titl|c:citation/c:titlStmt/c:parTitl">
                <resourceName>
                        <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                        <xsl:value-of select="." />
                </resourceName>
            </xsl:for-each>

            <xsl:for-each select="c:stdyInfo/c:abstract">
                <description>
                        <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                        <xsl:value-of select="." />    
                </description>
            </xsl:for-each>
        </IdentificationInfo>
        <relationInfo>
                <xsl:for-each select="c:othrStdyMat">
                    <relationType>
                        <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                        <xsl:value-of select="." />
                    </relationType>
                </xsl:for-each>

                <xsl:for-each select="c:othrStdyMat">
                    <targetResourceNameURI>
                        <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                        <xsl:value-of select="." />
                    </targetResourceNameURI>
                </xsl:for-each>
        
        </relationInfo>
    </xsl:template>
</xsl:stylesheet>



<?xml version="1.0" encoding="UTF-8"?>

<!--
Document : ddi2-1-to-rdf.xsl Description: converts a DDI 2.1 intance to RDF
-->
<xsl:stylesheet version="1.0" 
    xmlns:xsl       = "http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf       = "http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:si        = "http://www.w3schools.com/rdf/" 
    xmlns:owl       = "http://www.w3.org/2002/07/owl#" 
    xmlns:skosclass = "http://ddialliance.org/ontologies/skosclass"
    xmlns:xml       = "http://www.w3.org/XML/1998/namespace" 
    xmlns:rdfs      = "http://www.w3.org/2000/01/rdf-schema#"
    xmlns:xsi       = "http://www.w3.org/2001/XMLSchema-instance"
    xmlns:skos      = "http://www.w3.org/2004/02/skos/core#" 
    xmlns:dc        = "http://purl.org/dc/elements/1.1/"
    xmlns:dcterms   = "http://purl.org/dc/terms/" 
    xmlns:ddionto   = "http://ddialliance.org/def#"
    xmlns:ddi       = "http://ddialliance.org/data/" 
    xmlns:ddicb     = "http://www.icpsr.umich.edu/DDI">
    <xsl:output method="xml" indent="yes"/>

    
    <xsl:include href="ddi2-1_datacollection.xsl"/>
    
    <xsl:include href="ddi2-1_logicalproduct.xsl"/>

    <!-- render text-elements of this language-->
    <xsl:param name="lang">en</xsl:param>

    <xsl:template match="ddicb:codeBook">
        <xsl:if test="@xml-lang">
            <xsl:param name="lang" select="@xml-lang"/>
        </xsl:if>
        
        <rdf:RDF>
            <xsl:apply-templates select="ddicb:stdyDscr" />

            <!-- Including Variables  -->
            <xsl:apply-templates select="ddicb:dataDscr" mode="complete"/>
        </rdf:RDF>
    </xsl:template>
    <xsl:template match="ddicb:stdyDscr">
        <!--     <ddionto:Study> -->
        <rdf:Description>
            <xsl:attribute name="rdf:about">
                <xsl:text>http://ddialliance.org/data/</xsl:text>
                <xsl:choose>
                    <xsl:when test="ddicb:citation/ddicb:titlStmt/ddicb:IDNo!=''">
                        <xsl:value-of select="ddicb:citation/ddicb:titlStmt/ddicb:IDNo" />
                    </xsl:when>
                    <xsl:otherwise><xsl:value-of select="../ID" /></xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>

            <rdf:type rdf:resource="http://ddialliance.org/def#Study" />
            <rdf:type rdf:resource="http://ddialliance.org/def#LogicalDataset" />
            <dc:identifier>
                <xsl:text>http://ddialliance.org/data/</xsl:text>
                <xsl:choose>
                    <xsl:when test="ddicb:citation/ddicb:titlStmt/ddicb:IDNo!=''">
                        <xsl:value-of select="ddicb:citation/ddicb:titlStmt/ddicb:IDNo" />
                    </xsl:when>
                    <xsl:otherwise><xsl:value-of select="../ID" /></xsl:otherwise>
                </xsl:choose>
            </dc:identifier>

            <xsl:apply-templates select="ddicb:citation" />

            <xsl:apply-templates select="ddicb:stdyInfo" />
            <xsl:apply-templates select="../ddicb:dataDscr" mode="reference"/>
        </rdf:Description>
    </xsl:template>

    <xsl:template match="ddicb:citation">
        <dc:title>
            <xsl:attribute name="xml:lang"><xsl:value-of select="$lang"/></xsl:attribute>
            <xsl:value-of select="ddicb:titlStmt/ddicb:titl" />
        </dc:title>

    </xsl:template>

    <xsl:template match="ddicb:stdyInfo">
        <dc:abstract>
            <xsl:value-of select="ddicb:abstract" />
        </dc:abstract>
        <xsl:for-each select="ddicb:subject/ddicb:topcClas">
            <dc:subject>
                <xsl:attribute name="xml:lang">
                    <xsl:choose>
                        <xsl:when test="@xml-lang"><xsl:value-of select="$lang"/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="$lang"/></xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="xml:lang"><xsl:value-of select="$lang"/></xsl:attribute>
                <xsl:value-of select="." />
            </dc:subject>
        </xsl:for-each>    
        <xsl:for-each select="ddicb:subject/ddicb:keyword">
            <dc:subject><xsl:value-of select="." /></dc:subject>
        </xsl:for-each>    
        <xsl:apply-templates select="ddicb:sumDscr" />

    </xsl:template>
    
    <xsl:template match="ddicb:dataAccs">
        
    </xsl:template>
    

    <xsl:template match="ddicb:sumDscr">
        <!--
        <dcterms:temporal xsi:type="dcterms:Period">
            start=<xsl:value-of select="ddicb:timePrd[@event='start']" />; end=<xsl:value-of select="ddicb:timePrd[@event='end']" />;
        </dcterms:temporal>
        -->
        <xsl:if test="ddicb:nation">
            <dc:coverage>
                <xsl:value-of select="ddicb:nation" />
            </dc:coverage>
        </xsl:if>
        
        <!--
        <xsl:if test="ddicb:nation/@abbr">
            <dcterms:coverage xsi:type="dcterms:ISO639-3">
                <xsl:value-of select="ddicb:nation/@abbr" />
            </dcterms:coverage>            
        </xsl:if>
        -->
        
        <xsl:if test="ddicb:dataKind">
            <dcterms:type><xsl:value-of select="ddicb:dataKind" /></dcterms:type>
        </xsl:if>
      
        <xsl:if test="ddicb:universe">      
            <dcterms:coverage>
                <xsl:value-of select="ddicb:universe" />
            </dcterms:coverage>
        </xsl:if>
    </xsl:template>
    <!--
    <xsl:template match="ddicb:"> <ddionto:isMeasureOf> <xsl:value-of
    select="ddicb:" /> </ddionto:isMeasureOf> </xsl:template>

    <xsl:template match="ddicb:"> <ddionto:hasInstrument> <xsl:value-of
    select="ddicb:" /> </ddionto:hasInstrument> </xsl:template>

    <xsl:template match="ddicb:"> <ddionto:hasCoverage> <xsl:value-of
    select="ddicb:" /> </ddionto:hasCoverage> </xsl:template>

    <xsl:template match="ddicb:"> <ddionto:hasDatafile> <xsl:value-of
    select="ddicb:" /> </ddionto:hasDatafile> </xsl:template>
    -->

    <xsl:template match="ddicb:concept" mode="reference">
	
    </xsl:template>
</xsl:stylesheet>
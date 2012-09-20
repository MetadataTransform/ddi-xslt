<?xml version="1.0" encoding="UTF-8"?>
<!--
Document : ddi3-1-to-rdf.xsl Description: converts a DDI 3.1 intance to RDF
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
    xmlns:ddilc     = "ddi:instance:3_1"
    xmlns:g="ddi:group:3_1"
    xmlns:d="ddi:datacollection:3_1"
    xmlns:dce="ddi:dcelements:3_1"
    xmlns:c="ddi:conceptualcomponent:3_1"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:a="ddi:archive:3_1"
    xmlns:m1="ddi:physicaldataproduct/ncube/normal:3_1"
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
    xmlns:pr="ddi:profile:3_1">
    
    <xsl:import href="ddi3-1_datacollection.xsl"/>
    <xsl:import href="ddi3-1_logicalproduct.xsl"/>
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <!-- used as a prefix for elements -->
    <xsl:variable name="studyURI">
           <xsl:value-of select="/ddilc:DDIInstance/s:StudyUnit/@id"/>
    </xsl:variable>
    
    
    <xsl:template match="/ddilc:DDIInstance ">
        <rdf:RDF>
            <!-- Study -->
            <xsl:apply-templates select="s:StudyUnit" />

            <!-- Universe -->

                    
            <!-- DataFile -->


            <!-- DescriptiveStatistics -->
            

            <!-- Variables -->
            
        
            <!-- Intrument -->
            
	
            <!--Question -->
            
        
            <!-- Coverage -->
            
	
            <!-- Location -->	
            
            
            <!-- LogicalDataSet -->
         
        </rdf:RDF>
    </xsl:template>
    
    <!-- Study -->
    <xsl:template match="s:StudyUnit">
        <rdf:Description>
            <xsl:attribute name="rdf:about">
                <xsl:text>http://ddialliance.org/data/URI</xsl:text>
            </xsl:attribute>
            <rdf:type rdf:resource="http://ddialliance.org/def#Study" />
            
            <xsl:apply-templates select="r:Citation" />
            
            <!-- ddionto:isMeasureOf -->
            <!-- ddionto:HasInstrument -->
            <!-- dc:hasPart -->
            <!-- ddionto:HasDataFile -->
            
            <!-- ddionto:ContainsVariable -->
            <xsl:for-each select="//l:Variable">
                <xsl:element name="ddionto:ContainsVariable">
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="$studyURI"/>
                        <xsl:text>-</xsl:text>
                        <xsl:value-of select="./@id"/>                        
                    </xsl:attribute>
                </xsl:element>
            </xsl:for-each>
            
            <!-- ddionto:HasCoverage -->
            
        </rdf:Description>
    </xsl:template>

    <xsl:template match="r:Citation">
        <xsl:for-each select="r:Title">
            <dc:title>
                <xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang"/></xsl:attribute>
                <xsl:value-of select="." />
            </dc:title>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>

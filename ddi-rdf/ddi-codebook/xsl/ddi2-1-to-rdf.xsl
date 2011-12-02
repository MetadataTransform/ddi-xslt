<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : ddi2-1-to-rdf.xsl
    Description: converts a DDI 2.1 intance to RDF    
    
    
    @prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
    @prefix owl: <http://www.w3.org/2002/07/owl#> .
    @prefix skosclass: <http://ddialliance.org/ontologies/skosclass#> .
    @prefix xml: <http://www.w3.org/XML/1998/namespace> .
    @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
    @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
    @prefix skos: <http://www.w3.org/2004/02/skos/core#> .
    @prefix dc: <http://purl.org/dc/elements/1.1/> .
    @prefix dcterms: <http://purl.org/dc/terms/> .
    @prefix ddionto: <http://ddialliance.org/def#> .
    @prefix ddi: <http://ddialliance.org/data/> .
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
            xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:si="http://www.w3schools.com/rdf/"
            xmlns:owl="http://www.w3.org/2002/07/owl#"
            xmlns:skosclass="http://ddialliance.org/ontologies/skosclass"
            xmlns:xml="http://www.w3.org/XML/1998/namespace"
            xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
            xmlns:skos="http://www.w3.org/2004/02/skos/core#"
            xmlns:dc="http://purl.org/dc/elements/1.1/"
            xmlns:dcterms="http://purl.org/dc/terms/"
            xmlns:ddionto="http://ddialliance.org/def#" 
            xmlns:ddi="http://ddialliance.org/data/"
            xmlns:ddicb="http://www.icpsr.umich.edu/DDI"
            >
    <xsl:output method="xml" indent="yes"/>
 
    <xsl:template match="ddicb:codeBook">
        <rdf:RDF>
            <xsl:apply-templates select="ddicb:stdyDscr"/>
        </rdf:RDF>
    </xsl:template>
    
    <xsl:template match="ddicb:stdyDscr">
        <ddionto:Study>
            <xsl:apply-templates select="ddicb:citation"/>
            
            <xsl:apply-templates select="ddicb:stdyInfo"/>
        </ddionto:Study>
    </xsl:template>
    
    <xsl:template match="ddicb:citation">
        <dc:title><xsl:value-of select="ddicb:titlStmt/ddicb:titl"/></dc:title>
    </xsl:template>
    
    <xsl:template match="ddicb:stdyInfo">
        <dc:abstract><xsl:value-of select="ddicb:abstract"/></dc:abstract>
    </xsl:template>   
</xsl:stylesheet>

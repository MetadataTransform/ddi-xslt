<?xml version="1.0" encoding="UTF-8"?>
<!-- ddi2-5-to-rdf.xsl -->
<!-- converts a DDI 2.5 intance to RDF -->

<!-- to validate output: -->
<!-- http://www.w3.org/RDF/Validator/ -->

<xsl:stylesheet version="2.0" 
  xmlns:xsl       ="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf       ="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:si        ="http://www.w3schools.com/rdf/" 
  xmlns:owl       ="http://www.w3.org/2002/07/owl#" 
  xmlns:skosclass ="http://ddialliance.org/ontologies/skosclass"
  xmlns:xml       ="http://www.w3.org/XML/1998/namespace" 
  xmlns:rdfs      ="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:xsi       ="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:skos      ="http://www.w3.org/2004/02/skos/core#" 
  xmlns:dc        ="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms   ="http://purl.org/dc/terms/"
  xmlns:meta="transformation:metadata" 
  xmlns:disco     ="http://rdf-vocabulary.ddialliance.org/discovery#"
  xmlns:ddi       ="http://ddialliance.org/data/" 
  xmlns:schema    ="http://schema.org/"
  xmlns:c="ddi:codebook:2_5"
  xmlns:ddicb     ="http://www.ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/codebook.xsd"
  xsi:schemaLocation="ddi:codebook:2_5 http://www.ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/codebook.xsd"

  exclude-result-prefixes="#all">

  <meta:metadata>
    <identifier>ddi-2.5-to-rdf</identifier>
    <title>DDI 2.5 to RDF/XML</title>
    <description>Convert DDI Codebook (2.5) to RDF/XML</description>
    <outputFormat>XML</outputFormat>
    <parameters>
        <parameter name="root-element" format="xs:string" description="Root element"/>
    </parameters>
  </meta:metadata>


  <!-- ================================================== -->
  <!-- imports                                            -->
  <!-- ================================================== -->
  <!-- <xsl:import href="ddi2-1_datacollection.xsl"/>
  <xsl:import href="ddi2-1_logicalproduct.xsl"/> -->

  <!-- ================================================== -->
  <!-- setup                                              -->
  <!-- ================================================== -->
  <xsl:output method="xml" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- ================================================== -->
  <!-- params                                             -->
  <!-- ================================================== -->
  <!-- render text-elements with this lang attribute -->
  <xsl:param name="lang">en</xsl:param>

  <!-- used as a prefix for elements -->
  <xsl:param name="studyURI">
      <xsl:choose>
          <xsl:when test="//ddicb:codeBook/ddicb:stdyDscr/@ID">
              <xsl:value-of select="//ddicb:codeBook/ddicb:stdyDscr/@ID"/>
          </xsl:when>
          <xsl:when test="//ddicb:codeBook/@ID">
              <xsl:value-of select="//ddicb:codeBook/@ID"/>
          </xsl:when>
      </xsl:choose>
  </xsl:param>


  <!-- ===================== -->
  <!-- template              -->
  <!-- match: ddicb:codeBook -->
  <!-- ===================== -->

  <xsl:template match="/">
      <!-- output of doctype -->
      <!--
      <xsl:text disable-output-escaping="yes"><![CDATA[
<!DOCTYPE rdf:RDF [
<!ENTITY owl "http://www.w3.org/2002/07/owl#" >
<!ENTITY xsd "http://www.w3.org/2001/XMLSchema#" >
<!ENTITY rdfs "http://www.w3.org/2000/01/rdf-schema#" >
<!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#" >
]>            
      ]]></xsl:text>
      -->
      <rdf:RDF>
        <xsl:apply-templates select="//c:stdyDscr/c:stdyInfo/c:subject/c:keyword" />
        <xsl:apply-templates select="//c:docDscr/c:citation/c:titlStmt/c:IDNo" />
          <owl:Ontology rdf:about="">
              <owl:versionIRI rdf:resource=""/>
          </owl:Ontology>
          
          <!-- Study -->
          <xsl:apply-templates select="ddicb:stdyDscr" />

          <!-- Universe -->
          <xsl:apply-templates select="ddicb:stdyDscr/ddicb:stdyInfo/ddicb:sumDscr/ddicb:universe" />
                  
          <!-- DataFile -->
          <xsl:apply-templates select="//ddicb:fileDscr/ddicb:fileTxt"/>

          <!-- DescriptiveStatistics -->
          <xsl:apply-templates select="//ddicb:dataDscr/ddicb:var/ddicb:catgry"/>

          <!-- Variables -->
          <xsl:apply-templates select="//ddicb:dataDscr/ddicb:var"/>            
      
          <!-- Intrument -->
          <!-- <xsl:call-template name="Instrument"/> -->

          <!--Question -->
          <xsl:apply-templates select="//ddicb:qstn"/>
      
          <!-- Coverage -->
          <!-- <xsl:call-template name="Coverage"/> -->

          <!-- Location -->	
          <!-- <xsl:call-template name="Location"/>  -->
          
          <!-- LogicalDataSet -->
          <!-- <xsl:call-template name="LogicalDataSet"/>            -->
          
      </rdf:RDF>
  </xsl:template>
  
  <!-- Study -->
  <xsl:template match="ddicb:stdyDscr">        
      <rdf:Description>
          <xsl:attribute name="rdf:about">
                <xsl:value-of select="$studyURI" />
              <xsl:choose>
                  <xsl:when test="ddicb:citation/ddicb:titlStmt/ddicb:IDNo!=''">
                      <xsl:value-of select="ddicb:citation/ddicb:titlStmt/ddicb:IDNo" />
                  </xsl:when>
                  <xsl:otherwise><xsl:value-of select="../ID" /></xsl:otherwise>
              </xsl:choose>
          </xsl:attribute>
          <rdf:type rdf:resource="http://rdf-vocabulary.ddialliance.org/discovery#Study" />

          <!-- disco:isMeasureOf -->
          <xsl:for-each select="ddicb:stdyInfo/ddicb:sumDscr/ddicb:universe">
              <disco:isMeasureOf>
                  <xsl:attribute name="rdf:resource"><xsl:value-of select="$studyURI"/>-universe-<xsl:value-of select="." /></xsl:attribute>
              </disco:isMeasureOf>
          </xsl:for-each>
          
          <!-- disco:HasInstrument -->
          <disco:HasInstrument>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="$studyURI"/>-instrument</xsl:attribute>
          </disco:HasInstrument>
          
          <!-- dc:hasPart logicalDataset-->
          <dc:hasPart>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="$studyURI"/>-logicalDataSet</xsl:attribute>
          </dc:hasPart>
          
          <!-- disco:HasDataFile -->
          <xsl:for-each select="//ddicb:codeBook/ddicb:fileDscr/ddicb:fileTxt">
              <xsl:element name="disco:HasDataFile">
                  <xsl:attribute name="rdf:resource"><xsl:value-of select="$studyURI"/>-<xsl:value-of select="./ddicb:fileName"/></xsl:attribute>
              </xsl:element>
          </xsl:for-each>
    
          
            <!-- disco:ContainsVariable -->
          <xsl:for-each select="//ddicb:codeBook/ddicb:dataDscr/ddicb:var">
              <xsl:element name="disco:ContainsVariable">
                  <xsl:attribute name="rdf:resource">
                      <xsl:choose>
                          <xsl:when test="./@name">
                                  <xsl:value-of select="$studyURI"/>
                                  <xsl:text>-</xsl:text>
                                  <xsl:value-of select="./@name"/>
                          </xsl:when>
                          <xsl:when test="./@ID">
                                  <xsl:value-of select="$studyURI"/>
                                  <xsl:text>-</xsl:text>
                                  <xsl:value-of select="./@ID"/>
                          </xsl:when>
                      </xsl:choose>
                  </xsl:attribute>
              </xsl:element>
          </xsl:for-each>                       

          <!-- disco:HasCoverage -->
          <xsl:element name="disco:HasCoverage">
              <xsl:attribute name="rdf:resource"><xsl:value-of select="$studyURI"/>-coverage</xsl:attribute>
          </xsl:element>

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
          <!--<xsl:apply-templates select="../ddicb:dataDscr" mode="reference"/>-->
      </rdf:Description>
  </xsl:template>

  <xsl:template match="ddicb:citation">
      <dc:title>
          <xsl:attribute name="xml:lang"><xsl:value-of select="$lang"/></xsl:attribute>
          <xsl:value-of select="ddicb:titlStmt/ddicb:titl" />
      </dc:title>
  </xsl:template>

  <xsl:template match="c:keyword|c:topcClas">
    <xsl:variable name="rdfdt">http://www.w3.org/2001/XMLSchema#string</xsl:variable>
    <xsl:for-each select=".">
        <schema:keywords>
            <xsl:attribute name="rdf:datatype">
                <xsl:value-of select="$rdfdt"/>
            </xsl:attribute>
            <xsl:attribute name="vocab">
                <xsl:value-of select="@vocab" />
            </xsl:attribute>
            <xsl:attribute name="vocabURI">
                <xsl:value-of select="@vocabURI" />
            </xsl:attribute>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
        </schema:keywords>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="c:IDNo">
    <schema:citation>
        <xsl:attribute name="rdf:resource">
            <xsl:value-of select="." />
        </xsl:attribute>
    </schema:citation>
  </xsl:template>

  <xsl:template match="ddicb:stdyInfo">
      <dcterms:abstract>
          <xsl:value-of select="ddicb:abstract" />
      </dcterms:abstract>
      <xsl:for-each select="ddicb:subject/ddicb:topcClas">
          <dcterms:subject>
              <xsl:attribute name="xml:lang">
                  <xsl:choose>
                      <xsl:when test="@xml-lang"><xsl:value-of select="$lang"/></xsl:when>
                      <xsl:otherwise><xsl:value-of select="$lang"/></xsl:otherwise>
                  </xsl:choose>
              </xsl:attribute>
              <xsl:attribute name="xml:lang"><xsl:value-of select="$lang"/></xsl:attribute>
              <xsl:value-of select="." />
          </dcterms:subject>
      </xsl:for-each>    
      <xsl:for-each select="c:keyword|c:topcClas">
          <schema:keywords><xsl:value-of select="." /></schema:keywords>
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
  
  <xsl:template match="ddicb:universe">
      <rdf:Description>
          <!-- URI -->
          <xsl:attribute name="rdf:about"><xsl:value-of select="$studyURI" />-universe-<xsl:value-of select="." /></xsl:attribute>
          <!-- rdf:type -->
          <rdf:type>
              <xsl:attribute name="rdf:resource">http://rdf-vocabulary.ddialliance.org/discovery#Universe</xsl:attribute>
          </rdf:type>

          <skos:definition>
              <xsl:value-of select="." />
          </skos:definition>
      </rdf:Description>
  </xsl:template>
  <!--
  <xsl:template match="ddicb:"> <disco:isMeasureOf> <xsl:value-of
  select="ddicb:" /> </disco:isMeasureOf> </xsl:template>
  <xsl:template match="ddicb:"> <disco:hasInstrument> <xsl:value-of
  select="ddicb:" /> </disco:hasInstrument> </xsl:template>
  <xsl:template match="ddicb:"> <disco:hasCoverage> <xsl:value-of
  select="ddicb:" /> </disco:hasCoverage> </xsl:template>
  <xsl:template match="ddicb:"> <disco:hasDatafile> <xsl:value-of
  select="ddicb:" /> </disco:hasDatafile> </xsl:template>
  -->

  <xsl:template match="ddicb:concept" mode="reference">

  </xsl:template>
</xsl:stylesheet>
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
  xmlns:schema    ="http://schema.org/"
  xmlns:meta="transformation:rdf"
  xmlns:c="ddi:codebook:2_5"
  xmlns:ddi     ="http://www.ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/codebook.xsd"
  xsi:schemaLocation="ddi:codebook:2_5 http://www.ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/codebook.xsd"

  exclude-result-prefixes="#all">

  <meta:metadata>
    <identifier>ddi-2.5-to-rdf</identifier>
    <title>DDI 2.5 to RDF/XML</title>
    <description>Convert DDI Codebook (2.5) to RDF/XML</description>
    <outputFormat>XML</outputFormat>
  </meta:metadata>

  <xsl:param name="root-element">rdf:RDF</xsl:param> 


  <!-- ================================================== -->
  <!-- imports                                            -->
  <!-- ================================================== -->
  <!-- <xsl:import href="ddi2-1_datacollection.xsl"/>
  <xsl:import href="ddi2-1_logicalproduct.xsl"/> -->

  <!-- ================================================== -->
  <!-- setup                                              -->
  <!-- ================================================== -->
  <xsl:output method="xml" indent="yes"/>
  <!-- <xsl:strip-space elements="*"/> -->

  <!-- ================================================== -->
  <!-- params                                             -->
  <!-- ================================================== -->
  <!-- render text-elements with this lang attribute -->
  <!-- <xsl:param name="lang">en</xsl:param> -->

  <!-- used as a prefix for elements -->
  <xsl:param name="studyURI">
      <xsl:choose>
          <xsl:when test="//c:docDscr/c:citation/c:titlStmt/c:IDNo!=''">
              <xsl:value-of select="c:citation/c:titlStmt/c:IDNo[@agency='DataCite']"/>
          </xsl:when>
          <xsl:when test="//c:codeBook/@ID">
              <xsl:value-of select="//c:codeBook/@ID"/>
          </xsl:when>
      </xsl:choose>
  </xsl:param>


  <!-- ===================== -->
  <!-- template              -->
  <!-- match: ddicb:codeBook -->
  <!-- ===================== -->

  <xsl:template match="/">
    <xsl:element name="{$root-element}">
        <xsl:namespace name="schema">http://schema.org/</xsl:namespace>
        <!-- <xsl:namespace name="xs">http://www.w3.org/2001/XMLSchema</xsl:namespace>
        <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
        <xsl:namespace name="dc">http://purl.org/dc/elements/1.1</xsl:namespace>
        <xsl:namespace name="dcterms">http://purl.org/dc/terms/</xsl:namespace> -->

        <!-- <xsl:apply-templates select="//c:stdyDscr/c:stdyInfo/c:subject/c:keyword" /> -->
        <!-- <xsl:apply-templates select="//c:stdyDscr/c:citation/c:titlStmt/c:titl" /> -->
        <!-- <xsl:apply-templates select="//c:stdyDscr/c:stdyInfo/c:subject/c:topcClas" /> -->
        <!-- <xsl:apply-templates select="//c:docDscr/c:citation/c:titlStmt/c:IDNo" /> -->
        <!-- Study -->
        <xsl:apply-templates select="//c:stdyDscr" />
        <!-- Universe -->
        <xsl:apply-templates select="c:stdyDscr/c:stdyInfo/c:sumDscr/c:universe" />      
        <!-- DataFile -->
        <xsl:apply-templates select="//c:fileDscr/c:fileTxt"/>
        <!-- DescriptiveStatistics -->
        <xsl:apply-templates select="//c:dataDscr/c:var/c:catgry"/>
        <!-- Variables -->
        <xsl:apply-templates select="//c:dataDscr/c:var"/>               
        <!-- Intrument -->
        <!-- <xsl:call-template name="Instrument"/> -->
        <!--Question -->
        <xsl:apply-templates select="//c:qstn"/>
    </xsl:element>
  </xsl:template>

      <!-- <rdf:RDF> -->
        <!-- <schema:Dataset>
          <xsl:attribute name="rdf:about">
                <xsl:value-of select="$studyURI" />
                   <xsl:if test="c:citation/c:titlStmt/c:IDNo!=''">
                    <xsl:value-of select="c:citation/c:titlStmt/c:IDNo" />
                  </xsl:if> 
                   <xsl:if test="c:docDscr/c:citation/c:titlStmt/c:IDNo!=''">
                    <xsl:value-of select="if (@agency='DataCite') then (.) else null" />
                </xsl:if>
                <xsl:if test="../ID">
                    <xsl:value-of select="../ID" />
                </xsl:if> 
          </xsl:attribute>
          <owl:Ontology rdf:about="">
              <owl:versionIRI rdf:resource=""/>
          </owl:Ontology> -->
          

      
          <!-- Coverage -->
          <!-- <xsl:call-template name="Coverage"/> -->

          <!-- Location -->	
          <!-- <xsl:call-template name="Location"/>  -->
          
          <!-- LogicalDataSet -->
          <!-- <xsl:call-template name="LogicalDataSet"/>            -->

        <!-- </schema:Dataset> -->
          <!-- </rdf:RDF> -->
    
      
  
  <!-- Study -->
  <xsl:template match="c:stdyDscr">        
      <schema:Dataset>
          <xsl:attribute name="rdf:about">
                <xsl:value-of select="$studyURI" />
              <xsl:choose>
                  <xsl:when test="c:citation/c:titlStmt/c:IDNo!=''">
                      <xsl:value-of select="c:citation/c:titlStmt/c:IDNo[@agency='DataCite']" />
                  </xsl:when>
                  <xsl:otherwise><xsl:value-of select="../ID" /></xsl:otherwise>
              </xsl:choose>
          </xsl:attribute>
          <schema:additionalType rdf:resource="http://rdf-vocabulary.ddialliance.org/discovery#Study" />

          <!-- <xsl:template match=""> -->
          <xsl:for-each select="c:citation/c:rspStmt/c:AuthEnty">
          <schema:creator>
                <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/><xsl:attribute name="affiliation" select="@affiliation"/></xsl:if>
                <xsl:value-of select="." />
          </schema:creator>
          </xsl:for-each>
        <!-- </xsl:template> -->

          <!-- <xsl:for-each select=""> -->
          <xsl:for-each select="c:citation/c:titlStmt/c:titl">
            <schema:name>
                    <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                    <xsl:value-of select="." />
            </schema:name>
          </xsl:for-each>

          <!-- <dc:identifier>
              <xsl:text>http://ddialliance.org/data/</xsl:text>
              <xsl:choose>
                  <xsl:when test="c:citation/c:titlStmt/c:IDNo!=''">
                      <xsl:value-of select="c:citation/c:titlStmt/c:IDNo" />
                  </xsl:when>
                  <xsl:otherwise><xsl:value-of select="../ID" /></xsl:otherwise>
              </xsl:choose>
          </dc:identifier> -->

          <!-- <xsl:apply-templates select="c:citation" /> -->
        <!-- <xsl:apply-templates select="c:stdyInfo" /> -->
        <xsl:for-each select="c:stdyInfo/c:abstract">
        <schema:abstract>
                <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                <xsl:value-of select="." />    
        </schema:abstract>
        </xsl:for-each>

        <xsl:for-each select="c:stdyInfo/c:subject/c:topcClas|c:stdyInfo/c:subject/c:keyword">
            <schema:keywords>
                <xsl:attribute name="xml:lang">
                    <xsl:choose>
                        <xsl:when test="@xml-lang"><xsl:value-of select="."/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang"/></xsl:attribute>
                <xsl:value-of select="." />
            </schema:keywords>
        </xsl:for-each>    
        <!-- <xsl:for-each select="c:keyword|c:topcClas">
            <schema:keywords><xsl:value-of select="." /></schema:keywords>
        </xsl:for-each>     -->

      </schema:Dataset>
  </xsl:template>



  <!-- <xsl:template match="c:keyword|c:topcClas">
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
  </xsl:template> -->

  <!-- <xsl:template match="c:IDNo">
    <schema:citation>
        <xsl:attribute name="rdf:about">
            <xsl:value-of select="." />
        </xsl:attribute>
    </schema:citation>
  </xsl:template> -->


  
  <xsl:template match="c:dataAccs">
      
  </xsl:template>
  

  <xsl:template match="c:sumDscr">
      <!--
      <dcterms:temporal xsi:type="dcterms:Period">
          start=<xsl:value-of select="ddicb:timePrd[@event='start']" />; end=<xsl:value-of select="ddicb:timePrd[@event='end']" />;
      </dcterms:temporal>
      -->
      <xsl:if test="c:nation">
          <!-- <dc:coverage>
              <xsl:value-of select="c:nation" />
          </dc:coverage> -->
      </xsl:if>
      
      <!--
      <xsl:if test="ddicb:nation/@abbr">
          <dcterms:coverage xsi:type="dcterms:ISO639-3">
              <xsl:value-of select="ddicb:nation/@abbr" />
          </dcterms:coverage>            
      </xsl:if>
      -->
      
      <xsl:if test="c:dataKind">
          <!-- <dcterms:type><xsl:value-of select="c:dataKind" /></dcterms:type> -->
      </xsl:if>
    
      <xsl:if test="c:universe">      
          <!-- <dcterms:coverage>
              <xsl:value-of select="c:universe" />
          </dcterms:coverage> -->
      </xsl:if>
  </xsl:template>

  <xsl:template match="c:concept" mode="reference">

  </xsl:template>
</xsl:stylesheet>
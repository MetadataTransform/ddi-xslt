<?xml version="1.0" encoding="UTF-8"?>

	<!--
		Document : ddi2-1-to-rdf.xsl Description: converts a DDI 2.1 intance
		to RDF
	-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:si="http://www.w3schools.com/rdf/" xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:skosclass="http://ddialliance.org/ontologies/skosclass"
	xmlns:xml="http://www.w3.org/XML/1998/namespace" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dcterms="http://purl.org/dc/terms/" xmlns:ddionto="http://ddialliance.org/def#"
	xmlns:ddi="http://ddialliance.org/data/" xmlns:ddicb="http://www.icpsr.umich.edu/DDI">
	<xsl:output method="xml" indent="yes" />

	<xsl:template match="ddicb:codeBook">
		<rdf:RDF>
			<xsl:apply-templates select="ddicb:stdyDscr" />


			<!-- Including Variables  -->

			<xsl:apply-templates select="ddicb:dataDscr" />
		</rdf:RDF>
	</xsl:template>

	<xsl:template match="ddicb:stdyDscr">
		<!--     <ddionto:Study> -->
		<rdf:Description>
			<xsl:attribute name="rdf:about">http://ddialliance.org/data/<xsl:value-of
				select="ddicb:citation/ddicb:titlStmt/ddicb:IDNo" />
			</xsl:attribute>

			<rdf:type rdf:resource="http://ddialliance.org/def#Study" />
			<rdf:type rdf:resource="http://ddialliance.org/def#LogicalDataset" />
			<xsl:apply-templates select="ddicb:citation" />

			<xsl:apply-templates select="ddicb:stdyInfo" />
		</rdf:Description>


	</xsl:template>

	<xsl:template match="ddicb:citation">
		<dc:title>
			<xsl:value-of select="ddicb:titlStmt/ddicb:titl" />
		</dc:title>
	</xsl:template>

	<xsl:template match="ddicb:stdyInfo">
		<dc:abstract>
			<xsl:value-of select="ddicb:abstract" />
		</dc:abstract>
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


	<!--  Modeling Variables -->
	<xsl:template match="ddicb:dataDscr">

		<xsl:apply-templates select="ddicb:var" />

	</xsl:template>

	<xsl:template match="ddicb:var">
		<rdf:Description>
			<xsl:attribute name="rdf:about">http://ddialliance.org/data/<xsl:value-of
				select="./@name" />
			</xsl:attribute>

			<rdf:type rdf:resource="http://ddialliance.org/def#Variable" />
			<skos:prefLabel>
				<xsl:attribute name="xml:lang">en</xsl:attribute>
				<xsl:value-of select="ddicb:labl"/>
			</skos:prefLabel>
			<dc:identifier>
				<xsl:value-of select="./@name"/>
			</dc:identifier>
			<dc:description>
				<xsl:attribute name="xml:lang">en</xsl:attribute>
				<xsl:value-of select="ddicb:txt"/>
			</dc:description>

		</rdf:Description>

	</xsl:template>


</xsl:stylesheet>

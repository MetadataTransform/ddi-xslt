<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0" 
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
	xmlns:ddicb="http://www.icpsr.umich.edu/DDI">
	
	<xsl:output version="1.0" encoding="ISO-8859-1" indent="yes"/>
	
	<xsl:template match="ddicb:codeBook">
	
		<!-- ............... -->
		<!-- RDF document header information: -->
			<!-- xml declaration -->
			<xsl:call-template name="documentTypeDeclaration"/>
			<xsl:call-template name="rdfDocumentHeader"/>
			<xsl:call-template name="owlDocumentHeader"/>
		<!-- ..... -->
	
		<!--<xsl:element name="rdf:RDF">-->
			<!--<xsl:attribute name="xmlns:rdf">
				<xsl:text>http://www.w3.org/1999/02/22-rdf-syntax-ns#</xsl:text>
			</xsl:attribute>-->
	
		<xsl:call-template name="Instrument"/>
	
        <xsl:apply-templates select="//ddicb:qstn"/>
        
		<xsl:call-template name="Coverage"/>
        
		<xsl:call-template name="rdfDocumentEnd"/>
		
		<!--</xsl:element>-->
        
    </xsl:template>
    
	<!-- ............... -->
	<!-- Instrument: -->
		<!-- [no instrument in DDI 2.1] -->
		<xsl:template name="Instrument">
			
			<!-- ............... -->
			<!-- only if at least 1 question -->
			<xsl:if test="count(//ddicb:qstn) > 0">
			
				<!--<xsl:element name="rdf:Description">-->
				<xsl:text disable-output-escaping="yes"><![CDATA[
	<rdf:Description]]></xsl:text>
	
					<!-- ............... -->
					<!-- URI: -->
						<!-- instrument-<study URI> [study-dependent instrument] -->
						<!--<xsl:attribute name="rdf:about">
							<xsl:text>http://ddialliance.org/data/</xsl:text>
							<xsl:text>Instrument</xsl:text>
						</xsl:attribute>-->
						<xsl:text disable-output-escaping="yes"><![CDATA[ rdf:about="instrument-]]></xsl:text>
						<xsl:choose>
								<xsl:when test="ddicb:codeBook/ddicb:stdyDscr/ddicb:citation/ddicb:titlStmt/ddicb:IDNo!=''">
									<xsl:value-of select="ddicb:codeBook/ddicb:stdyDscr/ddicb:citation/ddicb:titlStmt/ddicb:IDNo" />
								</xsl:when>
								<xsl:otherwise><xsl:value-of select="../ID" /></xsl:otherwise>
							</xsl:choose>
						<xsl:text disable-output-escaping="yes"><![CDATA[">]]></xsl:text>
					<!-- ..... -->
					
					<!-- ............... -->
					<!-- type: -->
						<!--<xsl:element name="rdf:type">
							<xsl:attribute name="rdf:resource">
								<xsl:text>http://ddialliance.org/def#Instrument</xsl:text>
							</xsl:attribute>
						</xsl:element>-->
						<xsl:text disable-output-escaping="yes"><![CDATA[ 
		<rdf:type rdf:about="http://ddialliance.org/def#Instrument"/>]]></xsl:text>
					<!-- ..... -->
					
					<!-- ............... -->
					<!-- usesQuestion: -->
						<xsl:for-each select="//ddicb:qstn">
							<!--<xsl:element name="ddionto:usesQuestion">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="./@ID"/>
								</xsl:attribute>
							</xsl:element>-->
							<xsl:text disable-output-escaping="yes"><![CDATA[ 
		<ddionto:usesQuestion rdf:resource="]]></xsl:text>
							<xsl:value-of select="./@ID"/>
							<xsl:text disable-output-escaping="yes"><![CDATA["/>]]></xsl:text>
						</xsl:for-each>
					<!-- ..... -->
					
				<!--</xsl:element>-->
				<xsl:text disable-output-escaping="yes"><![CDATA[
	</rdf:Description>]]></xsl:text>
	
			</xsl:if>
			<!-- ..... -->
			
		</xsl:template>
	<!-- ..... -->    
    
    <xsl:template match="ddicb:qstn">
    
		<!-- ............... -->
		<!-- Question -->
        <xsl:text disable-output-escaping="yes"><![CDATA[
	<rdf:Description]]></xsl:text>
        <!--<rdf:Description>-->
			<!-- ............... -->
			<!-- URI -->
            <!--<xsl:attribute name="rdf:about">
				<xsl:text>http://ddialliance.org/data/</xsl:text>
				<xsl:value-of select="./@ID"/>
			</xsl:attribute>-->
			<xsl:text disable-output-escaping="yes"><![CDATA[ rdf:about="]]></xsl:text>
			<xsl:value-of select="./@ID"/>
			<xsl:text disable-output-escaping="yes"><![CDATA[">"]]></xsl:text>
			<!-- ..... -->
			<!-- ............... -->
			<!-- type -->
            <!--<rdf:type rdf:resource="http://ddialliance.org/def#Question" />-->
            <xsl:text disable-output-escaping="yes"><![CDATA[ 
		<rdf:type rdf:about="http://ddialliance.org/def#Question>"/>]]></xsl:text>
            <!-- ..... -->
            <!-- ............... -->
			<!-- literalText -->
			<xsl:for-each select="./ddicb:qstnLit">
				<!--<ddionto:literalText>
					<xsl:value-of select="."/>
				</ddionto:literalText>-->
				<xsl:text disable-output-escaping="yes"><![CDATA[ 
		<ddionto:literalText>]]></xsl:text>
				<xsl:value-of select="."/>
				<xsl:text disable-output-escaping="yes"><![CDATA[</ddionto:literalText>]]></xsl:text>
			</xsl:for-each>
			<!-- ..... -->
            
		<!--</rdf:Description>-->
		<xsl:text disable-output-escaping="yes"><![CDATA[
	</rdf:Description>]]></xsl:text>
        <!-- ..... -->
        
    </xsl:template>    

	<!-- ............... -->
	<!-- dcterms:Coverage -->
    <xsl:template name="Coverage">
		
		<!--<rdf:Description>-->
		<xsl:text disable-output-escaping="yes"><![CDATA[
	<rdf:Description]]></xsl:text>
			<!-- ............... -->
			<!-- URI -->
            <!--<xsl:attribute name="rdf:about">
				<xsl:text>http://ddialliance.org/data/</xsl:text>
				<xsl:text>Coverage</xsl:text>
			</xsl:attribute>-->
			<xsl:text disable-output-escaping="yes"><![CDATA[ rdf:about="Coverage>"]]></xsl:text>
			<!-- ..... -->
			<!-- ............... -->
			<!-- type -->
            <!--<rdf:type rdf:resource="http://purl.org/dc/terms/#Coverage" />-->
            <xsl:text disable-output-escaping="yes"><![CDATA[ 
		<rdf:type rdf:about="http://ddialliance.org/def#Coverage>"/>]]></xsl:text>
            <!-- ..... -->
            <!-- ............... -->
			<!-- dcterms:subject -->
			<!--<dcterms:subject>
				
			</dcterms:subject>-->
			<xsl:text disable-output-escaping="yes"><![CDATA[ 
		<dcterms:subject>]]></xsl:text>
				
				<xsl:text disable-output-escaping="yes"><![CDATA[</dcterms:subject>]]></xsl:text>
			<!-- ..... -->
			<!-- ............... -->
			<!-- dcterms:temporal -->
			<!--<dcterms:temporal>
				
			</dcterms:temporal>-->
			<xsl:text disable-output-escaping="yes"><![CDATA[ 
		<dcterms:temporal>]]></xsl:text>
				
				<xsl:text disable-output-escaping="yes"><![CDATA[</dcterms:temporal>]]></xsl:text>
			<!-- ..... -->
		<!--</rdf:Description>-->
		<xsl:text disable-output-escaping="yes"><![CDATA[
	</rdf:Description>]]></xsl:text>
		
    </xsl:template>
	<!-- ..... -->
	
	<xsl:template name="documentTypeDeclaration">

		<xsl:text disable-output-escaping="yes"><![CDATA[	

<!DOCTYPE rdf:RDF [
	<!ENTITY owl "http://www.w3.org/2002/07/owl#" >
	<!ENTITY xsd "http://www.w3.org/2001/XMLSchema#" >
	<!ENTITY rdfs "http://www.w3.org/2000/01/rdf-schema#" >
	<!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#" >
]>
]]></xsl:text>

	</xsl:template>
	
	<xsl:template name="rdfDocumentHeader">
	
	<xsl:text disable-output-escaping="yes"><![CDATA[	
<rdf:RDF 
     xmlns=""
	 xml:base=""
	 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	 xmlns:owl="http://www.w3.org/2002/07/owl#"
	 xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
	 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
]]></xsl:text>

	</xsl:template>
	
	<xsl:template name="owlDocumentHeader">
	
		<xsl:text disable-output-escaping="yes"><![CDATA[	
	<owl:Ontology rdf:about=""/>
		<owl:versionIRI rdf:resource=""/>
	</owl:Ontology>
]]></xsl:text>

	</xsl:template>
	
	<xsl:template name="rdfDocumentEnd">
	
		<xsl:text disable-output-escaping="yes"><![CDATA[	
</rdf:RDF>
]]></xsl:text>

	</xsl:template>
	
</xsl:stylesheet>

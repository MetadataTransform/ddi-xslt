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
	xmlns:ddicb="http://www.icpsr.umich.edu/DDI"
	xmlns:qb="http://purl.org/linked-data/cube#">
	
	<xsl:output version="1.0" indent="yes"/>
	

	
	<!--<xsl:template match="ddicb:codeBook">-->
	
		<!-- ............... -->
		<!-- RDF document header information: -->
			<!-- xml declaration -->
                        <!--
			<xsl:call-template name="documentTypeDeclaration"/>
			<xsl:call-template name="rdfDocumentHeader"/>
			<xsl:call-template name="owlDocumentHeader"/>
                        -->
		<!-- ..... -->
	
		<!--<xsl:element name="rdf:RDF">-->
			<!--<xsl:attribute name="xmlns:rdf">
				<xsl:text>http://www.w3.org/1999/02/22-rdf-syntax-ns#</xsl:text>
			</xsl:attribute>-->
                 <!--           
		<xsl:call-template name="Instrument"/>
	
                <xsl:apply-templates select="//ddicb:qstn"/>
        
		<xsl:call-template name="Coverage"/>
		
		<xsl:call-template name="Location"/>
		
		<xsl:call-template name="LogicalDataSet"/>
        
		<xsl:call-template name="rdfDocumentEnd"/>
		-->
		<!--</xsl:element>-->
        
    <!--</xsl:template>-->
    
	<!-- ............... -->
	<!-- Instrument: -->
		<xsl:template name="Instrument">
			
			<!-- ............... -->
			<!-- only if at least 1 question -->
			<xsl:if test="count(//ddicb:qstn) > 0">
			
				<xsl:text disable-output-escaping="yes"><![CDATA[
	<rdf:Description]]></xsl:text>
	
					<!-- ............... -->
					<!-- URI: -->
						<xsl:text disable-output-escaping="yes"><![CDATA[ rdf:about="instrument-]]></xsl:text>
						<xsl:choose>
								<xsl:when test="//ddicb:codeBook/ddicb:stdyDscr/ddicb:citation/ddicb:titlStmt/ddicb:IDNo != ''">
									<xsl:value-of select="//ddicb:codeBook/ddicb:stdyDscr/ddicb:citation/ddicb:titlStmt/ddicb:IDNo" />
								</xsl:when>
								<xsl:otherwise><xsl:value-of select="../ID" /></xsl:otherwise>
							</xsl:choose>
						<xsl:text disable-output-escaping="yes"><![CDATA[">]]></xsl:text>
					<!-- ..... -->
					
					<!-- ............... -->
					<!-- type: -->
						<xsl:text disable-output-escaping="yes"><![CDATA[ 
		<rdf:type rdf:resource="http://ddialliance.org/def#Instrument"/>]]></xsl:text>
					<!-- ..... -->
					
					<!-- ............... -->
					<!-- usesQuestion: -->
						<xsl:for-each select="//ddicb:qstn">
							<xsl:text disable-output-escaping="yes"><![CDATA[ 
		<ddionto:usesQuestion rdf:resource="]]></xsl:text>
							<xsl:choose>
								<xsl:when test="../@ID">
									question-<xsl:value-of select="../@ID"/>
								</xsl:when>
								<xsl:when test="./ddicb:qstnLit">
									<xsl:value-of select="./ddicb:qstnLit/text()"/>
								</xsl:when>
							</xsl:choose>
							<xsl:text disable-output-escaping="yes"><![CDATA["/>]]></xsl:text>
						</xsl:for-each>
					<!-- ..... -->
					
				<xsl:text disable-output-escaping="yes"><![CDATA[
	</rdf:Description>]]></xsl:text>
	
			</xsl:if>
			<!-- ..... -->
			
		</xsl:template>
	<!-- ..... -->    
    
	<!-- ............... -->
	<!-- Question -->
    <xsl:template match="ddicb:qstn">
        <xsl:text disable-output-escaping="yes"><![CDATA[
	<rdf:Description]]></xsl:text>
        <!--<rdf:Description>-->
			<!-- ............... -->
			<!-- URI -->
			<xsl:text disable-output-escaping="yes"><![CDATA[ rdf:about="]]></xsl:text>
			<xsl:choose>
				<xsl:when test="./@ID">
					<xsl:value-of select="./@ID"/>
				</xsl:when>
				<xsl:when test="../@ID">
					question-<xsl:value-of select="../@ID"/>
				</xsl:when>                                
				<xsl:when test="./ddicb:qstnLit">
					<xsl:value-of select="./ddicb:qstnLit"/>
				</xsl:when>
			</xsl:choose>
			<xsl:text disable-output-escaping="yes"><![CDATA[">]]></xsl:text>
			<!-- ..... -->
			<!-- ............... -->
			<!-- type -->
            <xsl:text disable-output-escaping="yes"><![CDATA[ 
		<rdf:type rdf:resource="http://ddialliance.org/def#Question"/>]]></xsl:text>
            <!-- ..... -->
            <!-- ............... -->
			<!-- literalText -->
			<xsl:for-each select="./ddicb:qstnLit">
				<xsl:text disable-output-escaping="yes"><![CDATA[ 
		<ddionto:literalText>]]></xsl:text>
				<xsl:value-of select="."/>
				<xsl:text disable-output-escaping="yes"><![CDATA[</ddionto:literalText>]]></xsl:text>
			</xsl:for-each>
			<!-- ..... -->
			<!-- ............... -->
			<!-- hasResponseDomain (→ Representation, skos:ConceptScheme): -->
				<xsl:text disable-output-escaping="yes"><![CDATA[ 
		<ddionto:hasResponseDomain rdf:resource="representation-]]></xsl:text>
				<xsl:variable name="variableURI">
					<xsl:choose>
						<xsl:when test="../@name">
							<xsl:value-of select="../@name"/>
						</xsl:when>
						<xsl:when test="../@ID">
							<xsl:value-of select="../@ID"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="//ddicb:codeBook/ddicb:stdyDscr/@ID">
						<xsl:value-of select="//ddicb:codeBook/ddicb:stdyDscr/@ID"/>
						<xsl:text>-</xsl:text>
						<xsl:value-of select="$variableURI"/>
					</xsl:when>
					<xsl:when test="//ddicb:codeBook/@ID">
						<xsl:value-of select="//ddicb:codeBook/@ID"/>
						<xsl:text>-</xsl:text>
						<xsl:value-of select="$variableURI"/>
					</xsl:when>
				</xsl:choose>
				<xsl:text disable-output-escaping="yes"><![CDATA["/>]]></xsl:text>
			<!-- ..... -->
			
			<!-- ............... -->
			<!-- hasConcept (→ skos:Concept): -->
				<xsl:for-each select="../ddicb:concept">
					<xsl:text disable-output-escaping="yes"><![CDATA[ 
		<ddionto:hasConcept rdf:resource="concept-]]></xsl:text>
					<xsl:choose>
						<xsl:when test="./@ID">
							<xsl:value-of select="./@ID"/>
						</xsl:when>
						<xsl:when test=".">
							<xsl:value-of select="."/>
						</xsl:when>
					</xsl:choose>
					<xsl:text disable-output-escaping="yes"><![CDATA["/>]]></xsl:text>
				</xsl:for-each>
			<!-- ..... -->
            
		<!--</rdf:Description>-->
		<xsl:text disable-output-escaping="yes"><![CDATA[
	</rdf:Description>]]></xsl:text>
        
    </xsl:template>    
<!-- ..... -->

	<!-- ............... -->
	<!-- dcterms:Coverage -->
		<xsl:template name="Coverage">
			
			<!--<rdf:Description>-->
			<xsl:text disable-output-escaping="yes"><![CDATA[
	<rdf:Description]]></xsl:text>
	
				<!-- ............... -->
				<!-- URI: -->
					<!-- coverage-<study URI> [study-dependent coverage] -->
					<!--<xsl:attribute name="rdf:about">
						<xsl:text>http://ddialliance.org/data/</xsl:text>
						<xsl:text>Coverage</xsl:text>
					</xsl:attribute>-->
					<xsl:text disable-output-escaping="yes"><![CDATA[ rdf:about="coverage-]]></xsl:text>
					<xsl:choose>
							<xsl:when test="//ddicb:codeBook/ddicb:stdyDscr/ddicb:citation/ddicb:titlStmt/ddicb:IDNo != ''">
								<xsl:value-of select="//ddicb:codeBook/ddicb:stdyDscr/ddicb:citation/ddicb:titlStmt/ddicb:IDNo" />
							</xsl:when>
							<xsl:otherwise><xsl:value-of select="../ID" /></xsl:otherwise>
						</xsl:choose>
					<xsl:text disable-output-escaping="yes"><![CDATA[">]]></xsl:text>
				<!-- ..... -->
				
				<!-- ............... -->
				<!-- type -->
					<!--<rdf:type rdf:resource="http://purl.org/dc/terms/#Coverage" />-->
					<xsl:text disable-output-escaping="yes"><![CDATA[ 
		<rdf:type rdf:resource="http://purl.org/dc/terms/#Coverage"/>]]></xsl:text>
				<!-- ..... -->
				
				<!-- ............... -->
				<!-- dcterms:subject -->
					<xsl:text disable-output-escaping="yes"><![CDATA[ 
		<dcterms:subject>]]></xsl:text>
					<xsl:choose>
						<xsl:when test="//ddicb:codeBook/ddicb:stdyDscr/ddicb:stdyInfo/ddicb:subject/ddicb:keyword">
							<xsl:for-each select="//ddicb:codeBook/ddicb:stdyDscr/ddicb:stdyInfo/ddicb:subject/ddicb:keyword">
								<xsl:value-of select="."/>
								<xsl:if test="./@vocab">
									<xsl:text> (</xsl:text>
									<xsl:value-of select="./@vocab"/>
									<xsl:text>)</xsl:text>
								</xsl:if>
								<xsl:if test="not (position() = count(//ddicb:codeBook/ddicb:stdyDscr/ddicb:stdyInfo/ddicb:subject/ddicb:keyword))">
									<xsl:text>; </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="//ddicb:codeBook/ddicb:stdyDscr/ddicb:stdyInfo/ddicb:subject/ddicb:topcClas">
							<xsl:for-each select="//ddicb:codeBook/ddicb:stdyDscr/ddicb:stdyInfo/ddicb:subject/ddicb:topcClas">
								<xsl:value-of select="."/>
								<xsl:if test="./@vocab">
									<xsl:text> (</xsl:text>
									<xsl:value-of select="./@vocab"/>
									<xsl:text>)</xsl:text>
								</xsl:if>
								<xsl:if test="not (position() = count(//ddicb:codeBook/ddicb:stdyDscr/ddicb:stdyInfo/ddicb:subject/ddicb:topcClas))">
									<xsl:text>; </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
					</xsl:choose>
					<xsl:text disable-output-escaping="yes"><![CDATA[</dcterms:subject>]]></xsl:text>
				<!-- ..... -->
				
				<!-- ............... -->
				<!-- dcterms:temporal -->
					<!--<dcterms:temporal>
						
					</dcterms:temporal>-->
					<xsl:text disable-output-escaping="yes"><![CDATA[ 
		<dcterms:temporal>]]></xsl:text>
					<xsl:choose>
						<xsl:when test="//ddicb:codeBook/ddicb:stdyDscr/ddicb:stdyInfo/ddicb:sumDscr/ddicb:timePrd/@event = 'start' and
                                                 //ddicb:codeBook/ddicb:stdyDscr/ddicb:stdyInfo/ddicb:sumDscr/ddicb:timePrd/@event = 'end'">
                            <xsl:text>from </xsl:text>
							<xsl:value-of select="//ddicb:codeBook/ddicb:stdyDscr/ddicb:stdyInfo/ddicb:sumDscr/ddicb:timePrd[@event = 'start']/@date"/>
							<xsl:text> to </xsl:text>
							<xsl:value-of select="//ddicb:codeBook/ddicb:stdyDscr/ddicb:stdyInfo/ddicb:sumDscr/ddicb:timePrd[@event = 'end']/@date"/>
						</xsl:when>
						<xsl:when test="//ddicb:codeBook/ddicb:stdyDscr/ddicb:stdyInfo/ddicb:sumDscr/ddicb:timePrd/@event = 'single'">
						    <xsl:value-of select="//ddicb:codeBook/ddicb:stdyDscr/ddicb:stdyInfo/ddicb:sumDscr/ddicb:timePrd[@event = 'single']/@date"/>
						</xsl:when>
						<xsl:when test="//ddicb:codeBook/ddicb:stdyDscr/ddicb:stdyInfo/ddicb:sumDscr/ddicb:timePrd">
						    <xsl:value-of select="//ddicb:codeBook/ddicb:stdyDscr/ddicb:stdyInfo/ddicb:sumDscr/ddicb:timePrd/@date"/>
						</xsl:when>
					</xsl:choose>
					<xsl:text disable-output-escaping="yes"><![CDATA[</dcterms:temporal>]]></xsl:text>
				<!-- ..... -->
				
				<!-- ............... -->
				<!-- dcterms:spatial -->
					<!-- location-<study URI> [study-dependent location] -->
					<xsl:text disable-output-escaping="yes"><![CDATA[ 
		<dcterms:spatial rdf:resource="location-]]></xsl:text>
					<xsl:choose>
							<xsl:when test="//ddicb:codeBook/ddicb:stdyDscr/ddicb:citation/ddicb:titlStmt/ddicb:IDNo != ''">
								<xsl:value-of select="//ddicb:codeBook/ddicb:stdyDscr/ddicb:citation/ddicb:titlStmt/ddicb:IDNo" />
							</xsl:when>
							<xsl:otherwise><xsl:value-of select="../ID" /></xsl:otherwise>
						</xsl:choose>
					<xsl:text disable-output-escaping="yes"><![CDATA["/>]]></xsl:text>
				<!-- ..... -->
				
			<!--</rdf:Description>-->
			<xsl:text disable-output-escaping="yes"><![CDATA[
	</rdf:Description>]]></xsl:text>
			
		</xsl:template>
	<!-- ..... -->
	
	<!-- ............... -->
	<!-- dcterms:Location -->
		<xsl:template name="Location">
			
			<!--<rdf:Description>-->
			<xsl:text disable-output-escaping="yes"><![CDATA[
	<rdf:Description]]></xsl:text>
	
				<!-- ............... -->
				<!-- URI: -->
					<!-- location-<study URI> [study-dependent location] -->
					<xsl:text disable-output-escaping="yes"><![CDATA[ rdf:about="location-]]></xsl:text>
					<xsl:choose>
							<xsl:when test="//ddicb:codeBook/ddicb:stdyDscr/ddicb:citation/ddicb:titlStmt/ddicb:IDNo != ''">
								<xsl:value-of select="//ddicb:codeBook/ddicb:stdyDscr/ddicb:citation/ddicb:titlStmt/ddicb:IDNo" />
							</xsl:when>
							<xsl:otherwise><xsl:value-of select="../ID" /></xsl:otherwise>
						</xsl:choose>
					<xsl:text disable-output-escaping="yes"><![CDATA[">]]></xsl:text>
				<!-- ..... -->
				
				<!-- ............... -->
				<!-- type -->
					<!--<rdf:type rdf:resource="http://purl.org/dc/terms/#Location" />-->
					<xsl:text disable-output-escaping="yes"><![CDATA[ 
		<rdf:type rdf:resource="http://purl.org/dc/terms/#Location"/>]]></xsl:text>
				<!-- ..... -->
				
				<!-- ............... -->
				<!-- rdfs:label -->
					<xsl:text disable-output-escaping="yes"><![CDATA[ 
		<rdfs:label>]]></xsl:text>
					<xsl:choose>
						<xsl:when test="//ddicb:codeBook/ddicb:stdyDscr/ddicb:stdyInfo/ddicb:sumDscr/ddicb:nation">
							<xsl:value-of select="//ddicb:codeBook/ddicb:stdyDscr/ddicb:stdyInfo/ddicb:sumDscr/ddicb:nation"/>
						</xsl:when>
						<xsl:when test="//ddicb:codeBook/ddicb:stdyDscr/ddicb:stdyInfo/ddicb:sumDscr/ddicb:geogCover">
							<xsl:value-of select="//ddicb:codeBook/ddicb:stdyDscr/ddicb:stdyInfo/ddicb:sumDscr/ddicb:geogCover"/>
						</xsl:when>
					</xsl:choose>
					<xsl:text disable-output-escaping="yes"><![CDATA[</rdfs:label>]]></xsl:text>
				<!-- ..... -->
				
			<!--</rdf:Description>-->
			<xsl:text disable-output-escaping="yes"><![CDATA[
	</rdf:Description>]]></xsl:text>
			
		</xsl:template>
	<!-- ..... -->
	
	<!-- ............... -->
	<!-- LogicalDataSet -->
		<xsl:template name="LogicalDataSet">
			
			<!--<rdf:Description>-->
			<xsl:text disable-output-escaping="yes"><![CDATA[
	<rdf:Description]]></xsl:text>
	
				<!-- ............... -->
				<!-- URI: -->
					<xsl:text disable-output-escaping="yes"><![CDATA[ rdf:about="logicalDataSet-]]></xsl:text>
					<xsl:choose>
							<xsl:when test="//ddicb:codeBook/ddicb:stdyDscr/ddicb:citation/ddicb:titlStmt/ddicb:IDNo != ''">
								<xsl:value-of select="//ddicb:codeBook/ddicb:stdyDscr/ddicb:citation/ddicb:titlStmt/ddicb:IDNo" />
							</xsl:when>
							<xsl:otherwise><xsl:value-of select="../ID" /></xsl:otherwise>
						</xsl:choose>
					<xsl:text disable-output-escaping="yes"><![CDATA[">]]></xsl:text>
				<!-- ..... -->
				
				<!-- ............... -->
				<!-- type -->
					<xsl:text disable-output-escaping="yes"><![CDATA[ 
		<rdf:type rdf:resource="http://ddialliance.org/def#LogicalDataSet"/>]]></xsl:text>
				<!-- ..... -->
				
				<!-- ............... -->
				<!-- dc:title -->
					<xsl:text disable-output-escaping="yes"><![CDATA[ 
		<dc:title>]]></xsl:text>
					<xsl:choose>
						<xsl:when test="//ddicb:codeBook/ddicb:stdyDscr/ddicb:citation/ddicb:titlStmt/ddicb:titl">
							<xsl:value-of select="//ddicb:codeBook/ddicb:stdyDscr/ddicb:citation/ddicb:titlStmt/ddicb:titl"/>
						</xsl:when>
					</xsl:choose>
					<xsl:text disable-output-escaping="yes"><![CDATA[</dc:title>]]></xsl:text>
				<!-- ..... -->
				
			<!-- ............... -->
			<!-- containsVariable (→ Variable): -->
				<xsl:for-each select="//ddicb:codeBook/ddicb:dataDscr/ddicb:var">
					<xsl:text disable-output-escaping="yes"><![CDATA[ 
		<ddionto:containsVariable rdf:resource="]]></xsl:text>
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
					<xsl:text disable-output-escaping="yes"><![CDATA["/>]]></xsl:text>
				</xsl:for-each>
			<!-- ..... -->
			
			<!-- ............... -->
			<!-- hasDataFile (→ DataFile): -->
				<xsl:for-each select="//ddicb:codeBook/ddicb:fileDscr/ddicb:fileTxt">
					<xsl:text disable-output-escaping="yes"><![CDATA[ 
		<ddionto:hasDataFile rdf:resource="]]></xsl:text>
					<xsl:value-of select="$studyURI"/>
					<xsl:text>-</xsl:text>
					<xsl:value-of select="./ddicb:fileName"/>
					<xsl:text disable-output-escaping="yes"><![CDATA["/>]]></xsl:text>
				</xsl:for-each>
			<!-- ..... -->
			
			<!-- ............... -->
			<!-- hasCoverage (→ Coverage): -->
				<xsl:text disable-output-escaping="yes"><![CDATA[ 
		<ddionto:hasCoverage rdf:resource="]]></xsl:text>
				<xsl:text>coverage-</xsl:text>
				<xsl:value-of select="$studyURI"/>
				<xsl:text disable-output-escaping="yes"><![CDATA["/>]]></xsl:text>
			<!-- ..... -->
			
			<!-- ............... -->
			<!-- hasInstrument (→ Instrument): -->
				<xsl:text disable-output-escaping="yes"><![CDATA[ 
		<ddionto:hasInstrument rdf:resource="]]></xsl:text>
				<xsl:text>instrument-</xsl:text>
				<xsl:value-of select="$studyURI"/>
				<xsl:text disable-output-escaping="yes"><![CDATA["/>]]></xsl:text>
			<!-- ..... -->
			
			<!-- ............... -->
			<!-- isMeasureOf (→ Universe): -->
				<xsl:for-each select="//ddicb:codeBook/ddicb:stdyDscr/ddicb:stdyInfo/ddicb:sumDscr/ddicb:universe">
					<xsl:text disable-output-escaping="yes"><![CDATA[ 
		<ddionto:isMeasureOf rdf:resource="]]></xsl:text>
					<xsl:value-of select="."/>
					<xsl:text disable-output-escaping="yes"><![CDATA["/>]]></xsl:text>
				</xsl:for-each>
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

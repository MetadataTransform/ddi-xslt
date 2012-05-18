<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:si="http://www.w3schools.com/rdf/"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:skosclass="http://ddialliance.org/ontologies/skosclass"
    xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/" xmlns:ddionto="http://ddialliance.org/def#"
    xmlns:ddi="http://ddialliance.org/data/" xmlns:ddicb="http://www.icpsr.umich.edu/DDI">
    <xsl:output method="xml" indent="yes"/>

	<!--<xsl:variable name="studyURI">
            <xsl:choose>
                    <xsl:when test="//ddicb:codeBook/ddicb:stdyDscr/@ID">
                            <xsl:value-of select="//ddicb:codeBook/ddicb:stdyDscr/@ID"/>
                    </xsl:when>
                    <xsl:when test="//ddicb:codeBook/@ID">
                            <xsl:value-of select="//ddicb:codeBook/@ID"/>
                    </xsl:when>
            </xsl:choose>
    </xsl:variable>-->

    <!--<xsl:template match="ddicb:codeBook">-->
        <!-- including DataFile -->
        <!--<xsl:apply-templates select="//ddicb:fileDscr/ddicb:fileTxt"/>-->

        <!-- including DescriptiveStatistics -->
        <!--<xsl:apply-templates select="//ddicb:dataDscr/ddicb:var/ddicb:catgry"/>-->
        
        <!-- including Variables -->
        <!--<xsl:apply-templates select="//ddicb:dataDscr/ddicb:var"/>-->
        
        <!-- including DataElements -->
        <!-- no DataElement in DDI2.1 -->

    <!--</xsl:template>-->



    <!-- DataFile Template -->
    <xsl:template match="//ddicb:fileDscr/ddicb:fileTxt">

        <rdf:Description>
            <!-- URI -->
            <xsl:attribute name="rdf:about"><xsl:value-of select="$studyURI"/>-<xsl:value-of
                    select="ddicb:fileName"/></xsl:attribute>

            <!-- rdf:type -->
            <xsl:element name="rdf:type">
                <xsl:attribute name="rdf:resource"
                    >http://ddialliance.org/def#DataFile</xsl:attribute>
            </xsl:element>

            <!-- ddionto:hasCoverage -->
            <xsl:element name="ddionto:hasCoverage">
                <xsl:attribute name="rdf:resource">coverage-<xsl:value-of select="$studyURI"
                    /></xsl:attribute>
            </xsl:element>

            <!-- dc:identifier -->
            <xsl:if test="ddicb:fileName!=''">
                <xsl:element name="dc:identifier">
                    <xsl:value-of select="ddicb:fileName"/>
                </xsl:element>
            </xsl:if>

            <!-- dc:description -->
            <xsl:if test="ddicb:fileCont!=''">
                <xsl:element name="dc:description">
                    <xsl:value-of select="ddicb:fileCont"/>
                </xsl:element>
            </xsl:if>

            <!-- ddionto:caseQuantity -->
            <xsl:for-each select="ddicb:dimensns/ddicb:caseQnty">
                <xsl:element name="ddionto:caseQuantity">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:for-each>

            <!-- dc:format -->
            <xsl:if test="ddicb:fileType!=''">
                <xsl:element name="dc:format">
                    <xsl:value-of select="ddicb:fileType"/>
                </xsl:element>
            </xsl:if>

            <!-- dc:provenance -->
            <xsl:if test="ddicb:filePlac!=''">
                <xsl:element name="dc:provenance">
                    <xsl:value-of select="ddicb:filePlac"/>
                </xsl:element>
            </xsl:if>

            <!-- owl:versionInfo -->
            <xsl:for-each select="ddicb:verStmt">
                <xsl:choose>
                    <xsl:when test="ddicb:version!=''">
                        <xsl:element name="owl:versionInfo">
                            <xsl:value-of select="ddicb:version"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="owl:versionInfo">
                            <xsl:value-of select="ddicb:version/@date"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </rdf:Description>

    </xsl:template>


    <!-- DescriptiveStatistics Template -->
    <xsl:template match="//ddicb:dataDscr/ddicb:var/ddicb:catgry">

        <xsl:variable name="variableURI">
            <xsl:choose>
                <xsl:when test="../@name!=''">
                    <xsl:value-of select="../@name"/>
                </xsl:when>
                <xsl:when test="../@ID!=''">
                    <xsl:value-of select="../@ID"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>


        <rdf:Description>
            <!-- URI -->
            <xsl:attribute name="rdf:about">descriptiveStatistics-<xsl:value-of select="$studyURI"
                    />-<xsl:value-of select="$variableURI"/>-<xsl:value-of select="ddicb:catValu"
                /></xsl:attribute>

            <!-- rdf:type -->
            <xsl:element name="rdf:type">
                <xsl:attribute name="rdf:resource"
                    >http://ddialliance.org/def#DescriptiveStatistics</xsl:attribute>
            </xsl:element>

            <!-- ddionto:hasStatisticsValue -->
            <xsl:element name="ddionto:hasStatisticsValue">
                <xsl:attribute name="rdf:resource"><xsl:value-of select="$studyURI"/>-<xsl:value-of
                        select="$variableURI"/></xsl:attribute>
            </xsl:element>

            <!-- ddionto:hasStatisticsCategory -->
            <xsl:for-each select="ddicb:labl">
                <xsl:element name="ddionto:hasStatisticsCategory">
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="../ddicb:catValu"
                            />-<xsl:value-of select="."/></xsl:attribute>
                </xsl:element>
            </xsl:for-each>

            <!-- ddionto:hasStatisticsDataFile -->
            <xsl:for-each select="//ddicb:codeBook/ddicb:fileDscr/ddicb:fileTxt">
                <xsl:element name="ddionto:hasStatisticsDataFile">
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$studyURI"
                            />-<xsl:value-of select="ddicb:fileName"/></xsl:attribute>
                </xsl:element>
            </xsl:for-each>

            <!-- ddionto:frequency -->
            <!--<xsl:for-each select="ddicb:catStat[@type='freq'!='']">-->
            <!-- Thomas, 24.04.2012: -->
            <xsl:for-each select="ddicb:catStat[@type='freq']">
				<!-- Thomas, 24.04.2012: -->
				<xsl:if test=". != ''">
					<xsl:element name="ddionto:frequency">
						<xsl:value-of select="."/>
					</xsl:element>
				<!-- Thomas, 24.04.2012: -->
                </xsl:if>
            </xsl:for-each>

            <!-- ddionto:percentage -->
            <!--<xsl:for-each select="ddicb:catStat[@type='percent'!='']">-->
            <!-- Thomas, 24.04.2012: -->
            <xsl:for-each select="ddicb:catStat[@type='percent']">
				<!-- Thomas, 24.04.2012: -->
				<xsl:if test=". != ''">
					<xsl:element name="ddionto:percentage">
						<xsl:value-of select="."/>
					</xsl:element>
                <!-- Thomas, 24.04.2012: -->
                </xsl:if>
            </xsl:for-each>

            <!-- ddionto:weightedFrequency -->
            <!--<xsl:for-each select="ddicb:catStat[@type='freq'!='']">-->
            <!--<xsl:for-each select="ddicb:catStat[@type='freq'] !=''">-->
            <!-- Thomas, 24.04.2012: -->
            <xsl:for-each select="ddicb:catStat[@type='freq']">
				<!-- Thomas, 24.04.2012: -->
				<xsl:if test=". != ''">
					<!-- Thomas, 24.04.2012: -->
					<xsl:choose>
						<xsl:when test="@wgt-var != ''">
					<!--<xsl:if test="@wgt-var != ''">-->
							<xsl:element name="ddionto:weightedFrequency">
								<xsl:value-of select="."/>-<xsl:value-of select="@wgt-var"/>
							</xsl:element>
					<!--</xsl:if>-->
						</xsl:when>
						<xsl:when test="@weight!=''">
							<xsl:element name="ddionto:weightedFrequency">
								<xsl:value-of select="."/>-<xsl:value-of select="@weight"/>
							</xsl:element>
						</xsl:when>
					</xsl:choose>
				<!-- Thomas, 24.04.2012: -->
                </xsl:if>
                <!--<xsl:if test="@weight!=''">
                    <xsl:element name="ddionto:weightedFrequency">
                        <xsl:value-of select="."/>-<xsl:value-of select="@weight"/>
                    </xsl:element>
                </xsl:if>-->
            </xsl:for-each>

            <!-- ddionto:weightedBy -->
            <xsl:for-each select="ddicb:catStat[@type='freq']">
				<!-- Thomas, 24.04.2012: -->
				<xsl:choose>
					<xsl:when test="../../@name">
						<xsl:choose>
							<xsl:when test="@wgt-var!=''">
								<xsl:element name="ddionto:weightedBy">
									<xsl:value-of select="$studyURI"/>-<xsl:value-of select="../../@name"/>-<xsl:value-of select="@wgt-var"/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@weight!=''">
								<xsl:element name="ddionto:weightedBy">
									<xsl:value-of select="$studyURI"/>-<xsl:value-of select="../../@name"/>-<xsl:value-of select="@weight"/>
								</xsl:element>
							</xsl:when>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="../../@ID">
						<xsl:choose>
							<xsl:when test="@wgt-var!=''">
								<xsl:element name="ddionto:weightedBy">
									<xsl:value-of select="$studyURI"/>-<xsl:value-of select="../../@ID"/>-<xsl:value-of select="@wgt-var"/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@weight!=''">
								<xsl:element name="ddionto:weightedBy">
									<xsl:value-of select="$studyURI"/>-<xsl:value-of select="../../@ID"/>-<xsl:value-of select="@weight"/>
								</xsl:element>
							</xsl:when>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
                <!--<xsl:if test="@wgt-var!=''">
                    <xsl:element name="ddionto:weightedBy">
                        --><!-- Caution: Variable does not always have an ID, should be used name instead? --><!--
                        <xsl:value-of select="$studyURI"/>-<xsl:value-of select="../../@ID"
                            />-<xsl:value-of select="@wgt-var"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="@weight!=''">
                    <xsl:element name="ddionto:weightedBy">
                        <xsl:value-of select="$studyURI"/>-<xsl:value-of select="../../@ID"
                            />-<xsl:value-of select="@weight"/>
                    </xsl:element>
                </xsl:if>-->
            </xsl:for-each>

        </rdf:Description>
    </xsl:template>



    <!-- Variable Template -->
    <xsl:template match="//ddicb:dataDscr/ddicb:var">
        
        <xsl:variable name="variableBaseURI">
            <xsl:choose>
                <xsl:when test="@name!=''">
                    <xsl:value-of select="@name"/>
                </xsl:when>
                <xsl:when test="@ID!=''">
                    <xsl:value-of select="@ID"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        
        <rdf:Description>
            <!-- URI -->
            <xsl:attribute name="rdf:about"><xsl:value-of select="$studyURI"/>-<xsl:value-of select="$variableBaseURI"/></xsl:attribute>
            
            <!-- rdf:type -->
            <xsl:element name="rdf:type">
                <xsl:attribute name="rdf:resource">http://ddialliance.org/def#Variable</xsl:attribute>
            </xsl:element>

            <!-- ddionto:hasConcept -->
            <xsl:for-each select="ddicb:catgry/ddicb:labl">
                <xsl:element name="ddionto:hasConcept">
                    <xsl:attribute name="rdf:resource">
                    <xsl:value-of select="../ddicb:catValu"/>-<xsl:value-of select="."/></xsl:attribute>
                </xsl:element>
            </xsl:for-each>
            
            <!-- ddionto:holdsMeasurementOf -->
            <xsl:for-each select="ddicb:universe">
                <xsl:choose>
                    <xsl:when test="@ID!=''">                        
                        <xsl:element name="ddionto:holdsMeasurementOf"><xsl:attribute name="rdf:resource">universe-<xsl:value-of select="@ID"/></xsl:attribute>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="ddionto:holdsMeasurementOf"><xsl:attribute name="rdf:resource">universe-<xsl:value-of select="."/></xsl:attribute>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            
            <!-- ddionto:hasRepresentation -->
               <xsl:choose>
                    <xsl:when test="@name!=''">                        
                        <xsl:element name="ddionto:hasRepresentation"><xsl:attribute name="rdf:resource">representation-<xsl:value-of select="$studyURI"/>-<xsl:value-of select="@name"/></xsl:attribute>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="ddionto:hasRepresentation"><xsl:attribute name="rdf:resource">representation-<xsl:value-of select="$studyURI"/>-<xsl:value-of select="@ID"/></xsl:attribute>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>

            <!-- ddionto:isPopulatedBy -->
                <xsl:element name="ddionto:isPopulatedBy">
                    <xsl:attribute name="rdf:resource">instrument-<xsl:value-of select="$studyURI"/></xsl:attribute>
                </xsl:element>

            <!-- ddionto:hasQuestion -->
            <xsl:for-each select="ddicb:qstn">
                <xsl:choose>
                    <xsl:when test="@ID!=''">                        
                        <xsl:element name="ddionto:hasQuestion"><xsl:attribute name="rdf:resource"><xsl:value-of select="@ID"/></xsl:attribute>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="../@ID!=''">                        
                        <xsl:element name="ddionto:hasQuestion"><xsl:attribute name="rdf:resource">question-<xsl:value-of select="../@ID"/></xsl:attribute>
                        </xsl:element>
                    </xsl:when>                    
                    <xsl:otherwise>
                        <xsl:element name="ddionto:hasQuestion"><xsl:attribute name="rdf:resource"><xsl:value-of select="ddicb:qstnLit"/></xsl:attribute>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>

            <!-- ddionto:usesDataElement -->
            <!-- no DataElement in DDI2.1 -->

            <!-- dc:identifier -->
            <xsl:choose>
            <xsl:when test="@name!=''">
                <xsl:element name="dc:identifier">
                    <xsl:value-of select="$studyURI"/>-<xsl:value-of select="@name"/>
                </xsl:element>
            </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="dc:identifier">
                        <xsl:value-of select="$studyURI"/>-<xsl:value-of select="@ID"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>

            <!-- skos:prefLabel -->
            <xsl:if test="ddicb:labl!=''">
                <xsl:element name="skos:prefLabel">
                    <xsl:value-of select="ddicb:labl"/>
                </xsl:element>
            </xsl:if>
            
            <!-- dc:description -->
            <xsl:if test="ddicb:txt!=''">
                <xsl:element name="dc:description">
                    <xsl:value-of select="ddicb:txt"/>
                </xsl:element>
            </xsl:if>

</rdf:Description>
</xsl:template>

        <!-- DataFile Template -->
        <!-- no DataElement in DDI2.1 -->



</xsl:stylesheet>

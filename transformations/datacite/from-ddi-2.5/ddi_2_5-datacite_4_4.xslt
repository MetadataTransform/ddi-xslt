<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:c="ddi:codebook:2_5"
    xmlns:meta="transformation:metadata"
    xmlns:ddi="http://www.ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/codebook.xsd"   
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xsi:schemaLocation="http://schema.datacite.org/meta/kernel-4.4 http://schema.datacite.org/meta/kernel-4.4/metadata.xsd"

    exclude-result-prefixes="#all"
    version="2.0">
    <meta:metadata>
        <identifier>ddi-2.5-to-datacite-4.4</identifier>
        <title>DDI 2.5 to DataCite 4.4</title>
        <description>Convert DDI Codebook (2.5) to DataCite</description>
        <outputFormat>XML</outputFormat>
        <parameters>
            <parameter name="root-element" format="xs:string" description="Root element"/>
        </parameters>
    </meta:metadata>
    
    <xsl:param name="root-element">resource</xsl:param>
 
    <xsl:output method="xml" indent="yes" />
    

<xsl:template match="//c:stdyDscr">
        <resource xmlns="https://schema.datacite.org/meta/kernel-4.4/metadata.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="https://schema.datacite.org/meta/kernel-4.4/metadata.xsd">
            
            <!-- 1 identifier -->
            <identifier identifierType="DOI">
                    <xsl:if test="c:citation/c:titlStmt/c:IDNo[@agency='DataCite']">
                        <xsl:value-of select="c:citation/c:titlStmt/c:IDNo[@agency='DataCite']"/>
                    </xsl:if>
            </identifier>
            <identifier>
                    <xsl:if test="c:citation/c:titlStmt/c:IDNo[@agency!='DataCite']">
                        <xsl:value-of select="c:citation/c:titlStmt/c:IDNo[@agency!='DataCite']"/>
                    </xsl:if>
            </identifier>

            <!-- 2 creators -->
            <!-- last name comes before first name(s) separated by comma ("family, given") -->
            <creators>
                    <xsl:for-each select="c:citation/c:rspStmt/c:AuthEnty">
                        <creator>
                            <creatorName>
                                <xsl:if test="@xml:lang">
                                    <xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang"/></xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="."/> 
                                <!-- <xsl:value-of select="r:CreatorName"/> -->
                                <!-- <xsl:call-template name="formatName">
                                    <xsl:with-param name="name" select="."/>
                                </xsl:call-template> -->
                            </creatorName>
                            <affiliation>
                                <xsl:if test="@affiliation">
                                    <xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang"/></xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="@affiliation"/>
                            </affiliation>
                        </creator>
                    </xsl:for-each>
                    <!-- <xsl:otherwise>
                        <xsl:text>Unknown</xsl:text>
                    </xsl:otherwise> -->
                        <!-- <xsl:variable name="agency" select="r:CreatorReference/r:Agency" />
                        <xsl:variable name="creatorid" select="r:CreatorReference/r:ID" />
                        <xsl:value-of select="$agency/$creatorid" /> -->
            </creators>   
            <!-- 3 titles -->
            <titles>
                <xsl:for-each select="c:citation/c:titlStmt/c:titl">
                       <title>
                            <xsl:if test="@xml:lang">
                                <xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang"/></xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="."/>
                           <!-- Note: Use following if just 'en' needed to get.                             -->
                           <!-- <xsl:if test="@xml:lang='en'">
                               <xsl:attribute name="xml:lang"><xsl:value-of select="if (@xml:lang = 'en') then
                               (@xml:lang) else ()"/></xsl:attribute>
                           </xsl:if>
                           <xsl:value-of select="if (@xml:lang = 'en') then
                               (.) else null"/> -->
                       </title>
                </xsl:for-each>
                <xsl:for-each select="c:citation/c:titlStmt/c:altTitl">
                    <title titleType="AlternativeTitle">                            
                        <xsl:if test="@xml:lang">
                            <xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang"/></xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="."/>
                    </title>
                </xsl:for-each>
                <xsl:for-each select="c:citation/c:titlStmt/c:sybTitl">
                    <title titleType="Subtitle">                            
                        <xsl:if test="@xml:lang">
                            <xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang"/></xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="."/>
                    </title>
                </xsl:for-each>
                <xsl:for-each select="c:citation/c:titlStmt/c:parTitl">
                    <title titleType="TranslatedTitle">                        
                        <xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang"/></xsl:attribute>
                        <xsl:value-of select="."/>
                    </title>
                </xsl:for-each>
            </titles>

            <!-- 6 subjects -->
            <xsl:if test="c:stdyInfo/c:subject/child::*">
                <subjects>
                    <xsl:for-each select="c:stdyInfo/c:subject/c:topcClas">
                        <subject>
                            <xsl:if test="@vocab">
                                <xsl:attribute name="subjectScheme"><xsl:value-of select="@vocab"/></xsl:attribute>
                            </xsl:if>
                            <xsl:if test="@xml:lang">
                                <xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang"/></xsl:attribute>
                            </xsl:if> 
                            <xsl:value-of select="."/>
                        </subject>
                    </xsl:for-each>
                    <xsl:for-each select="c:stdyInfo/c:subject/c:topcClas">
                        <subject>
                            <xsl:if test="@vocabURI">
                                <xsl:attribute name="subjectScheme"><xsl:value-of select="@vocabURI"/></xsl:attribute>
                            </xsl:if>
                            <xsl:if test="@xml:lang">
                                <xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang"/></xsl:attribute>
                            </xsl:if> 
                            <xsl:value-of select="."/>
                        </subject>
                    </xsl:for-each>
                    <xsl:for-each select="c:stdyInfo/c:subject/c:keyword">
                        <subject>
                            <xsl:if test="@vocab">
                                <xsl:attribute name="subjectScheme"><xsl:value-of select="@vocab"/></xsl:attribute>
                            </xsl:if>
                            <xsl:if test="@vocabURI">
                                <xsl:attribute name="schemeURI"><xsl:value-of select="@vocabURI"/></xsl:attribute>
                            </xsl:if>
                            <!-- <xsl:if test="@vocab">
                                <xsl:attribute name="valueURI"><xsl:value-of select="@vocab"/></xsl:attribute>
                            </xsl:if>
                            <xsl:if test="@vocab">
                                <xsl:attribute name="classificationCode"><xsl:value-of select="@codeListID"/></xsl:attribute>
                            </xsl:if> -->
                            <xsl:if test="@xml:lang">
                                <xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang"/></xsl:attribute>
                            </xsl:if>                                    
                            <xsl:value-of select="."/>
                        </subject>
                    </xsl:for-each>
                </subjects>
                            
            <!-- 7 contributors -->
            <xsl:if test="c:method/c:dataColl/c:dataCollector|c:citation/c:rspStmt/c:othId">
                <contributors>
                    <xsl:for-each select="c:method/c:dataColl/c:dataCollector|c:citation/c:rspStmt/c:othId">
                        <contributor>
                            <xsl:if test="@role">
                                <xsl:attribute name="contributorType"><xsl:value-of select="@role"/></xsl:attribute>                                        
                            </xsl:if>
                            <contributorName>
                                <xsl:call-template name="formatName">
                                    <xsl:with-param name="name" select="."/>
                                </xsl:call-template>
                            </contributorName>
                        </contributor>
                    </xsl:for-each>
                </contributors>
            </xsl:if>
            </xsl:if>

            <!-- 9 language -->
            <xsl:if test="c:citation/c:language">
                <language>
                    <xsl:value-of select="c:citation/c:language"/>
                </language>
            </xsl:if>
            
            <!-- 11 alternateIdentifiers -->
            <xsl:if test="c:citation/c:holdings">
                <alternateIdentifiers>
                    <xsl:for-each select="c:citation/c:holdings">
                        <alternateIdentifier>
                            <xsl:attribute name="alternateIdentifierType"><xsl:value-of select="@type"/></xsl:attribute>
                            <xsl:value-of select="c:citation/c:holdings"/>                            
                        </alternateIdentifier>
                    </xsl:for-each>
                </alternateIdentifiers>                
            </xsl:if>
            
            <!-- 13 size -->
            <xsl:if test="c:dataAccs/c:setAvail/c:collSize | c:dataAccs/c:setAvail/c:fileQnty">
                <sizes>
                    <xsl:choose>     
                        <xsl:when test="c:dataAccs/c:setAvail/c:collSize">
                            <size><xsl:value-of select="c:dataAccs/c:setAvail/c:collSize"/> data files</size>
                        </xsl:when>
                        <xsl:when test="c:dataAccs/c:setAvail/c:fileQnty">
                            <size><xsl:value-of select="c:dataAccs/c:setAvail/c:fileQnty"/> data files</size>
                        </xsl:when>
                    </xsl:choose> 
                </sizes>
            </xsl:if>
            
            <!-- 15 version -->
            <!-- Note: mapped by DataCite to pi:PhysicalInstance/@version -->
            <xsl:choose>
            <xsl:when test="c:citation/c:verStmt/c:version">
                    <version>
                      <xsl:if test="@xml:lang">
                        <xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang"/></xsl:attribute>
                      </xsl:if> 
                      <xsl:value-of select="c:citation/c:verStmt/c:version"/>
                    </version>
                </xsl:when>
            </xsl:choose>
            
            <!-- 16 rights -->
            <!-- Field maps to dc:rights -->
            <xsl:choose>
                <xsl:when test="c:citation/c:prodStmt/c:copyright">
                    <rightsList><rights><xsl:value-of select="c:citation/c:prodStmt/c:copyright"/></rights></rightsList>
                </xsl:when>
                <xsl:when test="c:dataAccs/c:setAvail/c:avlStatus">
                    <rights><xsl:value-of select="c:dataAccs/c:setAvail/c:avlStatus"/></rights>
                </xsl:when>
                <xsl:when test="c:dataAccs/c:useStmt/c:restrctn">
                    <rights><xsl:value-of select="c:dataAccs/c:useStmt/c:restrctn"/></rights>
                </xsl:when>
                <xsl:when test="c:dataAccs/c:useStmt/c:conditions">
                    <rights><xsl:value-of select="c:dataAccs/c:useStmt/c:conditions"/></rights>
                </xsl:when>
                <xsl:when test="c:dataAccs/c:useStmt/c:disclaime">
                    <rights><xsl:value-of select="c:dataAccs/c:useStmt/c:disclaime"/></rights>
                </xsl:when>
                <xsl:otherwise>
                    <rights><xsl:text>Not specified</xsl:text></rights>
                </xsl:otherwise>
            </xsl:choose>
        </resource>
</xsl:template>

	<!--
    Formats a name to family, given format. If name is an organization or
    contains any comma, no formatting is applied apart from normalize-space.
    -->   
    <xsl:template name="formatName">
        <xsl:param name="name" />
        <xsl:variable name="normalized" select="normalize-space($name)"/>
        
        <xsl:choose>
            <xsl:when test="contains($normalized, ',')">
                <!-- name is (presumably) already in family, given format -->
                <xsl:value-of select="$normalized"/>
            </xsl:when>
            <xsl:when test="not(contains($normalized, ' '))">
                <!-- name contains no spaces, we are done -->
                <xsl:value-of select="$normalized"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- name needs to be transformed to family, given format -->
                <xsl:call-template name="transformName">
                    <xsl:with-param name="name" select="$normalized" />
                </xsl:call-template>
            </xsl:otherwise>             
        </xsl:choose>
 
    </xsl:template>

    <!-- 
    Transforms a string of form "Given Family" to "Family, Given".
    Assumes input string is normalized and contains at least one space.
    -->
    <xsl:template name="transformName">
        <xsl:param name="name" />
        <xsl:param name="acc" />
        <xsl:variable name="first" select="substring-before($name, ' ')" />
        <xsl:variable name="remaining" select="substring-after($name, ' ')" />     

        <!-- call recursively until remaining is empty -->
        <xsl:choose>
            <xsl:when test="$remaining">
                <xsl:call-template name="transformName">
                    <xsl:with-param name="name" select="$remaining" />
                    <xsl:with-param name="acc" select="concat($acc, ' ', $first)" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$name"/>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="$acc"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- TODO: c:parTitl is important to have in title tag? -->
    <!-- <xsl:template match="c:titl">
        <dcterms:title>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
        </dcterms:title>        
    </xsl:template> -->

    <!-- <xsl:template match="c:IDNo" >
        <xsl:element name="IDNo">
            <xsl:attribute name="agency">
                <xsl:value-of select="@agency" />
            </xsl:attribute>
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template> -->


    
</xsl:stylesheet>
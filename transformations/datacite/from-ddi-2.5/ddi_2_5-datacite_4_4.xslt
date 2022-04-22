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
    xmlns="http://datacite.org/schema/kernel-4"
    xsi:schemaLocation="http://datacite.org/schema/kernel-4 http://schema.datacite.org/meta/kernel-4.4/metadata.xsd"

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
    
<xsl:template match="//c:docDscr | //c:dataDscr | //c:fileDscr"></xsl:template>
<xsl:template match="//c:stdyDscr | //c:fileDscr/c:fileTxt/c:format">
    <xsl:element name="{$root-element}" xmlns:xs="http://www.w3.org/2001/XMLSchema"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xmlns:dc="http://purl.org/dc/elements/1.1/"
              xmlns:dcterms="http://purl.org/dc/terms/"
              xmlns:c="ddi:codebook:2_5"
              xmlns:meta="transformation:metadata"
              xmlns:ddi="http://www.ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/codebook.xsd"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns="http://datacite.org/schema/kernel-4"
              xsi:schemaLocation="https://schema.datacite.org/meta/kernel-4.4/metadata.xsd">

        <!--Contents:

            Id | DDI-2.5 	         | DataCite-4.4
          =============================================================
            1  	  Identifier	        /resource/identifier
                                        /resource/alternateIdentifiers/alternateIdentifier/@alternateIdentifierType = Local call number
            2  	  Creators	            /resouce/creators/creator/creatorName
                                        /resource/creators/creator/affiliation
            3  	  Titles	            /resource/titles/title 
                                        /resource/titles/title + /resource/titles/title/@titleType=Subtitle
                                        /resource/titles/title + /resource/titles/title/@titleType=AlternativeTitle
                                        /resource/titles/title + /resource/titles/title/@titleType=TranslatedTitle
            4  	  Publisher	            /resource/publisher
            5  	  Subjects	            /resource/subjects/subject
                                        /resource/subjects/subject/@subjectScheme
                                        /resource/subjects/subject/@subjectURI
            6  	  Contributers	        /resource/contributors/contributor/contributorName
                                        /resource/contributors/contributor/@contributorType
                                        /resource/contributors/contributor/affiliation
                                        /resource/contributors/contributor/@contributorType = DataCollector
            7  	  Distributor	        /resource/contributors/contributor + /resource/contributors/contributor/@contributorType = Distributor
            8  	  Contact Persons	    /resource/contributors/contributor + /resource/contributors/contributor/@contributorType = ContactPerson
            9 	  Dates	                /resource/dates/date/ + /resource/dates/date/@dateType=Submitted
                                        /resource/dates/date/@dateType = Issued
                                        /resource/dates/date/@dateType=Created
                                        /resource/dates/date/@dateInformation = Time period covered
                                        /resource/dates/date/@dateType=Updated
                                        /resource/dates/date/@dateType=Other
                                        /resource/dates/date/@dateType=Collected
                                        /resource/publicationYear
            10 	  Language	            /resource/language
            11 	  Size	                /resource/size
            12 	  Version	            /resource/version
            13 	  Rights	            /resource/rightsList/rights
            14 	  Descriptions	        /resource/description + /resource/description/descriptionType = Abstract
                                        /resource/description/descriptionType = SeriesInformation
            15 	  Geolocation	        /resource/geoLocations/geoLocation/geoLocationPlace
                                        /resource/geoLocations/geoLocation/geoLocationBox
                                        /resource/geoLocations/geoLocation/geoLocationPolygon
            16 	  Other Material	    /resource/relatedItems/relatedItem/@relationType = isPartOf
                                        /resource/relatedItems/relatedItem
            17    Funding	            /resource/funderReference/funderName
                                        /resource/funderReference/awardNumber
            18    Data Format           /resource/format
          =============================================================   -->              

        <!-- 1 Identifier -->
        <xsl:if test="c:citation/c:titlStmt/c:IDNo[@agency='DOI']">
        <identifier identifierType="DOI">
            <xsl:value-of select="c:citation/c:titlStmt/c:IDNo[@agency='DOI']"/>
        </identifier>
        </xsl:if>        
        <xsl:if test="c:citation/c:titlStmt/c:IDNo[@agency='DOI']">
            <alternateIdentifiers>
                <alternateIdentifier>
                    <xsl:attribute name="alternateIdentifierType">Local call number</xsl:attribute>
                    <xsl:value-of select="c:citation/c:titlStmt/c:IDNo[@agency='DOI']"/>
                </alternateIdentifier>
            </alternateIdentifiers>
        </xsl:if>
        <xsl:if test="c:citation/c:holdings">
            <alternateIdentifiers>
                <xsl:for-each select="c:citation/c:holdings">
                    <xsl:if test="@callno">
                        <alternateIdentifier alternateIdentifierType="Local call number">
                            <xsl:value-of select="@callno" />
                        </alternateIdentifier>
                    </xsl:if>
                    <xsl:if test="@URI">
                        <alternateIdentifier alternateIdentifierType="URL">
                            <xsl:value-of select="@URI" />
                        </alternateIdentifier>
                    </xsl:if>
                </xsl:for-each>
            </alternateIdentifiers>                
        </xsl:if>
        <!-- 2 Creators -->
        <creators>
            <creator>
                <xsl:copy-of select="meta:mapLiteral('creatorName', c:citation/c:rspStmt/c:AuthEnty, null, null)" />
                <xsl:copy-of select="meta:mapLiteral('affiliation', c:citation/c:rspStmt/c:AuthEnty/@affiliation, null, null)" />
            </creator>
        </creators>
        <!-- 3 Titles -->
        <titles>
            <xsl:copy-of select="meta:mapLiteral('title', c:citation/c:titlStmt/c:titl, null, null)" />
            <xsl:copy-of select="meta:mapLiteral('title', c:citation/c:titlStmt/c:altTitl, 'titleType','AlternativeTitle')" />
            <xsl:copy-of select="meta:mapLiteral('title', c:citation/c:titlStmt/c:subTitl, 'titleType','Subtitle')" />
            <xsl:copy-of select="meta:mapLiteral('title', c:citation/c:titlStmt/c:parTitl, 'titleType','TranslatedTitle')" />
        </titles>
        <!-- 4 Publisher -->
        <xsl:copy-of select="meta:mapLiteral('publisher', c:citation/c:prodStmt/c:producer, null, null)" />
        <!-- 5 Subjects -->
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
                        <xsl:if test="@vocab">
                            <xsl:attribute name="subjectScheme"><xsl:value-of select="@vocab"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="@vocabURI">
                            <xsl:attribute name="subjectURI"><xsl:value-of select="@vocabURI"/></xsl:attribute>
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
                            <xsl:attribute name="subjectURI"><xsl:value-of select="@vocabURI"/></xsl:attribute>
                        </xsl:if> 
                        <xsl:if test="@xml:lang">
                            <xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang"/></xsl:attribute>
                        </xsl:if>                                    
                        <xsl:value-of select="."/>
                    </subject>
                </xsl:for-each>
            </subjects>
            </xsl:if>
        <!-- 6 Contributors -->
        <!-- 7 Distributor -->
        <!-- 8 Contact Persons -->
        <contributors>
            <xsl:copy-of select="meta:mapLiteral('contributor', c:method/c:dataColl/c:dataCollector, 'contributorType', 'DataCollector')" />
            <xsl:if test="c:citation/c:rspStmt/c:othId">
                <contributor>
                    <contributorName>
                        <xsl:call-template name="formatName">
                            <xsl:with-param name="name" select="c:citation/c:rspStmt/c:othId"/>
                        </xsl:call-template>
                    </contributorName>
                </contributor>
            </xsl:if>
            <xsl:copy-of select="meta:mapLiteral('contributor', c:citation/c:distStmt/c:distrbtr, 'contributorType', 'Distributor')" />
            <xsl:copy-of select="meta:mapLiteral('contributor', c:citation/c:distStmt/c:contact, 'contributorType', 'Contact Person')" />
            <contributor>
                <xsl:copy-of select="meta:mapLiteral('affiliation', c:citation/c:rspStmt/c:othId/@affiliation, null, null)" />
            </contributor>
        </contributors>
        <!-- 9 Dates -->
        <dates>
            <xsl:copy-of select="meta:mapLiteral('date', c:citation/c:prodStmt/c:prodDate, 'dateType', 'Created')" />
            <xsl:copy-of select="meta:mapLiteral('date', c:citation/c:distStmt/c:depDate, 'dateType', 'Submitted')" />
            <xsl:copy-of select="meta:mapLiteral('date', c:citation/c:distStmt/c:distDate, 'dateType', 'Issued')" />
            <xsl:copy-of select="meta:mapLiteral('date', c:citation/c:verStmt/c:version/@date, 'dateType', 'Updated')" />
            <xsl:copy-of select="meta:mapLiteral('date', c:stdyInfo/c:sumDscr/c:collDate, 'dateType', 'Collected')" />
            <xsl:for-each select="c:stdyInfo/c:sumDscr/c:timePrd">
                <xsl:variable name="singleDate" select="if (@event='single') then (@date) else null"/>                      
                <xsl:variable name="startdate" select="if (@event='start') then (@date) else null"/>
                <xsl:choose>
                <xsl:when test="@event='start'">
                    <date dateType='Other'>
                    <xsl:value-of select="$startdate" />
                    <xsl:text>/</xsl:text>
                    <xsl:value-of select="following-sibling::*[name() = name(current())][1]/@date"/>
                    </date>
                </xsl:when>
                </xsl:choose>
            </xsl:for-each>
            <xsl:for-each select="c:stdyInfo/c:sumDscr/c:timePrd">
                <xsl:variable name="singleDate" select="if (@event='single') then (@date) else null"/>                      
                <xsl:variable name="startdate" select="if (@event='start') then (@date) else null"/>            
                <xsl:choose>
                <xsl:when test="@event='single'">
                    <date dateType='Other'>
                    <xsl:value-of select="$singleDate" />
                    </date>
                </xsl:when>
                </xsl:choose>
                <xsl:choose>
                <xsl:when test="@event='start'">
                    <date dateInformation='Time period covered'>
                    <xsl:value-of select="$startdate" />
                    <xsl:text>/</xsl:text>
                    <xsl:value-of select="following-sibling::*[name() = name(current())][1]/@date"/>
                    </date>
                </xsl:when>
                <xsl:when test="@event='single'">
                    <date dateInformation='Time period covered'>
                    <xsl:value-of select="$singleDate" />
                    </date>
                </xsl:when>
                </xsl:choose>
            </xsl:for-each>
            <xsl:copy-of select="meta:mapLiteral('publicationYear', c:citation/c:distStmt/c:distDate, null, null)" />
        </dates>
        <!-- 10 Language -->
        <xsl:copy-of select="meta:mapLiteral('language', c:citation/c:language, null, null)" />
        <!-- 11 Size -->
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
        <!-- 12 Version -->
        <xsl:copy-of select="meta:mapLiteral('version', c:citation/c:verStmt/c:version, null, null)" />
        <!-- 13 Rights -->
        <rightsList>
            <xsl:copy-of select="meta:mapLiteral('rights', c:citation/c:prodStmt/c:copyright, null, null)" />
            <xsl:copy-of select="meta:mapLiteral('rights', c:dataAccs/c:setAvail/c:avlStatus, null, null)" />
            <xsl:copy-of select="meta:mapLiteral('rights', c:dataAccs/c:useStmt/c:restrctn, null, null)" />
            <xsl:copy-of select="meta:mapLiteral('rights', c:dataAccs/c:useStmt/c:confDec, null, null)" />
            <xsl:copy-of select="meta:mapLiteral('rights', c:dataAccs/c:useStmt/c:specPerm, null, null)" />
            <xsl:copy-of select="meta:mapLiteral('rights', c:dataAccs/c:useStmt/c:conditions, null, null)" />
            <xsl:copy-of select="meta:mapLiteral('rights', c:dataAccs/c:useStmt/c:disclaimer, null, null)" />
        </rightsList>
        <!-- 14 Descriptions -->
        <xsl:copy-of select="meta:mapLiteral('description', c:stdyInfo/c:abstract, null, null)" />
        <xsl:copy-of select="meta:mapLiteral('description', c:citation/c:serStmt/c:serInfo, null, null)" />
        <!-- 15 Geolocation -->
        <xsl:if test= "c:stdyInfo/c:sumDscr/nation|c:stdyInfo/c:sumDscr/c:geogCover">
            <geoLocations>
                <geoLocation>
                    <xsl:copy-of select="meta:mapLiteral('geoLocationPlace', c:stdyInfo/c:sumDscr/nation, null, null)" />
                    <xsl:copy-of select="meta:mapLiteral('geoLocationPlace', c:stdyInfo/c:sumDscr/c:geogCover, null, null)" />
                    <geoLocationBox>
                        <xsl:copy-of select="meta:mapLiteral('westBoundLongitude', c:stdyInfo/c:sumDscr/c:geoBndBox/c:westBL, null, null)" />
                        <xsl:copy-of select="meta:mapLiteral('eastBoundLongitude', c:stdyInfo/c:sumDscr/c:geoBndBox/c:eastBL, null, null)" />
                        <xsl:copy-of select="meta:mapLiteral('southBoundLatitude', c:stdyInfo/c:sumDscr/c:geoBndBox/c:southBL, null, null)" />
                        <xsl:copy-of select="meta:mapLiteral('northBoundLatitude', c:stdyInfo/c:sumDscr/c:geoBndBox/c:northBL, null, null)" />
                    </geoLocationBox>
                    <geoLocationPolygon>
                        <polygonPoint>
                            <xsl:copy-of select="meta:mapLiteral('pointLatitude', c:stdyInfo/c:sumDscr/c:boundPoly/c:polygon/c:point/c:gringLat, null, null)" />
                            <xsl:copy-of select="meta:mapLiteral('pointLongitude', c:stdyInfo/c:sumDscr/c:boundPoly/c:polygon/c:point/c:gringLon, null, null)" />
                        </polygonPoint>
                    </geoLocationPolygon>
                </geoLocation>
            </geoLocations>
        </xsl:if>
        <!-- 16 Other Material -->
        <xsl:if test="c:othrStdymat|c:citation/c:serStmt/c:serName">
            <relatedItems>
                <xsl:copy-of select="meta:mapLiteral('relatedItem', c:othrStdyMat/c:relMat, null, null)" />
                <xsl:copy-of select="meta:mapLiteral('relatedItem', c:othrStdyMat/c:relStdy, null, null)" />
                <xsl:copy-of select="meta:mapLiteral('relatedItem', c:othrStdyMat/c:relPubl, null, null)" />
                <xsl:copy-of select="meta:mapLiteral('relatedItem', c:othrStdyMat/c:othRefs, null, null)" />
                <xsl:copy-of select="meta:mapLiteral('relatedItem', c:citation/c:serStmt/c:serName, 'relationType', 'IsPartOf')" />
            </relatedItems>
        </xsl:if>
        <!-- 17 Funding -->
        <xsl:if test="c:citation/c:prodStmt/c:fundAg|c:citation/c:prodStmt/c:grantNo">
            <funderReference>
                <xsl:copy-of select="meta:mapLiteral('funderName', c:citation/c:prodStmt/c:fundAg, null, null)" />
                <xsl:copy-of select="meta:mapLiteral('awardNumber', c:citation/c:prodStmt/c:grantNo, null, null)" />
                <xsl:copy-of select="meta:mapLiteral('funderName', c:citation/c:prodStmt/c:grantNo/@agency, null, null)" />
            </funderReference>
        </xsl:if>
        <!-- 18 Data Format -->
            <xsl:copy-of select="meta:mapLiteral('format', //c:fileDscr/c:fileTxt/c:format, null, null)" />
    </xsl:element>
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
Transforms a string of form Given Family to Family, Given.
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

    <xsl:function name="meta:mapLiteral">
        <xsl:param name="element" />
        <xsl:param name="content" />
        <xsl:param name="attribute" />
        <xsl:param name="attribValue" />

        <xsl:for-each select="$content">
            <xsl:element name="{$element}">
            <xsl:copy-of select="@xml:lang" />
            <xsl:if test="$attribute!='null'">
            <xsl:attribute name="{$attribute}"><xsl:value-of select= "$attribValue" /></xsl:attribute>
            </xsl:if>
            <xsl:value-of select ="." />
            </xsl:element>
        </xsl:for-each> 
    </xsl:function>
</xsl:stylesheet>
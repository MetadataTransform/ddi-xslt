<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://datacite.org/schema/kernel-2.2"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:g="ddi:group:3_1"
    xmlns:d="ddi:datacollection:3_1" xmlns:dce="ddi:dcelements:3_1"
    xmlns:c="ddi:conceptualcomponent:3_1" xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:a="ddi:archive:3_1" xmlns:m1="ddi:physicaldataproduct/ncube/normal:3_1"
    xmlns:ddi="ddi:instance:3_1 http://www.ddialliance.org/sites/default/files/schema/ddi3.1/instance.xsd"
    xmlns:m2="ddi:physicaldataproduct/ncube/tabular:3_1" xmlns:o="ddi:organizations:3_1"
    xmlns:l="ddi:logicalproduct:3_1" xmlns:m3="ddi:physicaldataproduct/ncube/inline:3_1"
    xmlns:pd="ddi:physicaldataproduct:3_1" xmlns:cm="ddi:comparative:3_1"
    xmlns:s="ddi:studyunit:3_1" xmlns:r="ddi:reusable:3_1" xmlns:pi="ddi:physicalinstance:3_1"
    xmlns:ds="ddi:dataset:3_1" xmlns:pr="ddi:profile:3_1"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0"
    exclude-result-prefixes="dc g d dce c xhtml a m1 ddi m2 o l m3 pd cm s r pi ds pr xsl">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <!--
    Document   : ddi_3_1-datacite_2_2.xsl
    Version    : development
    Created on : den 11 december 2011, 22:29
    Description: extract metadata from DDI 3.1 to DataCite metadata
    
    DOC: http://schema.datacite.org/meta/kernel-2.2/doc/DataCite-MetadataKernel_v2.2.pdf
    
    progress:
    id     | datacite              | ddi3
    =======================================
    1       +Identifier
    2       +Creator
    2.1     creatorName
    2.2     nameIdentifier
    2.2.1   nameIdentifierScheme
    3       +title
    4       publisher               r:Publisher
    ?       publicationYear         r:PublicationDate
    ?       +subject                r:Subject && r:Keyword
    ?       +date                    r:StatDate && r:EndDate
    ?       language                parameter
    ?       resourceType            s:KindOfData
    ?       alternateIdentifier   s:CallNumber
    ?       +format                 parameter
    ?       rights                     a:AccessConditions
    ?       +description           	s:Abstract, s:purpose
    -->

    <!-- if the DOI is supplied as a parameter then use that rather than the one from the DDI-instance -->
    <xsl:param name="doi"/>

    <!-- language use to substract text from the ddi-l file -->
    <xsl:param name="lang">en</xsl:param>

    <!-- primary language of resource -->
    <xsl:param name="resourceLang">en</xsl:param>

    <!-- space seperated string defining formats prefered in mime types -->
    <!-- usual formats: 
    application/x-ddi-l+xml 
    text/csv 
    application/x-stata 
    application/x-sas 
    application/x-spss-sav  
    application/x-R-2
    -->
    <xsl:param name="formats">application/x-ddi-l+xml</xsl:param>

    <xsl:template match="*">
        <xsl:apply-templates select="s:StudyUnit"/>
    </xsl:template>

    <xsl:template match="//s:StudyUnit">
        <resource
            xsi:schemaLocation="http://datacite.org/schema/kernel-2.2 http://schema.datacite.org/meta/kernel-2.2/metadata.xsd">
            <identifier identifierType="DOI">
                <xsl:choose>
                    <xsl:when test="$doi">
                        <xsl:value-of select="$doi"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="r:Citation/r:InternationalIdentifier[@type='DOI']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </identifier>

            <!-- creators -->
            <!-- last name comes before first name(s) separated by comma ("family, given") -->
            <creators>
                <xsl:choose>
                    <xsl:when test="r:Citation/r:Creator/@xml:lang">
                        <xsl:for-each select="r:Citation/r:Creator[@xml:lang = $lang]">
                            <xsl:variable name="tokenizedName" select="tokenize(.,'\s+')"/>
                            <creator>
                                <creatorName>
                                    <xsl:choose>
                                        <xsl:when test="count($tokenizedName) > 1">
                                            <xsl:value-of
                                                select="concat($tokenizedName[last()], ', ', normalize-space(substring-before(., $tokenizedName[last()])))"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="."/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </creatorName>
                            </creator>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="r:Citation/r:Creator">
                            <xsl:variable name="tokenizedName" select="tokenize(.,'\s+')"/>
                            <creator>
                                <creatorName>
                                    <xsl:choose>
                                        <xsl:when test="count($tokenizedName) > 1">
                                            <xsl:value-of
                                                select="concat($tokenizedName[last()], ', ', normalize-space(substring-before(., $tokenizedName[last()])))"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="."/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </creatorName>
                            </creator>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </creators>

            <titles>
                <xsl:choose>
                    <xsl:when test="r:Citation/r:Title[@xml:lang = $lang]">
                        <title>
                            <xsl:value-of select="r:Citation/r:Title[@xml:lang = $lang]"/>
                        </title>
                    </xsl:when>
                    <xsl:otherwise>
                        <title>
                            <xsl:value-of select="r:Citation/r:Title"/>
                        </title>
                    </xsl:otherwise>
                </xsl:choose>
            </titles>

            <!-- publisher -->
            <xsl:if test="r:Citation/r:Publisher">
                <xsl:choose>
                    <xsl:when test="r:Citation/r:Publisher/@xml:lang">
                        <publisher>
                            <xsl:value-of select="r:Citation/r:Publisher[@xml:lang = $lang]"/>
                        </publisher>
                    </xsl:when>
                    <xsl:otherwise>
                        <publisher>
                            <xsl:value-of select="r:Citation/r:Publisher"/>
                        </publisher>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <!-- publication year -->
            <xsl:if test="r:Citation/r:PublicationDate/r:SimpleDate">
                <publicationYear>
                    <xsl:value-of
                        select="substring-before(r:Citation/r:PublicationDate/r:SimpleDate, '-')"/>
                </publicationYear>
            </xsl:if>

            <!-- subject -->
            <xsl:if test="r:Coverage/r:TopicalCoverage/r:Subject">
                <subjects>
                    <xsl:for-each select="r:Coverage/r:TopicalCoverage/r:Subject">
                        <xsl:if test="./@xml:lang=$lang">
                            <subject>
                                <xsl:value-of select="."/>
                            </subject>
                        </xsl:if>
                    </xsl:for-each>

                    <xsl:if test="r:Coverage/r:TopicalCoverage/r:Keyword">
                        <xsl:for-each select="r:Coverage/r:TopicalCoverage/r:Keyword">
                            <xsl:if test="./@xml:lang=$lang">
                                <subject>
                                    <xsl:value-of select="."/>
                                </subject>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>
                </subjects>
            </xsl:if>

            <!-- dates -->
            <xsl:if
                test="r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:StartDate or r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:EndDate">
                <dates>
                    <xsl:if test="r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:StartDate">
                        <date dateType="StartDate">
                            <xsl:call-template name="getDate">
                                <xsl:with-param name="date">
                                    <xsl:value-of
                                        select="r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:StartDate"
                                    />
                                </xsl:with-param>
                            </xsl:call-template>
                        </date>
                    </xsl:if>
                    <xsl:if test="r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:StartDate">
                        <date dateType="EndDate">
                            <xsl:call-template name="getDate">
                                <xsl:with-param name="date">
                                    <xsl:value-of
                                        select="r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:EndDate"
                                    />
                                </xsl:with-param>
                            </xsl:call-template>
                        </date>
                    </xsl:if>
                </dates>
            </xsl:if>

            <!-- language -->
            <language>
                <xsl:value-of select="$resourceLang"/>
            </language>

            <!-- resource type -->
            <resourceType resourceTypeGeneral="Dataset">
                <xsl:choose>
                    <xsl:when test="s:KindOfData">
                        <xsl:variable name="resourceType">
                            <xsl:for-each select="s:KindOfData">
                                <xsl:value-of select="."/>
                                <xsl:if test="position() != last()">
                                    <xsl:text>, </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:value-of select="$resourceType"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>Dataset</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </resourceType>

            <!-- alternate identifier -->
            <xsl:variable name="callnumber" select="//a:CallNumber"/>
            <xsl:if test="$callnumber">
                <alternateIdentifiers>
                    <alternateIdentifier alternateIdentifierType="Internal">
                        <xsl:value-of select="$callnumber"/>
                    </alternateIdentifier>
                </alternateIdentifiers>
            </xsl:if>

            <!-- formats -->
            <xsl:variable name="formatList" select="tokenize($formats, ' ')"/>
            <formats>
                <xsl:for-each select="$formatList">
                    <format>
                        <xsl:value-of select="."/>
                    </format>
                </xsl:for-each>
            </formats>

            <!-- rights -->
            <xsl:if
                test="a:Archive/a:ArchiveSpecific/a:DefaultAccess/a:AccessConditions[@xml:lang=$lang]">
                <rights>
                    <xsl:value-of
                        select="a:Archive/a:ArchiveSpecific/a:DefaultAccess/a:AccessConditions[@xml:lang=$lang]"
                    />
                </rights>
            </xsl:if>

            <!-- s:Abstract, s:Purpose-->
            <xsl:if test="s:Abstract | s:Purpose">
                <descriptions>
                    <xsl:if test="s:Abstract">
                        <xsl:choose>
                            <xsl:when test="s:Abstract/r:Content[@xml:lang = $lang]">
                                <description descriptionType="Abstract">
                                    <xsl:value-of select="s:Abstract/r:Content[@xml:lang = $lang]"/>
                                </description>
                            </xsl:when>
                            <xsl:otherwise>
                                <description descriptionType="Abstract">
                                    <xsl:value-of select="s:Abstract/r:Content"/>
                                </description>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="s:Purpose">
                        <xsl:choose>
                            <xsl:when test="s:Purpose/r:Content[@xml:lang = $lang]">
                                <description descriptionType="Other">
                                    <xsl:value-of select="s:Purpose/r:Content[@xml:lang = $lang]"/>
                                </description>
                            </xsl:when>
                            <xsl:otherwise>
                                <description descriptionType="Other">
                                    <xsl:value-of select="s:Purpose/r:Content"/>
                                </description>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </descriptions>
            </xsl:if>
        </resource>
    </xsl:template>

    <!-- template to subtract a date from a datetime -->
    <!-- parameter r:SimpleDate -->
    <xsl:template name="getDate">
        <xsl:param name="date"/>
        <xsl:choose>
            <xsl:when test="contains($date, 'T')">
                <xsl:value-of select="substring-before($date, 'T')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$date"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>

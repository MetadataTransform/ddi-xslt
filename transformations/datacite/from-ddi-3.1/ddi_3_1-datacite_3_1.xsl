<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
                xmlns="http://datacite.org/schema/kernel-3"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:g="ddi:group:3_1"
                xmlns:d="ddi:datacollection:3_1"
                xmlns:dce="ddi:dcelements:3_1"
                xmlns:c="ddi:conceptualcomponent:3_1"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:a="ddi:archive:3_1"
                xmlns:m1="ddi:physicaldataproduct/ncube/normal:3_1"
                xmlns:ddi="ddi:instance:3_1  http://www.ddialliance.org/Specification/DDI-Lifecycle/3.1/XMLSchema/instance.xsd"
                xmlns:m2="ddi:physicaldataproduct/ncube/tabular:3_1"
                xmlns:l="ddi:logicalproduct:3_1"
                xmlns:m3="ddi:physicaldataproduct/ncube/inline:3_1"
                xmlns:pd="ddi:physicaldataproduct:3_1"
                xmlns:cm="ddi:comparative:3_1"
                xmlns:s="ddi:studyunit:3_1"
                xmlns:r="ddi:reusable:3_1"
                xmlns:pi="ddi:physicalinstance:3_1"
                xmlns:ds="ddi:dataset:3_1"
                xmlns:pr="ddi:profile:3_1"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://datacite.org/schema/kernel-3 http://schema.datacite.org/meta/kernel-3/metadata.xsd"
                version="2.0"
                exclude-result-prefixes="dc g d dce c xhtml a m1 ddi m2 l m3 pd cm s r pi ds pr xsl">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <!--
    Document   : ddi_3_1-datacite_3_1.xsl
    Version    : development
    Created on : 9th of December 2014
    Description: Extract metadata from DDI 3.1 to DataCite 3 metadata
    
    DOC: http://schema.datacite.org/meta/kernel-3/doc/DataCite-MetadataKernel_v3.1.pdf
    
    progress:
    id     | datacite              | ddi3.1
    =======================================
    1       +Identifier
    2       +Creator
    2.1     creatorName
    2.2     nameIdentifier
    2.2.1   nameIdentifierScheme
    3       +title
    4       publisher               r:Publisher
    5       publicationYear         r:PublicationDate
    6       +subject                r:Subject && r:Keyword
    7       contributors            r:Contributor
    8       +date                   r:StatDate && r:EndDate
    9       language                parameter
    10      resourceType            s:KindOfData
    11      alternateIdentifier     s:CallNumber
    12      relatedIdentifier       todo
    13      size                        
    14      +format                 parameter
    15      version
    16      rights                  a:AccessConditions
    17      +description            s:Abstract, s:purpose
    -->

    <!-- if the DOI is supplied as a parameter then use that rather than the one from the DDI-instance -->
    <xsl:param name="doi"/>
    
    <!-- primary language of resource -->    
    <!-- Note: DataCite use a three-letter standard -->
    <!-- Note: Subject to change in next DataCite version -->
    <xsl:param name="resourceLang">en</xsl:param>
    
    <!-- space separated string defining formats prefered in mime types -->
    <!-- usual formats: 
    application/xml;vocabulary=ddi,version=3.1 
    text/csv 
    application/x-stata 
    application/x-sas 
    application/x-spss-sav  
    application/x-R-2
    -->
    <xsl:param name="formats">application/xml;vocabulary=ddi,version=3.1</xsl:param>
    
    <xsl:template match="*">
        <xsl:apply-templates select="s:StudyUnit"/>
    </xsl:template>
    
    <xsl:template match="//s:StudyUnit">
        <resource xmlns="http://datacite.org/schema/kernel-3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://datacite.org/schema/kernel-3 http://schema.datacite.org/meta/kernel-3/metadata.xsd">
            
            <!-- 1 identifier -->
            <identifier identifierType="DOI">
                <xsl:choose>
                    <xsl:when test="$doi">
                        <xsl:value-of select="$doi"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>    
                            <xsl:when test="r:Citation/r:InternationalIdentifier[@type = 'DOI']">
                                <xsl:value-of select="r:Citation/r:InternationalIdentifier[@type = 'DOI']"/>
                            </xsl:when>
                            <xsl:when test="r:UserID[@type = 'DOI']">
                                <xsl:value-of select="r:UserID[@type = 'DOI']"/>
                            </xsl:when>
                            <xsl:when test="pi:PhysicalInstance/pi:DataFileIdentification/r:UserID[@type = 'DOI']">
                                <xsl:value-of select="r:UserID[@type = 'DOI']"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </identifier>
                                    
            <!-- 2 creators -->
            <!-- last name comes before first name(s) separated by comma ("family, given") -->
            <creators>
                 <xsl:for-each select="r:Citation/r:Creator">
                     <creator>
                         <creatorName>
                             <xsl:call-template name="formatName">
                                 <xsl:with-param name="name" select="."/>
                             </xsl:call-template>
                         </creatorName>
                     </creator>
                 </xsl:for-each>
            </creators>
            
            <!-- 3 titles -->
            <titles>
                <xsl:for-each select="r:Citation/r:Title">
                    <xsl:if test="@translated='false'">
                       <title>                            
                           <xsl:if test="@xml:lang">
                               <xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang"/></xsl:attribute>
                           </xsl:if>
                           <xsl:value-of select="."/>
                       </title>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="r:Citation/r:AlternateTitle">
                    <title titleType="AlternativeTitle">                            
                        <xsl:if test="@xml:lang">
                            <xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang"/></xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="."/>
                    </title>
                </xsl:for-each>
                <xsl:for-each select="r:Citation/r:SubTitle">
                    <title titleType="Subtitle">                            
                        <xsl:if test="@xml:lang">
                            <xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang"/></xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="."/>
                    </title>
                </xsl:for-each>
                <xsl:for-each select="r:Citation/r:Title[@translated='true']">
                    <title titleType="TranslatedTitle">                        
                        <xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang"/></xsl:attribute>
                        <xsl:value-of select="."/>
                    </title>
                </xsl:for-each>
            </titles>
            
            <!-- 4 publisher -->
            <xsl:if test="r:Citation/r:Publisher">
                <xsl:choose>
                    <xsl:when test="r:Citation/r:Publisher[@xml:lang = 'en']">
                        <publisher>
                            <xsl:value-of select="r:Citation/r:Publisher[@xml:lang = 'en']"/>
                        </publisher>
                    </xsl:when>
                    <xsl:otherwise>
                        <publisher>
                            <xsl:value-of select="r:Citation/r:Publisher"/>
                        </publisher>                      
                    </xsl:otherwise>
                </xsl:choose>                
            </xsl:if>
            
            <!-- 5 publicationYear -->
            <xsl:if test="r:Citation/r:PublicationDate/r:SimpleDate">
                <publicationYear>
                    <xsl:value-of
                        select="substring-before(r:Citation/r:PublicationDate/r:SimpleDate, '-')"/>
                </publicationYear>
            </xsl:if>      
            
            <!-- 6 subjects -->
            <xsl:if test="r:Coverage/r:TopicalCoverage/child::*">
                <subjects>
                    <xsl:for-each select="r:Coverage/r:TopicalCoverage/r:UserID">             
                        <subject>
                            <xsl:if test="@type">
                                <xsl:attribute name="subjectScheme"><xsl:value-of select="@type"/></xsl:attribute>
                            </xsl:if>                            
                            <xsl:value-of select="."/>
                        </subject>
                    </xsl:for-each>                    
                    <xsl:for-each select="r:Coverage/r:TopicalCoverage/r:Subject">
                        <subject>
                            <xsl:if test="@codeListID">
                                <xsl:attribute name="subjectScheme"><xsl:value-of select="@codeListID"/></xsl:attribute>
                            </xsl:if>
                            <xsl:if test="@xml:lang">
                                <xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang"/></xsl:attribute>
                            </xsl:if> 
                            <xsl:value-of select="."/>
                        </subject>
                    </xsl:for-each>
                    <xsl:for-each select="r:Coverage/r:TopicalCoverage/r:Keyword">
                        <subject>
                            <xsl:if test="@codeListID">
                                <xsl:attribute name="subjectScheme"><xsl:value-of select="@codeListID"/></xsl:attribute>
                            </xsl:if>
                            <xsl:if test="@xml:lang">
                                <xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang"/></xsl:attribute>
                            </xsl:if>                                    
                            <xsl:value-of select="."/>
                        </subject>
                    </xsl:for-each>
                </subjects>
            </xsl:if>
            
            <!-- 7 contributors -->
            <xsl:if test="r:Citation/r:Contributor">
                <contributors>
                    <xsl:for-each select="r:Citation/r:Contributor">
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
            
            <!-- 8 dates -->
            <xsl:call-template name="lifecycleEvent"/>
  
            <!-- 9 language -->
            <!-- Note: DataCite only allows three-letter language codes -->
            <xsl:if test="$resourceLang or string-length(r:Citation/r:Language) = 3">
                <language>
                    <xsl:choose>
                        <xsl:when test="$resourceLang">
                            <xsl:value-of select="$resourceLang"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="r:Citation/r:Language"/>
                        </xsl:otherwise>                        
                    </xsl:choose>
                </language>
            </xsl:if>
            
            <!-- 10 resourceType -->
            <!-- Note: DataCite uses controlled vocabulary for attribute-->
            <!-- Note: Use KindOfData instead of suggested dc:type -->
            <xsl:if test="s:KindOfData">
                <resourceType>
                    <xsl:choose>
                        <xsl:when test="s:KindOfData = 'Collection' or 
                                        s:KindOfData = 'Dataset' or 
                                        s:KindOfData = 'Event' or 
                                        s:KindOfData = 'Film' or 
                                        s:KindOfData = 'Image' or 
                                        s:KindOfData = 'InteractiveResource' or 
                                        s:KindOfData = 'Model' or 
                                        s:KindOfData = 'PhysicalObject' or 
                                        s:KindOfData = 'Service' or 
                                        s:KindOfData = 'Software' or 
                                        s:KindOfData = 'Sound' or 
                                        s:KindOfData = 'Text'">                
                            <xsl:attribute name="resourceTypeGeneral">
                                <xsl:value-of select="s:KindOfData"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="resourceTypeGeneral">
                                <xsl:text>Dataset</xsl:text>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
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
            </xsl:if>
            
            <!-- 11 alternateIdentifiers -->
            <xsl:if test="r:UserID[@type != 'DOI'] | r:Citation/r:InternationalIdentifier[@type != 'DOI'] | 
                          a:Archive/a:ArchiveSpecific/a:Collection/a:CallNumber | a:Archive/a:ArchiveSpecific/a:Item/a:CallNumber">
                <alternateIdentifiers>
                    <xsl:for-each select="r:UserID[@type != 'DOI']">
                        <alternateIdentifier>
                            <xsl:attribute name="alternateIdentifierType"><xsl:value-of select="@type"/></xsl:attribute>
                            <xsl:value-of select="."/>                            
                        </alternateIdentifier>
                    </xsl:for-each>
                    <xsl:for-each select="r:Citation/r:InternationalIdentifier[@type != 'DOI']">
                        <alternateIdentifier>
                            <xsl:attribute name="alternateIdentifierType"><xsl:value-of select="@type"/></xsl:attribute>
                            <xsl:value-of select="."/>                            
                        </alternateIdentifier>
                    </xsl:for-each>
                    <xsl:choose>
                        <xsl:when test="a:Archive/a:ArchiveSpecific/a:Collection/a:CallNumber">
                            <alternateIdentifier alternateIdentifierType="Internal">                            
                                <xsl:value-of select="a:Archive/a:ArchiveSpecific/a:Collection/a:CallNumber"/>                            
                            </alternateIdentifier>
                        </xsl:when>
                        <xsl:when test="a:Archive/a:ArchiveSpecific/a:Item/a:CallNumber">
                            <alternateIdentifier alternateIdentifierType="Internal">                            
                                <xsl:value-of select="a:Archive/a:ArchiveSpecific/a:Item/a:CallNumber"/>                            
                            </alternateIdentifier>
                        </xsl:when>
                    </xsl:choose>
                </alternateIdentifiers>                
            </xsl:if>
            
            <!-- 12 relatedIdentifiers -->
            <!-- todo -->
            
            <!-- 13 size -->
            <xsl:if test="a:Archive/a:ArchiveSpecific/a:Collection/a:ItemQuantity | a:Archive/a:ArchiveSpecific/a:Item/a:DataFileQuantity |
                          pi:PhysicalInstance/pi:GrossFileStructure/pi:CaseQuantity">
                <sizes>
                    <xsl:choose>      
                        <xsl:when test="a:Archive/a:ArchiveSpecific/a:Collection/a:ItemQuantity">
                            <size><xsl:value-of select="a:Archive/a:ArchiveSpecific/a:Collection/a:ItemQuantity"/> data files</size>
                        </xsl:when>
                        <xsl:when test="a:Archive/a:ArchiveSpecific/a:Item/a:DataFileQuantity">
                            <size><xsl:value-of select="a:Archive/a:ArchiveSpecific/a:Item/a:DataFileQuantity"/> data files</size>
                        </xsl:when>
                    </xsl:choose> 
                    <xsl:if test="pi:PhysicalInstance/pi:GrossFileStructure/pi:CaseQuantity">
                        <size><xsl:value-of select="pi:PhysicalInstance/pi:GrossFileStructure/pi:CaseQuantity"/> cases</size>
                    </xsl:if>
                </sizes>
            </xsl:if>
        
            <!-- 14 format -->
            <xsl:call-template name="formats"/>            
            
            <!-- 15 version -->
            <!-- Note: mapped by DataCite to pi:PhysicalInstance/@version -->
            <xsl:choose>
            <!--<xsl:when test="pi:PhysicalInstance/@version">
                    <version><xsl:value-of select="pi:PhysicalInstance/@version"/></version>
                </xsl:when>-->
                <xsl:when test="@version">
                    <version><xsl:value-of select="@version"/></version>
                </xsl:when>
            </xsl:choose>
        
            <!-- 16 rights -->
            <!-- Field maps to dc:rights -->
            <!--<xsl:if
                test="a:Archive/a:ArchiveSpecific/a:DefaultAccess/a:AccessConditions[@xml:lang=$lang]">
                <rights>
                    <xsl:value-of
                        select="a:Archive/a:ArchiveSpecific/a:DefaultAccess/a:AccessConditions[@xml:lang=$lang]"
                    />
                </rights>
            </xsl:if>-->
            <xsl:if test="r:Citation/r:Copyright">
                <rights><xsl:value-of select="r:Citation/r:Copyright"/></rights>
            </xsl:if>        
            
            <!-- 17 descriptions -->
            <xsl:if test="s:Abstract | s:Purpose | r:SeriesStatement/r:SeriesDescription">
                <descriptions>
                    <xsl:for-each select="s:Abstract">
                        <description descriptionType="Abstract">
                            <xsl:if test="r:Content/@xml:lang">
                                <xsl:attribute name="xml:lang"><xsl:value-of select="r:Content/@xml:lang"/></xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="r:Content"/>
                        </description>
                    </xsl:for-each>
                    <xsl:for-each select="s:Purpose">
                        <description descriptionType="Other">
                            <xsl:if test="r:Content/@xml:lang">
                                <xsl:attribute name="xml:lang"><xsl:value-of select="r:Content/@xml:lang"/></xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="r:Content"/>
                        </description>
                    </xsl:for-each>
                    <xsl:for-each select="r:SeriesStatement/r:SeriesDescription">
                        <description descriptionType="SeriesInformation">
                            <xsl:if test="@xml:lang">
                                <xsl:attribute name="xml:lang"><xsl:value-of select="r:Content/@xml:lang"/></xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="."/>
                        </description>
                    </xsl:for-each>
                </descriptions>
            </xsl:if>
        </resource>
    </xsl:template>    
    
    <xsl:template name="formats">
        <!--xsl:variable name="formatList" select="tokenize($formats, ' ')"/>
        <formats>
            <xsl:for-each select="$formatList">
                <format>
                    <xsl:value-of select="."/>
                </format>
            </xsl:for-each>
        </formats-->
        <xsl:if test="a:Archive/a:ArchiveSpecific/a:Item/a:Format | pd:PhysicalDataProduct/pd:PhysicalStructureScheme/pd:PhysicalStructure/pd:Format">
            <formats>
                <xsl:if test="a:Archive/a:ArchiveSpecific/a:Item/a:Format">
                    <format><xsl:value-of select="a:Archive/a:ArchiveSpecific/a:Item/a:Format"/></format>
                </xsl:if>
                <xsl:if test="pd:PhysicalDataProduct/pd:PhysicalStructureScheme/pd:PhysicalStructure/pd:Format">
                    <format><xsl:value-of select="pd:PhysicalDataProduct/pd:PhysicalStructureScheme/pd:PhysicalStructure/pd:Format"/></format>
                </xsl:if>
            </formats>                
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="lifecycleEvent">        
        <xsl:if test="a:Archive/r:LifecycleInformation/r:LifecycleEvent[r:EventType = 'OriginalRelease']/r:Date/r:SimpleDate |
            a:Archive/r:LifecycleInformation/r:LifecycleEvent[r:EventType = 'Deposit']/r:Date/r:SimpleDate |
            a:Archive/r:LifecycleInformation/r:LifecycleEvent[r:EventType = 'NewVersionRelease']/r:Date/r:SimpleDate |
            r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:StartDate |
            r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:EndDate">
            <dates>                
                <xsl:call-template name="temporalCoverage"/>
                <xsl:if test="a:Archive/r:LifecycleInformation/r:LifecycleEvent[r:EventType = 'OriginalRelease']/r:Date/r:SimpleDate">
                    <date dateType="Available"><xsl:value-of select="a:Archive/r:LifecycleInformation/r:LifecycleEvent[r:EventType = 'OriginalRelease']/r:Date/r:SimpleDate"/></date>
                </xsl:if>  
                <xsl:if test="a:Archive/r:LifecycleInformation/r:LifecycleEvent[r:EventType = 'Deposit']/r:Date/r:SimpleDate">
                    <date dateType="Accepted"><xsl:value-of select="a:Archive/r:LifecycleInformation/r:LifecycleEvent[r:EventType = 'Deposit']/r:Date/r:SimpleDate"/></date>
                </xsl:if>  
                <xsl:for-each select="a:Archive/r:LifecycleInformation/r:LifecycleEvent[r:EventType = 'NewVersionRelease']/r:Date/r:SimpleDate"> 
                    <xsl:sort select="." order="descending" /> 
                    <xsl:if test="position() = 1">
                        <date dateType="Updated"><xsl:value-of select="."/></date>
                    </xsl:if>
                </xsl:for-each>
            </dates>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="temporalCoverage">
       <xsl:if test="r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:StartDate or r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:EndDate">
           <xsl:variable name="startdate">
               <xsl:if test="r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:StartDate">
                   <xsl:call-template name="getDate">
                       <xsl:with-param name="date">
                           <xsl:value-of
                               select="r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:StartDate"
                           />
                       </xsl:with-param>
                   </xsl:call-template>
               </xsl:if>
           </xsl:variable>
           <xsl:variable name="enddate">
               <xsl:if test="r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:StartDate">
                   <xsl:call-template name="getDate">
                       <xsl:with-param name="date">
                           <xsl:value-of
                               select="r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:EndDate"
                           />
                       </xsl:with-param>
                   </xsl:call-template>                        
               </xsl:if>
           </xsl:variable>
           <xsl:choose>
               <xsl:when test="$enddate!=''">
                   <date dateType="Collected">
                       <xsl:value-of select="$startdate"/>
                       <xsl:text>/</xsl:text>
                       <xsl:value-of select="$enddate"/>
                   </date>    
               </xsl:when>
               <xsl:when test="$startdate!=''">
                   <date dateType="Collected">
                       <xsl:value-of select="$startdate"/>
                   </date>
               </xsl:when>
           </xsl:choose>
       </xsl:if>        
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
	
	<!--
    Formats a name to family, given format. If name is an organization or
    contains any comma, no formatting is applied apart from normalize-space.
    -->   
    <xsl:template name="formatName">
        <xsl:param name="name" />
        <xsl:variable name="normalized" select="normalize-space($name)"/>
        
        <xsl:choose>
            <xsl:when test="//a:Organization[a:OrganizationName = $name]">
                <!-- name is an organization, don't do any formatting -->
                <xsl:value-of select="$normalized"/>
            </xsl:when> 
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
    
</xsl:stylesheet>

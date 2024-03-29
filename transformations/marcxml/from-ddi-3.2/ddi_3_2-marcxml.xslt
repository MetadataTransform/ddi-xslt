<!--

Description:
XSLT Stylesheet for conversion between DDI-L version 3.2 and MARC-XML

Author: Johan Fihn <johan.fihn@snd.gu.se>
Version: March 2013

License: Copyright (C) 2013 Johan Fihn

This file is free software: you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation, either
version 3 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library.  If not, see <http://www.gnu.org/licenses/>.

-->
<xsl:stylesheet xmlns:a="ddi:archive:3_2" xmlns:pr="ddi:profile:3_2" xmlns:c="ddi:conceptualcomponent:3_2" xmlns:d="ddi:datacollection:3_2" xmlns:m1="ddi:physicaldataproduct/ncube/normal:3_2" xmlns:m2="ddi:physicaldataproduct/ncube/tabular:3_2" xmlns:m3="ddi:physicaldataproduct/ncube/inline:3_2" xmlns:g="ddi:group:3_2" xmlns:ddi="ddi:instance:3_2" xmlns:cm="ddi:comparative:3_2" xmlns:l="ddi:logicalproduct:3_2" xmlns:ds="ddi:dataset:3_2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:exslt="http://exslt.org/dates-and-times" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dc2="ddi:dcelements:3_2" xmlns:r="ddi:reusable:3_2" xmlns:s="ddi:studyunit:3_2" xmlns:pd="ddi:physicaldataproduct:3_2" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:pi="ddi:physicalinstance:3_2" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:meta="transformation:metadata" version="2.0" xsi:schemaLocation="ddi:instance:3_2 http://www.ddialliance.org/sites/default/files/schema/ddi3.2/instance.xsd http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd" extension-element-prefixes="exslt" exclude-result-prefixes="xsl xhtml marc dc dc2 g d c a m1 m2 m3 ddi l pd cm s r pi ds pr">
    <meta:metadata>
        <identifier>ddi-3.2-to-marc-xml</identifier>
        <title>DDI 3.2 to MARC-XML</title>
        <description>Convert DDI Lifecycle (3.2) to MARC-XML</description>
        <outputFormat>XML</outputFormat>
        <parameters>
            <parameter name="lang" format="xs:string" description="Language (xml:lang) to look for"/>
            <parameter name="fallback-lang" format="xs:string" description="Language (xml:lang) for fallback"/>
            <parameter name="doi_address" format="xs:string" description="Base url for DOI resolver"/>
        </parameters>
    </meta:metadata>
    <xsl:output method="xml" encoding="iso-8859-1" indent="yes"/>

    <!-- render text-elements of this language-->
    <xsl:param name="lang">sv</xsl:param>
    <!-- if the requested language is not found for e.g. questionText, use fallback language-->
    <xsl:param name="fallback-lang">en</xsl:param>
    <xsl:variable name="doi_address">https://doi.org/</xsl:variable>
    <xsl:template match="ddi:DDIInstance">
        <xsl:text>
            
        </xsl:text>
        <xsl:comment>		  
            Automatically generated file from a DDI-L version 3.2 XML input file using the ddi3tomarc 
            xslt stylesheet for transformation by the Swedish National Data Service	
        </xsl:comment>
        <xsl:text>
            
        </xsl:text>
        <collection xmlns="http://www.loc.gov/MARC21/slim" xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">
            <xsl:apply-templates select="s:StudyUnit"/>
        </collection>
    </xsl:template>
    <xsl:template match="s:StudyUnit">
        <record xmlns="http://www.loc.gov/MARC21/slim">
            
            <!-- Default leader -->
            <leader>
                <xsl:text>00000cmm a2200000   4500</xsl:text>
            </leader>
		
            <!-- 001: CallNumber -->
            <xsl:if test="a:Archive/a:ArchiveSpecific/a:Collection/a:CallNumber">
                <controlfield tag="001">
                    <xsl:value-of select="normalize-space(a:Archive/a:ArchiveSpecific/a:Collection/a:CallNumber)"/>
                </controlfield>
            </xsl:if>      
                   
            <!-- 005: Version date -->
            <xsl:if test="@versionDate">
                <controlfield tag="005">
                    <xsl:choose>
                        <xsl:when test="contains(@versionDate, 'T')">
                            <xsl:value-of select="substring-before(translate(@versionDate, '-', ''), 'T')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="translate(@versionDate, '-', '')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </controlfield>
            </xsl:if>
                     
            <!-- 007 -->
            <controlfield tag="007">c| |||||||||||</controlfield>
                      
            <!-- 008 -->
            <controlfield tag="008">
                <!-- 00-05 - Date entered on file -->
                <xsl:variable name="currenttime" select="current-dateTime()" as="xs:dateTime"/>
                <xsl:value-of select="substring(format-dateTime($currenttime,'[Y]'), 3, 2)"/>
                <xsl:value-of select="format-number(number(format-dateTime($currenttime,'[M]')), '00')"/>
                <xsl:value-of select="format-number(number(format-dateTime($currenttime,'[D]')), '00')"/>

                <!-- 06, 07-14 - Type of date/Publication status, Date 1, Date 2 -->
                <xsl:choose>
                    <xsl:when test="r:Citation/r:PublicationDate/r:SimpleDate | r:Citation/r:PublicationDate/r:StartDate">
                        <xsl:text>e</xsl:text>
                        <xsl:choose>
                            <xsl:when test="r:Citation/r:PublicationDate/r:SimpleDate">
                                <xsl:value-of select="substring(translate(r:Citation/r:PublicationDate/r:SimpleDate, '-', ''), 1, 4)"/>
                            </xsl:when>
                            <xsl:when test="r:Citation/r:PublicationDate/r:StartDate">
                                <xsl:value-of select="substring(translate(r:Citation/r:PublicationDate/r:StartDate, '-', ''), 1, 4)"/>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="r:Citation/r:PublicationDate/r:EndDate">
                                <xsl:value-of select="substring(translate(r:Citation/r:PublicationDate/r:EndDate, '-', ''), 1, 4)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>    </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>b        </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                
                <!-- 15-17 - Place of publication, production, or execution -->
                <xsl:text>|||</xsl:text>
                
                <!-- 18-34 - Material specific coded elements -->
                <!-- 18-21 - Undefined -->
                <xsl:text>    </xsl:text>
                
                <!-- 22 - Target audience -->
                <xsl:text>|</xsl:text>
                
                <!-- 23 - Form of item -->
                <xsl:text>|</xsl:text>
                
                <!-- 24-25 - Undefined -->
                <xsl:text>  </xsl:text>
                
                <!-- 26 - Type of computer file -->
                <xsl:text>|</xsl:text>
                
                <!-- 27 - Undefined -->
                <xsl:text> </xsl:text>
                
                <!-- 28 - Government publication -->
                <xsl:text>|</xsl:text>
                
                <!-- 29-34 - Undefined -->
                <xsl:text>      </xsl:text>
                
                <!-- 35-37 - Language -->
                <!-- Note: Coded in 041 -->
                <xsl:text>|||</xsl:text>
                
                <!-- 38 - Modified record -->
                <xsl:text>|</xsl:text>
                
                <!-- 39 - Cataloging source -->
                <xsl:text>|</xsl:text>
            </controlfield>
            <xsl:for-each select="r:Citation/r:InternationalIdentifier">
                <xsl:choose>
                    <!-- 010: LCCN -->
                    <xsl:when test="@type='LCCN'">
                        <datafield ind1=" " ind2=" " tag="010">
                            <subfield code="a">
                                <xsl:value-of select="normalize-space(.)"/>
                            </subfield>
                        </datafield>
                    </xsl:when> 

                    <!-- 020: ISBN -->
                    <xsl:when test="@type='ISBN'">
                        <datafield ind1=" " ind2=" " tag="020">
                            <subfield code="a">
                                <xsl:value-of select="normalize-space(.)"/>
                            </subfield>
                        </datafield>
                    </xsl:when> 

                    <!-- 022: ISSN -->
                    <xsl:when test="@type='ISSN'">
                        <datafield ind1=" " ind2=" " tag="022">
                            <subfield code="a">
                                <xsl:value-of select="normalize-space(.)"/>
                            </subfield>
                        </datafield>
                    </xsl:when> 

                    <!-- 024: Other Standard Identifier -->
                    <xsl:otherwise>
                        <datafield ind1="7" ind2=" " tag="024">
                            <subfield code="a">
                                <xsl:value-of select="normalize-space(.)"/>
                            </subfield>
                            <subfield code="2">
                                <xsl:value-of select="normalize-space(@type)"/>
                            </subfield>
                        </datafield>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
                        
            <!-- 034: BoundingBox -->
            <xsl:if test="r:Coverage/r:SpatialCoverage/r:BoundingBox">
                <datafield ind1="0" ind2=" " tag="034">
                    <subfield code="d">
                        <xsl:value-of select="normalize-space(r:Coverage/r:SpatialCoverage/r:BoundingBox/r:WestLongitude)"/>
                    </subfield>
                    <subfield code="e">
                        <xsl:value-of select="normalize-space(r:Coverage/r:SpatialCoverage/r:BoundingBox/r:EastLongitude)"/>
                    </subfield>
                    <subfield code="f">
                        <xsl:value-of select="normalize-space(r:Coverage/r:SpatialCoverage/r:BoundingBox/r:NorthLatitude)"/>
                    </subfield>
                    <subfield code="g">
                        <xsl:value-of select="normalize-space(r:Coverage/r:SpatialCoverage/r:BoundingBox/r:SouthLatitude)"/>
                    </subfield>
                </datafield>
            </xsl:if>
            
            <!-- 041: Language -->
            <xsl:if test="r:Citation/r:Language">
                <datafield ind1=" " ind2="7" tag="041">
                    <subfield code="a">
                        <xsl:value-of select="r:Citation/r:Language"/>
                    </subfield>
                    <subfield code="2">ISO 639-1</subfield>
                </datafield>
            </xsl:if>
                    
            <!-- 045: TemporalCoverage -->
            <xsl:if test="r:Coverage/r:TemporalCoverage/r:ReferenceDate">
                <datafield ind2=" " tag="045">
                    <xsl:choose>
                        <xsl:when test="r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:SimpleDate">
                            <xsl:choose>
                                <xsl:when test="count(r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:SimpleDate) &gt; 0">
                                    <xsl:attribute name="ind1">1</xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="ind1">0</xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:for-each select="r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:SimpleDate">
                                <subfield code="b">
                                    <xsl:text>d</xsl:text>
                                    <xsl:choose>
                                        <xsl:when test="contains(., 'T')">
                                            <xsl:value-of select="substring-before(translate(., '-', ''), 'T')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="translate(., '-', '')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </subfield>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="ind1">2</xsl:attribute>
                            <subfield code="b">
                                <xsl:text>d</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="contains(r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:StartDate, 'T')">
                                        <xsl:value-of select="substring-before(translate(r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:StartDate, '-', ''), 'T')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="translate(r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:StartDate, '-', '')"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </subfield>
                            <xsl:if test="r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:EndDate">
                                <subfield code="b">
                                    <xsl:text>d</xsl:text>
                                    <xsl:choose>
                                        <xsl:when test="contains(r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:EndDate, 'T')">
                                            <xsl:value-of select="substring-before(translate(r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:EndDate, '-', ''), 'T')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="translate(r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:EndDate, '-', '')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </subfield>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </datafield>
            </xsl:if>
                    
            <!-- 245: Title, SubTitle -->
            <xsl:if test="r:Citation/r:Title">
                <datafield ind1="0" ind2="0" tag="245">
                    <subfield code="a">
                        <xsl:choose>
                            <xsl:when test="r:Citation/r:Title/@xml:lang=$lang">
                                <xsl:value-of select="normalize-space(r:Citation/r:Title[@xml:lang=$lang])"/>
                            </xsl:when>
                            <xsl:when test="r:Citation/r:Title/@xml:lang=$fallback-lang">
                                <xsl:value-of select="normalize-space(r:Citation/r:Title[@xml:lang=$fallback-lang])"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(r:Citation/r:Title)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </subfield>
                    <xsl:if test="r:Citation/r:SubTitle">
                        <subfield code="b">
                            <xsl:choose>
                                <xsl:when test="r:Citation/r:SubTitle/@xml:lang=$lang">
                                    <xsl:value-of select="normalize-space(r:Citation/r:SubTitle[@xml:lang=$lang])"/>
                                </xsl:when>
                                <xsl:when test="r:Citation/r:SubTitle/@xml:lang=$fallback-lang">
                                    <xsl:value-of select="normalize-space(r:Citation/r:SubTitle[@xml:lang=$fallback-lang])"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(r:Citation/r:SubTitle)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </subfield>
                    </xsl:if>
                </datafield>
            </xsl:if>
			
            <!-- 246: AlternateTitle -->
            <xsl:if test="r:Citation/r:AlternateTitle">
                <datafield ind1="0" ind2="1" tag="246">
                    <subfield code="a">
                        <xsl:choose>
                            <xsl:when test="r:Citation/r:AlternateTitle/@xml:lang=$lang">
                                <xsl:value-of select="normalize-space(r:Citation/r:AlternateTitle[@xml:lang=$lang])"/>
                            </xsl:when>
                            <xsl:when test="r:Citation/r:AlternateTitle/@xml:lang=$fallback-lang">
                                <xsl:value-of select="normalize-space(r:Citation/r:AlternateTitle[@xml:lang=$fallback-lang])"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(r:Citation/r:AlternateTitle)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </subfield>
                </datafield>
            </xsl:if>
                  
            <!-- 260: Publisher -->
            <!-- Use 264 if distributor or other contributors are added -->
            <xsl:if test="r:Citation/r:Publisher">
                <datafield ind1=" " ind2=" " tag="260">
                    <xsl:choose>
                        <xsl:when test="r:Citation/r:Publisher[@xml:lang=$lang]">
                            <xsl:apply-templates select="r:Citation/r:Publisher[@xml:lang=$lang]"/>
                        </xsl:when>
                        <xsl:when test="r:Citation/r:Publisher[@xml:lang=$fallback-lang]">
                            <xsl:apply-templates select="r:Citation/r:Publisher[@xml:lang=$fallback-lang]"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="r:Citation/r:Publisher"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="r:Citation/r:PublicationDate">
                        <subfield code="c">
                            <xsl:choose>
                                <xsl:when test="r:Citation/r:PublicationDate/r:SimpleDate">
                                    <xsl:choose>
                                        <xsl:when test="contains(r:Citation/r:PublicationDate/r:SimpleDate, 'T')">
                                            <xsl:value-of select="substring-before(translate(r:Citation/r:PublicationDate/r:SimpleDate, '-', ''), 'T')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="translate(r:Citation/r:PublicationDate/r:SimpleDate, '-', '')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:when test="r:Citation/r:PublicationDate/r:StartDate">
                                    <xsl:variable name="pub_date">
                                        <xsl:choose>
                                            <xsl:when test="contains(r:Citation/r:PublicationDate/r:StartDate, 'T')">
                                                <xsl:value-of select="substring-before(translate(r:Citation/r:PublicationDate/r:StartDate, '-', ''), 'T')"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="translate(r:Citation/r:PublicationDate/r:StartDate, '-', '')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <xsl:if test="r:Citation/r:PublicationDate/r:EndDate">
                                        <xsl:choose>
                                            <xsl:when test="contains(r:Citation/r:PublicationDate/r:EndDate, 'T')">
                                                <xsl:value-of select="concat($pub_date, ' - ', substring-before(translate(r:Citation/r:PublicationDate/r:EndDate, '-', ''), 'T'))"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="concat($pub_date, ' - ', translate(r:Citation/r:PublicationDate/r:EndDate, '-', ''))"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                    <xsl:value-of select="$pub_date"/>
                                </xsl:when>
                            </xsl:choose>
                        </subfield>
                    </xsl:if>
                </datafield>
            </xsl:if>
            
            <!-- 490: Series -->
            <xsl:apply-templates select="r:SeriesStatement"/>

            
            
            <!-- 506: AvailabilityStatus -->
            <xsl:if test="a:Archive/a:ArchiveSpecific/a:Collection/a:AvailabilityStatus">
                <datafield tag="506" ind1=" " ind2=" ">
                    <subfield code="a">
                        <xsl:choose>
                            <xsl:when test="a:Archive/a:ArchiveSpecific/a:Collection/a:AvailabilityStatus[@xml:lang=$lang]">
                                <xsl:value-of select="normalize-space(a:Archive/a:ArchiveSpecific/a:Collection/a:AvailabilityStatus[@xml:lang=$lang])"/>
                            </xsl:when>
                            <xsl:when test="a:Archive/a:ArchiveSpecific/a:Collection/a:AvailabilityStatus[@xml:lang=$fallback-lang]">
                                <xsl:value-of select="normalize-space(a:Archive/a:ArchiveSpecific/a:Collection/a:AvailabilityStatus[@xml:lang=$fallback-lang])"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(a:Archive/a:ArchiveSpecific/a:Collection/a:AvailabilityStatus)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </subfield>
                </datafield>
            </xsl:if>
        
            <!-- 520: Abstract -->
            <xsl:if test="s:Abstract/r:Content">
                <datafield ind1="3" ind2=" " tag="520">
                    <subfield code="a">
                        <xsl:choose>
                            <xsl:when test="s:Abstract/r:Content[@xml:lang=$lang]">
                                <xsl:value-of select="normalize-space(s:Abstract/r:Content[@xml:lang=$lang])"/>
                            </xsl:when>
                            <xsl:when test="s:Abstract/r:Content[@xml:lang=$fallback-lang]">
                                <xsl:value-of select="normalize-space(s:Abstract/r:Content[@xml:lang=$fallback-lang])"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(s:Abstract/r:Content[1])"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </subfield>
                </datafield>
            </xsl:if>
            
            <!-- 522: Geographic Coverage Note -->
            <xsl:if test="r:Coverage/r:SpatialCoverage/r:Description">
                <datafield ind1=" " ind2=" " tag="522">
                    <subfield code="a">
                        <xsl:choose>
                            <xsl:when test="r:Coverage/r:SpatialCoverage/r:Description[@xml:lang=$lang]">
                                <xsl:value-of select="normalize-space(r:Coverage/r:SpatialCoverage/r:Description[@xml:lang=$lang])"/>
                            </xsl:when>
                            <xsl:when test="r:Coverage/r:SpatialCoverage/r:Description[@xml:lang=$fallback-lang]">
                                <xsl:value-of select="normalize-space(r:Coverage/r:SpatialCoverage/r:Description[@xml:lang=$fallback-lang])"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(r:Coverage/r:SpatialCoverage/r:Description)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </subfield>
                </datafield>
            </xsl:if>
            
            <!-- 542: Copyright -->
            <xsl:if test="r:Citation/r:Copyright">
                <datafield ind1=" " ind2=" " tag="542">
                    <subfield code="f">
                        <xsl:choose>
                            <xsl:when test="r:Citation/r:Copyright[@xml:lang=$lang]">
                                <xsl:value-of select="normalize-space(r:Citation/r:Copyright[@xml:lang=$lang])"/>
                            </xsl:when>
                            <xsl:when test="r:Citation/r:Copyright[@xml:lang=$fallback-lang]">
                                <xsl:value-of select="normalize-space(r:Citation/r:Copyright[@xml:lang=$fallback-lang])"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(r:Citation/r:Copyright)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </subfield>
                </datafield>
            </xsl:if>
            
            <!-- 650: Subject -->
            <xsl:choose>
                <xsl:when test="r:Coverage/r:TopicalCoverage/r:Subject[@xml:lang=$lang]">
                    <xsl:apply-templates select="r:Coverage/r:TopicalCoverage/r:Subject[@xml:lang=$lang]"/>
                </xsl:when>
                <xsl:when test="r:Coverage/r:TopicalCoverage/r:Subject[@xml:lang=$fallback-lang]">
                    <xsl:apply-templates select="r:Coverage/r:TopicalCoverage/r:Subject[@xml:lang=$fallback-lang]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="r:Coverage/r:TopicalCoverage/r:Subject"/>
                </xsl:otherwise>
            </xsl:choose>             

            <!-- 650: Keyword -->
            <xsl:choose>
                <xsl:when test="r:Coverage/r:TopicalCoverage/r:Keyword[@xml:lang=$lang]">
                    <xsl:apply-templates select="r:Coverage/r:TopicalCoverage/r:Keyword[@xml:lang=$lang]"/>
                </xsl:when>
                <xsl:when test="r:Coverage/r:TopicalCoverage/r:Keyword[@xml:lang=$fallback-lang]">
                    <xsl:apply-templates select="r:Coverage/r:TopicalCoverage/r:Keyword[@xml:lang=$fallback-lang]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="r:Coverage/r:TopicalCoverage/r:Keyword"/>
                </xsl:otherwise>
            </xsl:choose>         
            
            <!-- 720: Creator -->
            <!-- Use 720 as DDI-L doesn't distinguish between a person and an organization -->
            <xsl:choose>
                <xsl:when test="r:Citation/r:Creator[@xml:lang=$lang]">
                    <xsl:apply-templates select="r:Citation/r:Creator[@xml:lang=$lang]"/>
                </xsl:when>
                <xsl:when test="r:Citation/r:Creator[@xml:lang=$fallback-lang]">
                    <xsl:apply-templates select="r:Citation/r:Creator[@xml:lang=$fallback-lang]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="r:Citation/r:Creator"/>
                </xsl:otherwise>
            </xsl:choose>
            
            <!-- 850: ArchiveOrganization -->
            <xsl:if test="a:Archive/a:ArchiveSpecific/a:ArchiveOrganizationReference/r:ID">
                <xsl:variable name="archiveID" select="normalize-space(a:Archive/a:ArchiveSpecific/a:ArchiveOrganizationReference/r:ID)"/>
                <xsl:if test="a:Archive/a:OrganizationScheme/a:Organization[@id=$archiveID]">
                    <datafield ind1=" " ind2=" " tag="850">
                        <subfield code="a">
                            <xsl:choose>
                                <xsl:when test="a:Archive/a:OrganizationScheme/a:Organization[@id=$archiveID]/a:OrganizationName[@xml:lang=$lang]">
                                    <xsl:value-of select="normalize-space(a:Archive/a:OrganizationScheme/a:Organization[@id=$archiveID]/a:OrganizationName[@xml:lang=$lang])"/>
                                </xsl:when>
                                <xsl:when test="a:Archive/a:OrganizationScheme/a:Organization[@id=$archiveID]/a:OrganizationName[@xml:lang=$fallback-lang]">
                                    <xsl:value-of select="normalize-space(a:Archive/a:OrganizationScheme/a:Organization[@id=$archiveID]/a:OrganizationName[@xml:lang=$fallback-lang])"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(a:Archive/a:OrganizationScheme/a:Organization[@id=$archiveID]/a:OrganizationName)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </subfield>
                    </datafield>
                </xsl:if>
            </xsl:if>         
            
            <!-- 856: DOI, URI -->
            <xsl:if test="r:Citation/r:InternationalIdentifier[@type = 'DOI'] |                           r:UserID[@type = 'DOI'] |                           a:Archive/a:ArchiveSpecific/a:Collection/a:URI |                            a:Archive/a:ArchiveSpecific/a:Item/a:URI">
                <datafield ind1="4" ind2="0" tag="856">
                    <subfield code="u">
                        <xsl:choose>
                            <xsl:when test="r:Citation/r:InternationalIdentifier[@type = 'DOI']">
                                <xsl:choose>
                                    <xsl:when test="contains(r:Citation/r:InternationalIdentifier[@type = 'DOI'], $doi_address)">
                                        <xsl:value-of select="normalize-space(r:Citation/r:InternationalIdentifier[@type = 'DOI'])"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat($doi_address, normalize-space(r:Citation/r:InternationalIdentifier[@type = 'DOI']))"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="r:UserID[@type = 'DOI']">
                                <xsl:choose>
                                    <xsl:when test="contains(r:UserID[@type = 'DOI'], $doi_address)">
                                        <xsl:value-of select="normalize-space(r:UserID[@type = 'DOI'])"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat($doi_address, normalize-space(r:UserID[@type = 'DOI']))"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="a:Archive/a:ArchiveSpecific/a:Collection/a:URI">
                                <xsl:value-of select="normalize-space(a:Archive/a:ArchiveSpecific/a:Collection/a:URI)"/>
                            </xsl:when>
                            <xsl:when test="a:Archive/a:ArchiveSpecific/a:Item/a:URI">
                                <xsl:value-of select="normalize-space(a:Archive/a:ArchiveSpecific/a:Item/a:URI)"/>
                            </xsl:when>
                        </xsl:choose>
                    </subfield>
                </datafield>
            </xsl:if>
        </record>
    </xsl:template>
    <xsl:template match="r:SeriesStatement">
        <datafield ind1="0" ind2=" " tag="490">
            <subfield code="a">
                <xsl:choose>
                    <xsl:when test="r:SeriesName/r:String[@xml:lang=$lang]">
                        <xsl:value-of select="normalize-space(r:SeriesName/r:String[@xml:lang=$lang])"/>
                    </xsl:when>
                    <xsl:when test="r:SeriesName/r:String[@xml:lang=$fallback-lang]">
                        <xsl:value-of select="normalize-space(r:SeriesName/r:String[@xml:lang=$fallback-lang])"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(r:SeriesName/r:String)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </subfield>
        </datafield>
    </xsl:template>    
    <xsl:template match="r:Publisher">
        <subfield xmlns="http://www.loc.gov/MARC21/slim" code="a">
            <xsl:value-of select="normalize-space(.)"/>
        </subfield>
    </xsl:template>
    <xsl:template match="r:Keyword">
        <xsl:variable name="codeList">
            <xsl:value-of select="normalize-space(@codeListID)"/>
        </xsl:variable>
        <datafield xmlns="http://www.loc.gov/MARC21/slim" ind1=" ">
            <xsl:attribute name="ind2">
                <xsl:choose>
                    <xsl:when test="$codeList='LCSH'">0</xsl:when>
                    <xsl:when test="$codeList='MeSH'">2</xsl:when>
                    <xsl:otherwise>7</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="tag">650</xsl:attribute>
            <subfield code="a">
                <xsl:value-of select="normalize-space(.)"/>
            </subfield>
            <xsl:if test="$codeList!='LCSH' and $codeList!='MeSH'">
                <subfield code="2">
                    <xsl:value-of select="$codeList"/>
                </subfield>
            </xsl:if>
        </datafield>
    </xsl:template>
    <xsl:template match="r:Subject">
        <xsl:variable name="codeList">
            <xsl:value-of select="normalize-space(@codeListID)"/>
        </xsl:variable>
        <datafield xmlns="http://www.loc.gov/MARC21/slim" ind1="1">
            <xsl:attribute name="ind2">
                <xsl:choose>
                    <xsl:when test="$codeList='LCSH'">0</xsl:when>
                    <xsl:when test="$codeList='MeSH'">2</xsl:when>
                    <xsl:otherwise>7</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="tag">650</xsl:attribute>
            <subfield code="a">
                <xsl:value-of select="normalize-space(.)"/>
            </subfield>
            <xsl:if test="$codeList!='LCSH' and $codeList!='MeSH'">
                <subfield code="2">
                    <xsl:value-of select="$codeList"/>
                </subfield>
            </xsl:if>
        </datafield>
    </xsl:template>
    <xsl:template match="r:Creator">
        <datafield xmlns="http://www.loc.gov/MARC21/slim" ind1=" " ind2=" " tag="720">
            <subfield code="a">
                <xsl:value-of select="normalize-space(.)"/>
            </subfield>
            <xsl:if test="@affiliation">
                <subfield code="u">
                    <xsl:value-of select="normalize-space(@affiliation)"/>
                </subfield>
            </xsl:if>
        </datafield>
    </xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="utf-8"?>
<!--

Description:
XSLT Stylesheet for conversion between DDI-L version 3.1 and MARC-XML

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

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:dc="http://purl.org/dc/elements/1.1/" 
                xmlns:g="ddi:group:3_1" 
                xmlns:d="ddi:datacollection:3_1" 
                xmlns:dc2="ddi:dcelements:3_1" 
                xmlns:c="ddi:conceptualcomponent:3_1" 
                xmlns:xhtml="http://www.w3.org/1999/xhtml" 
                xmlns:a="ddi:archive:3_1"
                xmlns:m1="ddi:physicaldataproduct/ncube/normal:3_1" 				
                xmlns:m2="ddi:physicaldataproduct/ncube/tabular:3_1" 
                xmlns:m3="ddi:physicaldataproduct/ncube/inline:3_1" 
                xmlns:ddi="ddi:instance:3_1" 			
                xmlns:o="ddi:organizations:3_1" 
                xmlns:l="ddi:logicalproduct:3_1" 				
                xmlns:pd="ddi:physicaldataproduct:3_1"
                xmlns:cm="ddi:comparative:3_1" 
                xmlns:s="ddi:studyunit:3_1" 
                xmlns:r="ddi:reusable:3_1" 
                xmlns:pi="ddi:physicalinstance:3_1" 
                xmlns:ds="ddi:dataset:3_1" 
                xmlns:pr="ddi:profile:3_1"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="ddi:instance:3_1 http://www.ddialliance.org/sites/default/files/schema/ddi3.1/instance.xsd">
  
    <xsl:output method="xml" encoding="iso-8859-1" indent="yes" />

    <!-- render text-elements of this language-->
    <xsl:param name="lang">sv</xsl:param>
    <!-- if the requested language is not found for e.g. questionText, use fallback language-->
    <xsl:param name="fallback-lang">en</xsl:param>
  
    <xsl:template match="ddi:DDIInstance">
        <xsl:text>
            
        </xsl:text>
        <xsl:comment>		  
            Automatically generated file from a DDI-L version 3.1 XML input file using the ddi3tomarc 
            xslt stylesheet for transformation by the Swedish National Data Service	
        </xsl:comment>
        <xsl:text>
            
        </xsl:text>
        <collection xmlns="http://www.loc.gov/MARC21/slim">
            <xsl:apply-templates select="s:StudyUnit"/>
        </collection>
  
    </xsl:template>
  
    <xsl:template match="s:StudyUnit">
        <record>
            
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
            
            <!-- 010: LCCN -->
            <xsl:if test="r:Citation/r:InternationalIdentifier[@type='LCCN']">
                <datafield ind1=" " ind2=" " tag="010">
                    <subfield code="a">
                        <xsl:value-of select="normalize-space(r:Citation/r:InternationalIdentifier[@type='LCCN'])"/>
                    </subfield>
                </datafield>
            </xsl:if> 
                                  
            <!-- 020: ISBN -->
            <xsl:if test="r:Citation/r:InternationalIdentifier[@type='ISBN']">
                <datafield ind1=" " ind2=" " tag="020">
                    <subfield code="a">
                        <xsl:value-of select="normalize-space(r:Citation/r:InternationalIdentifier[@type='ISBN'])"/>
                    </subfield>
                </datafield>
            </xsl:if> 
            
            <!-- 022: ISSN -->
            <xsl:if test="r:Citation/r:InternationalIdentifier[@type='ISSN']">
                <datafield ind1=" " ind2=" " tag="022">
                    <subfield code="a">
                        <xsl:value-of select="normalize-space(r:Citation/r:InternationalIdentifier[@type='ISSN'])"/>
                    </subfield>
                </datafield>
            </xsl:if> 
                    
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
                                    <xsl:value-of select="normalize-space(r:Citation/r:PublicationDate/r:SimpleDate)"/>
                                </xsl:when>
                                <xsl:when test="r:Citation/r:PublicationDate/r:StartDate">
                                    <xsl:variable name="pub_date" select="normalize-space(r:Citation/r:PublicationDate/r:StartDate)"/>
                                    <xsl:if test="r:Citation/r:PublicationDate/r:EndDate">
                                        <xsl:variable name="pub_date" select="concat($pub_date, ' - ', normalize-space(r:Citation/r:PublicationDate/r:EndDate))"/>
                                    </xsl:if>
                                    <xsl:value-of select="$pub_date"/>     
                                </xsl:when>
                            </xsl:choose>
                        </subfield>
                    </xsl:if>
                </datafield>
            </xsl:if>
            
            <!-- 490: Series -->
            <xsl:if test="r:SeriesStatement/r:SeriesName">
                <datafield ind1="0" ind2=" " tag="490">
                    <subfield code="a">
                        <xsl:choose>
                            <xsl:when test="r:SeriesStatement/r:SeriesName[@xml:lang=$lang]">                    
                                <xsl:value-of select="normalize-space(r:SeriesStatement/r:SeriesName[@xml:lang=$lang])"/>
                            </xsl:when>
                            <xsl:when test="r:SeriesStatement/r:SeriesName[@xml:lang=$fallback-lang]">
                                <xsl:value-of select="normalize-space(r:SeriesStatement/r:SeriesName[@xml:lang=$fallback-lang])"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(r:SeriesStatement/r:SeriesName)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </subfield>
                </datafield>
            </xsl:if>
            
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
                                <xsl:value-of select="normalize-space(s:Abstract/r:Content)"/>
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
            
            <!-- 856: URI -->
            <xsl:if test="a:Archive/a:ArchiveSpecific/a:Collection/a:URI">
                <datafield ind1="4" ind2="0" tag="856">
                    <subfield code="u">
                        <xsl:value-of select="normalize-space(a:Archive/a:ArchiveSpecific/a:Collection/a:URI)"/>
                    </subfield>
                </datafield>
            </xsl:if>
            
        </record>  
    </xsl:template>
  
    <xsl:template match="r:Publisher">
        <subfield code="a">
            <xsl:value-of select="normalize-space(.)"/>
        </subfield>
    </xsl:template>
    
    <xsl:template match="r:Keyword">     
        <xsl:variable name="codeList">
            <xsl:value-of select="normalize-space(@codeListID)"/>
        </xsl:variable>
        <datafield ind1=" ">
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
        <datafield ind1="1">
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
        <datafield ind1=" " ind2=" " tag="720">
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
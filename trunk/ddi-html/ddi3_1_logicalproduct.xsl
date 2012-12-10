<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
		xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:g="ddi:group:3_1"
                xmlns:d="ddi:datacollection:3_1"
                xmlns:dce="ddi:dcelements:3_1"
                xmlns:c="ddi:conceptualcomponent:3_1"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:a="ddi:archive:3_1"
                xmlns:m1="ddi:physicaldataproduct/ncube/normal:3_1"
                xmlns:ddi="ddi:instance:3_1"
                xmlns:m2="ddi:physicaldataproduct/ncube/tabular:3_1"
                xmlns:o="ddi:organizations:3_1"
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
                xmlns:util="https://code.google.com/p/ddixslt/#util"
                version="2.0"
                xsi:schemaLocation="ddi:instance:3_1 http://www.ddialliance.org/sites/default/files/schema/ddi3.1/instance.xsd">
    <xsl:output method="html"/>
    
    <!-- params -->
    <xsl:param name="translations">i18n/messages_en.properties.xml</xsl:param>
    <xsl:variable name="msg" select="document($translations)"/>	

    <xsl:template match="l:LogicalProduct">
        <div class="variableSchemes">
             <xsl:apply-templates select="l:VariableScheme"/>
        </div>
    </xsl:template>
    
    
    <!-- Codes -->
    <xsl:template match="l:CodeScheme">
        <xsl:if test="count(l:Code) > 0">
        <table class="codeScheme">
            <thead>
                <tr>
                    <th><xsl:value-of select="util:i18n('Code')"/></th>
                    <th class="left"><xsl:value-of select="util:i18n('Category')"/></th>
                </tr>
            </thead>
            <tbody>
                <xsl:apply-templates select="l:Code" />
            </tbody>
        </table>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="r:CodeSchemeReference">
        <xsl:variable name="csID" select="r:ID" />
        <xsl:apply-templates select="//l:CodeScheme[@id = $csID]" />
    </xsl:template>    

    <xsl:template match="l:Code">
        <tr>
            <td class="codeValue"><xsl:value-of select="l:Value" /></td>
            <xsl:apply-templates select ="l:CategoryReference" />
        </tr>
    </xsl:template>
    
    <xsl:template match="l:CodeRepresentation">
        <ul>
            <li class="codeDomain">
                <xsl:apply-templates select="r:CodeSchemeReference" />
            </li>
        </ul>
    </xsl:template>    

    <!-- Representations -->
    <xsl:template match="l:TextRepresentation">
        <ul>
            <li class="textRepresentation">
                Text (max length: <xsl:value-of select="@maxLength" />)
            </li>
        </ul>
    </xsl:template>

    <xsl:template match="l:NumericRepresentation">
        <ul><li class="numeric"><xsl:value-of select="@type" /> (<xsl:value-of select="@decimalPositions" /><xsl:text> </xsl:text><xsl:value-of select="$msg/*/entry[@key='Decimals']"/>)</li></ul>

    </xsl:template>

    <xsl:template match="l:Category">
       <xsl:choose>
           <xsl:when test="@missing">
               <td class="missing left"><em><xsl:value-of select="util:i18nString(r:Label)" /></em></td>
           </xsl:when>
           <xsl:otherwise>
               <td class="categoryLabel left"><xsl:value-of select="util:i18nString(r:Label)" /></td>
           </xsl:otherwise>
       </xsl:choose>
    </xsl:template>
    
    <xsl:template match="l:CategoryReference">
        <xsl:variable name="csID" select="r:ID" />
        <xsl:apply-templates select="//l:Category[@id = $csID]" />
    </xsl:template>    

    <!-- Variables -->
    <xsl:template match="l:VariableScheme">
        <h3><xsl:value-of select="$msg/*/entry[@key='Variables']"/></h3>
        <div class="variableScheme">
            <a><xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute></a>
            <ul class="variables">
            <xsl:apply-templates select="l:Variable" />
            </ul>
        </div>
    </xsl:template>
    
    <xsl:template match="l:VariableSchemeReference">
        <xsl:variable name="vsID" select="r:ID" />
        <xsl:apply-templates select="//l:VariableScheme[@id = $vsID]" />
    </xsl:template>    

    <xsl:template match="l:Variable">
          <li>
              <a>
                <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
              </a>
              <strong class="variableName"><xsl:value-of select="l:VariableName"/></strong><span class="label"><xsl:value-of select="r:Label"/></span>

              <xsl:apply-templates select="l:Representation/l:CodeRepresentation" />
              <xsl:apply-templates select="l:Representation/l:NumericRepresentation" />
              <xsl:apply-templates select="l:Representation/l:TextRepresentation" />
          </li>
    </xsl:template>    
    
</xsl:stylesheet>
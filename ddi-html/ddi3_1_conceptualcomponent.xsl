<?xml version="1.0" encoding="UTF-8"?>
    
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:g="ddi:group:3_1" xmlns:d="ddi:datacollection:3_1" xmlns:dce="ddi:dcelements:3_1"
    xmlns:c="ddi:conceptualcomponent:3_1" xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:a="ddi:archive:3_1" xmlns:m1="ddi:physicaldataproduct/ncube/normal:3_1"
    xmlns:ddi="ddi:instance:3_1" xmlns:m2="ddi:physicaldataproduct/ncube/tabular:3_1"
    xmlns:o="ddi:organizations:3_1" xmlns:l="ddi:logicalproduct:3_1"
    xmlns:m3="ddi:physicaldataproduct/ncube/inline:3_1" xmlns:pd="ddi:physicaldataproduct:3_1"
    xmlns:cm="ddi:comparative:3_1" xmlns:s="ddi:studyunit:3_1" xmlns:r="ddi:reusable:3_1"
    xmlns:pi="ddi:physicalinstance:3_1" xmlns:ds="ddi:dataset:3_1" xmlns:pr="ddi:profile:3_1"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="https://code.google.com/p/ddixslt/#util"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    version="2.0"
    xsi:schemaLocation="ddi:instance:3_1 http://www.ddialliance.org/sites/default/files/schema/ddi3.1/instance.xsd">


    <!-- params -->
    <!--xsl:param name="translations">i18n/messages_en.properties.xml</xsl:param>
    <xsl:variable name="msg" select="document($translations)"/-->

    <!-- output -->
    <xsl:output method="html"/>

    <xsl:template match="c:ConceptualComponent">
        <div class="conceptualComponent"> 
            <xsl:if test="c:ConceptualComponentModuleName">
                <h3>
                    <xsl:value-of select="c:ConceptualComponentModuleName"/>
                </h3>
            </xsl:if>           
            <xsl:if test="count(c:ConceptScheme/c:Concept) > 0">
                <h3 id="ConceptList"><xsl:value-of select="util:i18n('Concepts')"/></h3>
                <xsl:apply-templates select="c:ConceptScheme"/>
            </xsl:if>
        </div>
    </xsl:template>

    <xsl:template match="c:ConceptScheme">
        <div class="conceptScheme">
            <xsl:call-template name="CreateLink"/>
            <xsl:if test="r:Label">
                <h3 class="conceptSchemeLabel">
                    <xsl:call-template name="DisplayLabel"/>
                </h3>
            </xsl:if>
            <ul class="conceptList">
                <xsl:for-each select="c:Concept">
                    <xsl:apply-templates select="."/>
                </xsl:for-each>
            </ul>
            <!--</xsl:if>-->
        </div>
    </xsl:template>

    <xsl:template match="c:Concept">
        <xsl:variable name="uniId" select="@id"/>
        <li class="concepts">
            <xsl:call-template name="CreateLink"/>
            <strong><xsl:call-template name="DisplayLabel"/></strong><br/>
            <xsl:call-template name="DisplayDescription"/>
            <ul>                
                <li class="variable">
                    <xsl:for-each select="../../../l:LogicalProduct/l:VariableScheme/l:Variable">
                        <xsl:if test="$uniId = l:ConceptReference/r:ID">
                            <a>
                                <xsl:attribute name="href">#<xsl:value-of select="@id"/>.<xsl:value-of select="@version"/></xsl:attribute>
                                <xsl:value-of select="l:VariableName"/>
                            </a>
                            <xsl:text> </xsl:text>
                        </xsl:if>  
                    </xsl:for-each>        
                </li>
            </ul>
        </li>
    </xsl:template>
</xsl:stylesheet>

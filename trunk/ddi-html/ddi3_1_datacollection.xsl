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

    <!-- render text-elements of this language-->
    <xsl:param name="lang">da</xsl:param>
    <!-- if the requested language is not found for e.g. questionText, use fallback language-->
    <xsl:param name="fallback-lang">en</xsl:param>
    <!-- print anchors for eg QuestionItems-->
    <xsl:param name="print-anchor">1</xsl:param>

    <xsl:template match="d:DataCollection">  
        <div class="dataCollection">
            <xsl:if test="r:OtherMaterial">
                <h3><xsl:value-of select="util:i18n('Other_resources')"/></h3>
                <ul class="otherMaterial">
                    <xsl:apply-templates select="r:OtherMaterial"/>
                </ul>
            </xsl:if>
            <div class="questionSchemes">
                <xsl:apply-templates select="d:QuestionScheme"/>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="d:QuestionScheme">
        <div>
            <xsl:attribute name="class">questionScheme</xsl:attribute>
            <xsl:attribute name="id">questionScheme-id-<xsl:value-of select="@id"/>
            </xsl:attribute>
            <a>
                <xsl:attribute name="name">questionScheme-<xsl:value-of select="@id"/>
                </xsl:attribute>
            </a>
            <xsl:if test="d:QuestionSchemeName">
                <h3 class="questionSchemeName">               
                    <xsl:choose>
                        <xsl:when test="d:QuestionSchemeName[@xml:lang=$lang]">
                            <xsl:value-of select="d:QuestionSchemeName[@xml:lang=$lang]"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <em>
                                <xsl:value-of select="d:QuestionSchemeName[@xml:lang=$fallback-lang]"/>
                            </em>
                        </xsl:otherwise>
                    </xsl:choose>               
                </h3>
            </xsl:if>
            <!-- <xsl:if test="count(./*[name(.) ='d:QuestionItem' or name(.) ='d:MultipleQuestionItem']) > 0"> -->
            <ul class="questions">
                <xsl:for-each select="d:QuestionItem | d:MultipleQuestionItem">
                    <xsl:apply-templates select="."/>
                </xsl:for-each>
            </ul>
            <!--</xsl:if>-->
        </div>
    </xsl:template>
    
    <xsl:template match="d:QuestionItem">
        <li>
            <!-- use optional external question-id as id to the li-element -->
            <xsl:attribute name="class">question-<xsl:value-of select="r:UserID[@type='question_id']"/>
            </xsl:attribute>
            <xsl:if test="$print-anchor">
            <a>
                <xsl:attribute name="name">question-<xsl:value-of select="@id"/>
                </xsl:attribute>
            </a>
           </xsl:if>
            <strong class="questionName">
                <xsl:choose>
                    <xsl:when test="d:QuestionItemName[@xml:lang=$lang]">
                        <xsl:value-of select="d:QuestionItemName[@xml:lang=$lang]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="d:QuestionItemName"/>
                    </xsl:otherwise>
                </xsl:choose>
            </strong>
            <span class="questionText">
                <xsl:choose>
                    <xsl:when test="d:QuestionText[@xml:lang=$lang]/d:LiteralText/d:Text">
                        <xsl:value-of select="d:QuestionText[@xml:lang=$lang]/d:LiteralText/d:Text"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <em>
                            <xsl:value-of select="d:QuestionText[@xml:lang=$fallback-lang]/d:LiteralText/d:Text"/>
                        </em>
                    </xsl:otherwise>
                </xsl:choose>
            </span>

            <xsl:apply-templates select="d:CodeDomain" />
            <xsl:apply-templates select="d:NumericDomain" />
            <xsl:apply-templates select="d:TextDomain" />
            
            <!-- generate variable-links-->
            <xsl:variable name="qiID" select="@id" />
            <xsl:if test="count(//l:Variable[l:QuestionReference/r:ID = $qiID]) > 0">
            <ul class="variables">
                <li>
                    <strong class="variableName"><xsl:value-of select="//l:Variable[l:QuestionReference/r:ID = $qiID]/l:VariableName"/></strong>
                    <a>
                       <xsl:attribute name="href">#<xsl:value-of select="//l:Variable[l:QuestionReference/r:ID = $qiID]/@id"/></xsl:attribute>
                       <xsl:value-of select="//l:Variable[l:QuestionReference/r:ID = $qiID]/r:Label"/>
                    </a>
                </li>
            </ul>
            </xsl:if>
        </li>
    </xsl:template>

    <xsl:template match="d:MultipleQuestionItem">
        <li>
            <!-- use optional external question-id as id to the li-element -->
            <xsl:attribute name="class">question-<xsl:value-of select="r:UserID[@type='question_id']"/></xsl:attribute>
            <strong class="questionName">
                <xsl:choose>
                    <xsl:when test="d:MultipleQuestionItemName[@xml:lang=$lang]">
                        <xsl:value-of select="d:MultipleQuestionItemName[@xml:lang=$lang]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="d:MultipleQuestionItemName"/>
                    </xsl:otherwise>
                </xsl:choose>
            </strong>            
            <xsl:choose>
                <xsl:when test="d:QuestionText[@xml:lang=$lang]/d:LiteralText/d:Text">
                    <xsl:value-of select="d:QuestionText[@xml:lang=$lang]/d:LiteralText/d:Text"/>
                </xsl:when>
                <xsl:otherwise>
                    <em>
                        <xsl:value-of select="d:QuestionText[@xml:lang=$fallback-lang]/d:LiteralText/d:Text"/>
                    </em>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="count(d:SubQuestions) > 0">
            <ul class="questions">
                <xsl:apply-templates select="d:SubQuestions" />
            </ul>
            </xsl:if>
        </li>
    </xsl:template>

    <xsl:template match="d:SubQuestions">
        <xsl:if test="count(child::*) > 0">
            <xsl:for-each select="child::*">
                <xsl:apply-templates select="."/>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>    
    
    <xsl:template match="d:CodeDomain">
        <ul>
            <li class="codeDomain">
                <xsl:apply-templates select="r:CodeSchemeReference" />
            </li>
        </ul>
    </xsl:template>

    <xsl:template match="d:NumericDomain">
        <ul><li class="numeric"><xsl:value-of select="@type" /></li></ul>
    </xsl:template>    
 
    <xsl:template match="d:TextDomain">
        <ul>
            <li class="text">
                <xsl:if test="@minLength">
                    <xsl:value-of select="util:i18n('Minimum')"/>: <xsl:value-of select="@minLength" />
                </xsl:if>
                <xsl:if test="@maxLength">
                    <xsl:value-of select="util:i18n('Maximum')"/>: <xsl:value-of select="@maxLength" />
                </xsl:if>
            </li>
        </ul>
    </xsl:template>
</xsl:stylesheet>
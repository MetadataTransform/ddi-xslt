<xsl:stylesheet xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:g="ddi:group:3_1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:d="ddi:datacollection:3_1" xmlns:dce="ddi:dcelements:3_1" xmlns:c="ddi:conceptualcomponent:3_1" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:a="ddi:archive:3_1" xmlns:m1="ddi:physicaldataproduct/ncube/normal:3_1" xmlns:ddi="ddi:instance:3_1" xmlns:m2="ddi:physicaldataproduct/ncube/tabular:3_1" xmlns:o="ddi:organizations:3_1" xmlns:l="ddi:logicalproduct:3_1" xmlns:m3="ddi:physicaldataproduct/ncube/inline:3_1" xmlns:pd="ddi:physicaldataproduct:3_1" xmlns:cm="ddi:comparative:3_1" xmlns:s="ddi:studyunit:3_1" xmlns:r="ddi:reusable:3_1" xmlns:pi="ddi:physicalinstance:3_1" xmlns:ds="ddi:dataset:3_1" xmlns:pr="ddi:profile:3_1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" xsi:schemaLocation="ddi:instance:3_1 http://www.ddialliance.org/sites/default/files/schema/ddi3.1/instance.xsd">
    <xsl:output method="text"/>
    
    <xsl:param name="source">sv</xsl:param>
    <xsl:param name="target">en</xsl:param>
    
    <xsl:template match="/ddi:DDIInstance">
        <xsl:apply-templates select="s:StudyUnit/d:DataCollection/d:QuestionScheme"/>
    </xsl:template>
    <xsl:template match="d:QuestionScheme">
        <xsl:for-each select="child::*">
            <xsl:apply-templates select="."/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="/ddi:DDIInstance/*">AAAAAAAAAA</xsl:template>
    <xsl:template match="d:QuestionItem">
        <xsl:variable name="msgid" select="d:QuestionText[@xml:lang=$source]/d:LiteralText/d:Text"/>
msgid "<xsl:call-template name="string-replace-all">
            <xsl:with-param name="text" select="$msgid"/>
            <xsl:with-param name="replace" select="'&#xA;'"/>
            <xsl:with-param name="by" select="'&#34;&#xA;&#34;'"/>
        </xsl:call-template>"<xsl:variable name="msgstr" select="d:QuestionText[@xml:lang=$target]/d:LiteralText/d:Text"/>
msgstr "<xsl:call-template name="string-replace-all">
            <xsl:with-param name="text" select="$msgstr"/>
            <xsl:with-param name="replace" select="'&#xA;'"/>
            <xsl:with-param name="by" select="'&#34;&#xA;&#34;'"/>
        </xsl:call-template>"
<xsl:text>
</xsl:text>
    </xsl:template>
    <xsl:template match="d:MultipleQuestionItem">
        <xsl:variable name="msgid" select="d:QuestionText[@xml:lang=$source]/d:LiteralText/d:Text"/>
msgid "<xsl:call-template name="string-replace-all">
            <xsl:with-param name="text" select="$msgid"/>
            <xsl:with-param name="replace" select="'&#xA;'"/>
            <xsl:with-param name="by" select="'&#34;&#xA;&#34;'"/>
        </xsl:call-template>"<xsl:variable name="msgstr" select="d:QuestionText[@xml:lang=$target]/d:LiteralText/d:Text"/>
msgstr "<xsl:call-template name="string-replace-all">
            <xsl:with-param name="text" select="$msgstr"/>
            <xsl:with-param name="replace" select="'&#xA;'"/>
            <xsl:with-param name="by" select="'&#34;&#xA;&#34;'"/>
        </xsl:call-template>"
		
		<xsl:apply-templates select="d:SubQuestions"/>
    </xsl:template>
    <xsl:template match="d:SubQuestions">
        <xsl:for-each select="child::*">
            <xsl:apply-templates select="."/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="string-replace-all">
        <xsl:param name="text"/>
        <xsl:param name="replace"/>
        <xsl:param name="by"/>
        <xsl:choose>
            <xsl:when test="contains($text,$replace)">
                <xsl:value-of select="substring-before($text,$replace)"/>
                <xsl:value-of select="$by"/>
                <xsl:call-template name="string-replace-all">
                    <xsl:with-param name="text" select="substring-after($text,$replace)"/>
                    <xsl:with-param name="replace" select="$replace"/>
                    <xsl:with-param name="by" select="$by"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xs= "http://www.w3.org/2001/XMLSchema"
    xmlns:xsi= "http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl= "http://www.w3.org/1999/XSL/Transform"
    xmlns:xml= "http://www.w3.org/XML/1998/namespace" 
    version="2.0">

    <!-- The study identifier. If not specified will attempt to retrieve from DDI-XML -->
    <xsl:param name="studyId">
        <xsl:choose>
            <xsl:when test="/*:codeBook/@ID">
                <xsl:value-of select="/*:codeBook/@ID"/>
            </xsl:when>
            <xsl:when test="/*:codeBook/*:stdyDscr/*:citation/*:titlStmt/*:IDNo">
                <xsl:value-of select="/*:codeBook/*:stdyDscr/*:citation/*:titlStmt/*:IDNo"/>
            </xsl:when>
        </xsl:choose>
    </xsl:param>

    <!-- The studys repository. If not specified will attempt to retrieve from DDI-XML -->
    <xsl:param name="repository">
        <xsl:choose>
            <xsl:when test="/*:codeBook/*:stdyDscr/*:citation/*:distStmt/*:distrbtr/@abbr">
                <xsl:value-of select="/*:codeBook/*:stdyDscr/*:citation/*:distStmt/*:distrbtr/@abbr"/>
            </xsl:when>
            <xsl:when test="/*:codeBook/*:docDscr/*:citation/*:titlStmt/*:IDNo/@agency">
                <xsl:value-of select="/*:codeBook/*:docDscr/*:citation/*:titlStmt/*:IDNo/@agency"/>
            </xsl:when>
        </xsl:choose>
    </xsl:param>

    <xsl:output method="text"/>

    <xsl:template match="*:codeBook">
        <xsl:text>{"group": "","collection": "",</xsl:text>
        <xsl:apply-templates select="*:stdyDscr"/>
        <xsl:text>}</xsl:text>
    </xsl:template>


    <xsl:template match="*:stdyDscr">
        <!-- study id -->
        <xsl:text>"id": "</xsl:text>
        <xsl:value-of select="$studyId"/>
        <xsl:text>",</xsl:text>

        <!-- repository -->
        <xsl:text>"repository": "</xsl:text>
        <xsl:value-of select="$repository"/>
        <xsl:text>",</xsl:text>

        <!-- kind of data -->
        <xsl:if test="*:stdyInfo/*:sumDscr/*:dataKind">
            <xsl:text>"kindofdata": "</xsl:text>
            <xsl:value-of select="*:stdyInfo/*:sumDscr/*:dataKind"/>
            <xsl:text>",</xsl:text>
        </xsl:if>

        <!-- title -->
        <xsl:text>"title": [</xsl:text>
        <xsl:text>{"en": "</xsl:text>
        <xsl:value-of select="*:citation/*:titlStmt/*:titl"/>
        <xsl:text>"}],</xsl:text>

        <!-- creator -->
        <xsl:text>"creator": [{"en": "</xsl:text>
        <xsl:value-of select="*:citation/*:prodStmt/*:producer"/>
        <xsl:text>"}],</xsl:text>

        <xsl:variable name="timePrd" select="*:stdyInfo/*:sumDscr/*:collDate"/>
        <xsl:if test="$timePrd[@event = 'start']">
            <xsl:text>"startdate": "</xsl:text>
            <xsl:value-of select="$timePrd[@event = 'start']/@date" />
            <xsl:text>",</xsl:text>
        </xsl:if>
        <xsl:if test="$timePrd[@event = 'end']">
            <xsl:text>"enddate": "</xsl:text>
            <xsl:value-of select="$timePrd[@event = 'end']/@date" />
            <xsl:text>",</xsl:text>
        </xsl:if>

        <xsl:if test="*:stdyInfo/*:subject/*:topcClas">
            <xsl:text>"subject": [</xsl:text>
            <xsl:for-each select="*:stdyInfo/*:subject/*:topcClas">
                <xsl:text>{"en": "</xsl:text>
                <xsl:value-of select="normalize-space(.)"/>
                <xsl:text>"}</xsl:text>
                <xsl:if test="position() != last()">, </xsl:if>
            </xsl:for-each>
            <xsl:text>],</xsl:text>
        </xsl:if>

        <xsl:if test="*:stdyInfo/*:subject/*:keyword">
            <xsl:text>"keyword": [</xsl:text>
            <xsl:for-each select="*:stdyInfo/*:subject/*:keyword">
                <xsl:text>{"en": "</xsl:text>
                <xsl:value-of select="normalize-space(.)"/>
                <xsl:text>"}</xsl:text>
                <xsl:if test="position() != last()">, </xsl:if>
            </xsl:for-each>
            <xsl:text>],</xsl:text>
        </xsl:if>

        <!-- abstract -->
        <xsl:text>"abstract": [{"en": "</xsl:text>
        <xsl:for-each select="*:stdyInfo/*:abstract">
            <xsl:call-template name="escapeQuote" />
        </xsl:for-each>
        <xsl:text>"}],</xsl:text>

        <!-- timemethod -->
        <xsl:if test="*:method/*:dataColl/*:timeMeth">
            <xsl:text>"timemethod": "</xsl:text>
            <xsl:value-of select="normalize-space(*:method/*:dataColl/*:timeMeth)" />
            <xsl:text>",</xsl:text>
        </xsl:if>

        <!-- analysisunit -->
        <xsl:if test="*:stdyInfo/*:sumDscr/*:anlyUnit">
            <xsl:text>"analysisunit": "</xsl:text>
            <xsl:value-of select="normalize-space(*:stdyInfo/*:sumDscr/*:anlyUnit)" />
            <xsl:text>",</xsl:text>
        </xsl:if>

        <!-- country -->
        <xsl:if test="*:stdyInfo/*:sumDscr/*:nation">
            <xsl:text>"country": "</xsl:text>
                <xsl:value-of select="*:stdyInfo/*:sumDscr/*:nation" />
            <xsl:text>",</xsl:text>
        </xsl:if>

        <!-- modeofcollection -->
        <xsl:text>"modeofcollection": "</xsl:text>
            <xsl:value-of select="*:method/*:dataColl/*:collMode" />
        <xsl:text>",</xsl:text>
        

        <!-- samplingprocedure -->
        <xsl:text>"samplingprocedure": "</xsl:text>
            <xsl:value-of select="normalize-space(*:method/*:dataColl/*:sampProc)" />
        <xsl:text>",</xsl:text>

        <!-- Accesscondition -->

        <xsl:text>"accessconditions": "</xsl:text>
        <xsl:value-of select="normalize-space(*:dataAccs/*:setAvail/*:avlStatus)" />
        <xsl:text>"</xsl:text>
        

    </xsl:template>

    <xsl:template name="escapeQuote">
        <xsl:param name="pText" select="normalize-space(.)"/>
        
        <xsl:if test="string-length($pText) >0">
            <xsl:value-of select=
                "substring-before(concat($pText, '&quot;'), '&quot;')"/>
            
            <xsl:if test="contains($pText, '&quot;')">
                <xsl:text>\"</xsl:text>
                
                <xsl:call-template name="escapeQuote">
                    <xsl:with-param name="pText" select=
                        "substring-after($pText, '&quot;')"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
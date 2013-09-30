<?xml version='1.0' encoding='UTF-8'?>

<!-- ================================================= -->
<!-- [2] Cover page                                    -->
<!-- [page-sequence]                                   -->
<!-- ================================================= -->

<!-- Variables read:                                      -->
<!-- show-logo, show-geography, show-cover-page-producer, -->
<!-- show-report-subtitle                                 -->

<!-- Functions/templates called:                          -->
<!-- normalize-space() [Xpath 1.0]                        -->
<!-- trim, isodate-long                                   -->

<xsl:if test="$show-cover-page = 1"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:page-sequence master-reference="default-page" font-family="Helvetica" font-size="10pt">
    <fo:flow flow-name="xsl-region-body">

      <fo:block id="cover-page">

        <!-- logo graphic -->
        <xsl:if test="$show-logo = 1" >
          <fo:block text-align="center">
            <fo:external-graphic src="http://xml.snd.gu.se/xsl/ddi2/ddi-fo/images/snd_logo_sv.png" />
          </fo:block>
        </xsl:if>

        <!-- geography -->
        <xsl:if test="$show-geography = 1">
          <fo:block font-size="14pt" font-weight="bold" space-before="0.5in" text-align="center" space-after="0.2in">
            <xsl:value-of select="$geography" />
          </fo:block>
        </xsl:if>

        <!-- title -->
        <fo:block font-size="18pt" font-weight="bold" space-before="0.5in" text-align="center" space-after="0.0in">
          <xsl:value-of select="normalize-space(/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:titl)" />
        </fo:block>
        
        <!-- $report-title (actually report subtitle) -->
        <xsl:if test="show-report-subtitle">
          <fo:block font-size="16pt" font-weight="bold" space-before="1.0in" text-align="center" space-after="0.0in">
            <xsl:value-of select="$report-title" />
          </fo:block>
        </xsl:if>

        <!-- blank line (&#x00A0; is the equivalent of HTML &nbsp;) -->
        <fo:block white-space-treatment="preserve"> &#x00A0; </fo:block>

        <!-- responsible party -->
        <xsl:if test="$show-cover-page-producer = 1">
          <xsl:for-each select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:rspStmt/ddi:AuthEnty">
            <fo:block font-size="14pt" font-weight="bold" space-before="0.0in" text-align="center" space-after="0.0in">
              <xsl:call-template name="trim">
                <xsl:with-param name="s">
                  <xsl:value-of select="." />
                </xsl:with-param>
              </xsl:call-template>
              <xsl:if test="@affiliation">,
                <xsl:value-of select="@affiliation" />
              </xsl:if>
            </fo:block>
          </xsl:for-each>
        </xsl:if>

      </fo:block>
    </fo:flow>
  </fo:page-sequence>
</xsl:if>

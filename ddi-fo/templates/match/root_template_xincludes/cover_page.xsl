<?xml version='1.0' encoding='UTF-8'?>
<!-- ========================= -->
<!-- <xsl:if> cover page       -->
<!-- value: <fo:page-sequence> -->
<!-- ========================= -->

<!-- read: -->
<!-- show-logo, show-geography, show-cover-page-producer, -->
<!-- show-report-subtitle                                 -->

<!-- functions: -->
<!-- normalize-space() [Xpath 1.0] -->

<!-- called: -->
<!-- trim, isodate-long -->

<xsl:if test="$show-cover-page = 1"
        xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:page-sequence master-reference="{$page-layout}"
                    font-family="Helvetica"
                    font-size="{$font-size}">

    <!-- =========================================== -->
    <!-- page content                                -->
    <!-- =========================================== -->

    <fo:flow flow-name="body">

      <fo:block id="cover-page">

        <!-- logo graphic -->
        <xsl:if test="$show-logo = 1" >
          <fo:block text-align="center">
            <fo:external-graphic src="{$logo-file}" />
          </fo:block>
        </xsl:if>

        <!-- geography -->
        <xsl:if test="$show-geography = 1">
          <fo:block font-size="14pt" font-weight="bold" space-before="0.5in"
                    text-align="center" space-after="0.2in">
            <xsl:value-of select="$geography" />
          </fo:block>
        </xsl:if>

        <!-- title -->
        <fo:block font-size="18pt" font-weight="bold" space-before="0.5in"
                  text-align="center" space-after="0.0in">
          <xsl:value-of select="normalize-space(/codeBook/stdyDscr/citation/titlStmt/titl)" />
        </fo:block>
        
        <!-- $report-title (actually report subtitle) -->
        <xsl:if test="show-report-subtitle">
          <fo:block font-size="16pt" font-weight="bold" space-before="1.0in"
                    text-align="center" space-after="0.0in">
            <xsl:value-of select="$report-title" />
          </fo:block>
        </xsl:if>

        <!-- blank line (&#x00A0; is the equivalent of HTML &nbsp;) -->
        <fo:block white-space-treatment="preserve"> &#x00A0; </fo:block>

        <!-- responsible party -->
        <xsl:if test="$show-cover-page-producer = 1">
          <xsl:for-each select="/codeBook/stdyDscr/citation/rspStmt/AuthEnty">
            <fo:block font-size="14pt" font-weight="bold" space-before="0.0in" text-align="center" space-after="0.0in">
              <!-- <xsl:call-template name="trim">
                <xsl:with-param name="s">
                  <xsl:value-of select="." />
                </xsl:with-param>
              </xsl:call-template> -->

              <xsl:value-of select="util:trim(.)"/>

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

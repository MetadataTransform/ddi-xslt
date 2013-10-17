<?xml version='1.0' encoding='UTF-8'?>
<!-- ========================= -->
<!-- <xsl:if> cover page       -->
<!-- value: <fo:page-sequence> -->
<!-- ========================= -->

<!-- functions: -->
<!-- normalize-space() [Xpath 1.0] -->
<!-- util:trim() [local]           -->

<xsl:if test="$show-cover-page = 'True'"
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
        <fo:block text-align="center">
          <fo:external-graphic src="{$logo-file}" />
        </fo:block>      

        <!-- title -->
        <fo:block font-size="18pt" font-weight="bold" space-before="5mm"
                  text-align="center" space-after="0.0mm">
          <xsl:value-of select="normalize-space(/codeBook/stdyDscr/citation/titlStmt/titl)" />
        </fo:block>

        <!-- ID-number -->
        <!-- <fo:block font-size="15pt" text-align="center" space-before="5mm">
          <xsl:value-of select="/codeBook/docDscr/docSrc/titlStmt/IDNo" />
        </fo:block> -->

        <!-- blank line (&#x00A0; is the equivalent of HTML &nbsp;) -->
        <fo:block white-space-treatment="preserve"> &#x00A0; </fo:block>

        <!-- responsible party(ies) -->      
        <xsl:for-each select="/codeBook/stdyDscr/citation/rspStmt/AuthEnty">
          <fo:block font-size="14pt" font-weight="bold" space-before="0.0mm"
                    text-align="center" space-after="0.0mm">
            <xsl:value-of select="util:trim(.)"/>
          </fo:block>

          <xsl:if test="@affiliation">
            <fo:block font-size="12pt" text-align="center">
              <xsl:value-of select="@affiliation" />
            </fo:block>
          </xsl:if>           
            
          <fo:block white-space-treatment="preserve" font-size="5pt"> &#x00A0; </fo:block>
            
        </xsl:for-each>
        
      </fo:block>
    </fo:flow>
  </fo:page-sequence>
</xsl:if>

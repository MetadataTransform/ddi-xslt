<?xml version='1.0' encoding='utf-8'?>
<!-- fileDscr-variables_description.xsl -->
<!-- =========================================== -->
<!-- match: fileDsrc (variables-description)     -->
<!-- value: <xsl:for-each> <fo:page-sequence>    -->
<!-- =========================================== -->

<!-- read: -->
<!-- $strings, $chunk-size, $font-family, $default-border -->

<!-- set: -->
<!-- $fileId, $fileName -->

<!-- functions: -->
<!-- position() [xpath 1.0] -->
<!-- proportional-column-width() [fo] -->

<xsl:template match="fileDscr" mode="variables-description"
              xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <!-- ================== -->
    <!-- variables          -->
    <!-- ================== -->

    <!-- fileName ID attribute / ID attribute -->
    <xsl:variable name="fileId">
      <xsl:choose>
        <xsl:when test="ddi:fileTxt/ddi:fileName/@ID">
          <xsl:value-of select="ddi:fileTxt/ddi:fileName/@ID"/>
        </xsl:when>
        <xsl:when test="@ID">
          <xsl:value-of select="@ID"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="fileName" select="ddi:fileTxt/ddi:fileName"/>

    <!-- ===================== -->
    <!-- content               -->
    <!-- ===================== -->
  
    <xsl:for-each select="/ddi:codeBook/ddi:dataDscr/ddi:var[@files=$fileId][position() mod $chunk-size = 1]">
 
      <fo:page-sequence master-reference="{$page-layout}"
                        font-family="{$font-family}"
                        font-size="{$font-size}">

        <!-- =========== -->
        <!-- page footer -->
        <!-- =========== -->
        <xsl:call-template name="page_footer" />

        <!-- =========== -->
        <!-- page body   -->
        <!-- =========== -->
        <fo:flow flow-name="body">

          <!-- [fo:table] Header -->
          <!--	 (only written if at the start of file -->
          <xsl:if test="position() = 1">
            <fo:table id="vardesc-{$fileId}" table-layout="fixed" width="100%" font-size="8pt">
              <fo:table-column column-width="proportional-column-width(100)"/> <!-- column width -->

              <!-- [fo:table-header] -->
              <fo:table-header space-after="0.2in">

                <!-- [fo:table-row] File identification -->
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-size="14pt" font-weight="bold">
                      <xsl:value-of select="$i18n-File" />
                      <xsl:text> : </xsl:text>
                      <xsl:apply-templates select="$fileName"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>

              </fo:table-header>

              <!-- [fo:table-body] Variables -->
              <fo:table-body>
                <!-- needed in case of subset -->
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block />
                  </fo:table-cell>
                </fo:table-row>
                <xsl:apply-templates select=".|following-sibling::ddi:var[@files=$fileId][$chunk-size &gt; position()]"/>
              </fo:table-body>

            </fo:table>
          </xsl:if>

          <!-- [fo:table] Variables -->
          <xsl:if test="position() &gt; 1">
            <fo:table table-layout="fixed" width="100%" font-size="8pt">
              <fo:table-body>
                <!-- needed in case of subset -->
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block/>
                  </fo:table-cell>
                </fo:table-row>
                <xsl:apply-templates select=".|following-sibling::ddi:var[@files=$fileId][$chunk-size &gt; position()]"/>
              </fo:table-body>
            </fo:table>
          </xsl:if>

        </fo:flow>
      </fo:page-sequence>
    </xsl:for-each>

</xsl:template>

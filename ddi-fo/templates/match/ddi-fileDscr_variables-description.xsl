<?xml version='1.0' encoding='utf-8'?>
<!-- ddi-fileDsrc_variables-description.xsl -->

<!-- =========================================== -->
<!-- match: ddi:fileDsrc / variables-description -->
<!-- fo:page-sequence (multiple)                 -->
<!-- =========================================== -->

<!--
  global vars read:
  $msg, $chunk-size, $font-family, $default-border

  local vars set:
  $fileId, $fileName

  XPath 1.0 functions called:
  position()

  FO functions called:
  proportional-column-width()

  templates called:
  [footer]
-->

<xsl:template match="ddi:fileDscr" mode="variables-description"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <!-- variables -->
    <xsl:variable name="fileId">
      <xsl:choose>

        <!-- fileName ID attribute -->
        <xsl:when test="ddi:fileTxt/ddi:fileName/@ID">
          <xsl:value-of select="ddi:fileTxt/ddi:fileName/@ID"/>
        </xsl:when>

        <!-- ID attribute -->
        <xsl:when test="@ID">
          <xsl:value-of select="@ID"/>
        </xsl:when>

      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="fileName" select="ddi:fileTxt/ddi:fileName"/>

    <!-- content -->
    <xsl:for-each select="/ddi:codeBook/ddi:dataDscr/ddi:var[@files=$fileId][position() mod $chunk-size = 1]">
      <fo:page-sequence master-reference="default-page" font-family="{$font-family}" font-size="10pt">

        <fo:static-content flow-name="xsl-region-after">
          <fo:block font-size="6" text-align="center" space-before="0.3in">
            - <fo:page-number /> -
          </fo:block>
        </fo:static-content>

        <fo:flow flow-name="xsl-region-body">

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
                      <xsl:value-of select="$msg/*/entry[@key='File']"/>
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
          <xsl:if test="position()&gt;1">
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
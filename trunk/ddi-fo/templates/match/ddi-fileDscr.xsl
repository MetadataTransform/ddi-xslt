<?xml version='1.0' encoding='utf-8'?>
<!-- =========================== -->
<!-- match: ddi:fileDsrc         -->
<!-- value: <fo:table>           -->
<!-- =========================== -->

<!-- read: -->
<!-- $strings, $color-gray1, $default-border, $cell-padding -->

<!-- set: -->
<!-- $fileId, $list -->

<!-- functions: -->
<!-- concat(), contains(), normalize-space(), position() [Xpath 1.0] -->
<!-- proportional-column-width() [FO] -->

<xsl:template match="ddi:fileDscr"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <!-- ===================== -->
    <!-- variables             -->
    <!-- ===================== -->
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

    <!-- =================== -->
    <!-- content             -->
    <!-- =================== -->
    <fo:table id="file-{$fileId}" table-layout="fixed"
              width="100%" space-before="0.2in" space-after="0.2in">
      <fo:table-column column-width="proportional-column-width(20)" />
      <fo:table-column column-width="proportional-column-width(80)" />

      <fo:table-body>

        <!-- 1) Filename -->
        <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
          <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
            <fo:block font-size="12pt" font-weight="bold">
              <xsl:apply-templates select="ddi:fileTxt/ddi:fileName"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>

        <!-- 2) Cases -->
        <xsl:if test="ddi:fileTxt/ddi:dimensns/ddi:caseQnty">
          <fo:table-row>
            <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
              <fo:block>#
                <xsl:value-of select="$strings/*/entry[@key='Cases']"/>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
              <xsl:apply-templates select="ddi:fileTxt/ddi:dimensns/ddi:caseQnty"/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:if>

        <!-- 3) Variables -->
        <xsl:if test="ddi:fileTxt/ddi:dimensns/ddi:varQnty">
          <fo:table-row>
            <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
              <fo:block>#
                <xsl:value-of select="$strings/*/entry[@key='Variables']"/>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
              <xsl:apply-templates select="ddi:fileTxt/ddi:dimensns/ddi:varQnty"/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:if>

        <!-- 4) File structure -->
        <xsl:if test="ddi:fileTxt/ddi:fileStrc">
          <fo:table-row>

            <!-- 4.1) File_Structure -->
            <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
              <fo:block>
                <xsl:value-of select="$strings/*/entry[@key='File_Structure']"/>
              </fo:block>
            </fo:table-cell>

            <!-- 4.2) Type -->
            <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
              <xsl:if test="ddi:fileTxt/ddi:fileStrc/@type">
                <fo:block>
                  <xsl:value-of select="$strings/*/entry[@key='Type']"/>:
                  <xsl:value-of select="ddi:fileTxt/ddi:fileStrc/@type"/>
                </fo:block>
              </xsl:if>

              <xsl:if test="ddi:fileTxt/ddi:fileStrc/ddi:recGrp/@keyvar">
                <fo:block>
                  <xsl:value-of select="$strings/*/entry[@key='Keys']"/>:&#160;
                  <xsl:variable name="list" select="concat(ddi:fileTxt/ddi:fileStrc/ddi:recGrp/@keyvar,' ')"/>
                  <!-- add a space at the end of the list for matching puspose -->
                  <xsl:for-each select="/ddi:codeBook/ddi:dataDscr/ddi:var[contains($list,concat(@ID,' '))]">
                    <!-- add a space to the variable ID to avoid partial match -->
                    <xsl:if test="position()&gt;1">,&#160;</xsl:if>
                    <xsl:value-of select="./@name"/>
                    <xsl:if test="normalize-space(./ddi:labl)">
											&#160;(
                      <xsl:value-of select="normalize-space(./ddi:labl)"/>)
                    </xsl:if>
                  </xsl:for-each>
                </fo:block>
              </xsl:if>

            </fo:table-cell>
          </fo:table-row>
        </xsl:if>

        <!-- 5) File_Content -->
        <xsl:for-each select="ddi:fileTxt/ddi:fileCont">
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-weight="bold" text-decoration="underline">
                <xsl:value-of select="$strings/*/entry[@key='File_Content']"/>
              </fo:block>
              <xsl:apply-templates select="."/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>

        <!-- 6) Producer -->
        <xsl:for-each select="ddi:fileTxt/ddi:filePlac">
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-weight="bold" text-decoration="underline">
                <xsl:value-of select="$strings/*/entry[@key='Producer']"/>
              </fo:block>
              <xsl:apply-templates select="."/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>

        <!-- 7) Version -->
        <xsl:for-each select="ddi:fileTxt/ddi:verStmt">
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-weight="bold" text-decoration="underline">
                <xsl:value-of select="$strings/*/entry[@key='Version']"/>
              </fo:block>
              <xsl:apply-templates select="."/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>

        <!-- 8) Processing_Checks -->
        <xsl:for-each select="ddi:fileTxt/ddi:dataChck">
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-weight="bold" text-decoration="underline">
                <xsl:value-of select="$strings/*/entry[@key='Processing_Checks']"/>
              </fo:block>
              <xsl:apply-templates select="."/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>

        <!-- 9) Missing_Data -->
        <xsl:for-each select="ddi:fileTxt/ddi:dataMsng">
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-weight="bold" text-decoration="underline">
                <xsl:value-of select="$strings/*/entry[@key='Missing_Data']"/>
              </fo:block>
              <xsl:apply-templates select="."/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>

        <!-- 10) Notes -->
        <xsl:for-each select="ddi:notes">
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-weight="bold" text-decoration="underline">
                <xsl:value-of select="$strings/*/entry[@key='Notes']"/>
              </fo:block>
              <xsl:apply-templates select="."/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>

      </fo:table-body>
    </fo:table>

</xsl:template>

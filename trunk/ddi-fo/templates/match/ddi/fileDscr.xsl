<?xml version='1.0' encoding='utf-8'?>
<!-- fileDscr.xsl -->
<!-- =========================== -->
<!-- match: fileDsrc             -->
<!-- value: <fo:table>           -->
<!-- =========================== -->

<!-- read: -->
<!-- $color-gray1, $default-border, $cell-padding -->

<!-- set: -->
<!-- $fileId, $list -->

<!-- functions: -->
<!-- concat(), contains(), normalize-space(), position() [Xpath 1.0] -->
<!-- proportional-column-width() [FO] -->

<xsl:template match="fileDscr"
              xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format"> 

    <!-- ===================== -->
    <!-- variables             -->
    <!-- ===================== -->
    <xsl:variable name="fileId">
      <xsl:choose>

        <xsl:when test="fileTxt/fileName/@ID">
          <xsl:value-of select="fileTxt/fileName/@ID"/>
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

        <!-- Filename -->
        <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
          <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
            <fo:block font-size="12pt" font-weight="bold">
              <xsl:apply-templates select="fileTxt/fileName"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>

        <!-- Cases -->
        <xsl:if test="fileTxt/dimensns/caseQnty">
          <fo:table-row>
            <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
              <fo:block>
                <xsl:value-of select="$i18n-Cases" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
              <xsl:apply-templates select="fileTxt/dimensns/caseQnty"/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:if>

        <!-- Variables -->
        <xsl:if test="fileTxt/dimensns/varQnty">
          <fo:table-row>
            <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
              <fo:block>
                <xsl:value-of select="$i18n-Variables" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
              <xsl:apply-templates select="fileTxt/dimensns/varQnty"/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:if>

        <!-- File structure -->
        <xsl:if test="fileTxt/fileStrc">
          <fo:table-row>

            <!-- 4.1) File_Structure -->
            <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
              <fo:block>
                <xsl:value-of select="$i18n-File_Structure" />
              </fo:block>
            </fo:table-cell>

            <!-- 4.2) Type -->
            <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
              <xsl:if test="fileTxt/fileStrc/@type">
                <fo:block>
                  <xsl:value-of select="$i18n-Type" />
                  <xsl:text>:</xsl:text>
                  <xsl:value-of select="fileTxt/fileStrc/@type"/>
                </fo:block>
              </xsl:if>

              <xsl:if test="fileTxt/fileStrc/recGrp/@keyvar">
                <fo:block>
                  <xsl:value-of select="$i18n-Keys" />
                  <xsl:text>:&#160;</xsl:text>
                  <xsl:variable name="list" select="concat(fileTxt/fileStrc/recGrp/@keyvar,' ')" />

                  <!-- add a space at the end of the list for matching puspose -->
                  <xsl:for-each select="/codeBook/dataDscr/var[contains($list, concat(@ID,' '))]">
                    <!-- add a space to the variable ID to avoid partial match -->
                    <xsl:if test="position() &gt; 1">
                      <xsl:text>,&#160;</xsl:text>
                    </xsl:if>
                    <xsl:value-of select="./@name"/>
                    <xsl:if test="normalize-space(./labl)">
											<xsl:text>&#160;(</xsl:text>
                      <xsl:value-of select="normalize-space(./labl)"/>
                      <xsl:text>)</xsl:text>
                    </xsl:if>
                  </xsl:for-each>
                </fo:block>
              </xsl:if>

            </fo:table-cell>
          </fo:table-row>
        </xsl:if>

        <!-- File_Content -->
        <xsl:for-each select="fileTxt/fileCont">
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-weight="bold" text-decoration="underline">
                <xsl:value-of select="$i18n-File_Content" />
              </fo:block>
              <xsl:apply-templates select="."/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>

        <!-- Producer -->
        <xsl:for-each select="fileTxt/filePlac">
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-weight="bold" text-decoration="underline">
                <xsl:value-of select="$i18n-Producer" />
              </fo:block>
              <xsl:apply-templates select="."/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>

        <!-- Version -->
        <xsl:for-each select="fileTxt/verStmt">
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-weight="bold" text-decoration="underline">
                 <xsl:value-of select="$i18n-Version" />
              </fo:block>
              <xsl:apply-templates select="."/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>

        <!-- Processing_Checks -->
        <xsl:for-each select="fileTxt/dataChck">
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-weight="bold" text-decoration="underline">
                <xsl:value-of select="$i18n-Processing_Checks" />
              </fo:block>
              <xsl:apply-templates select="."/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>

        <!-- Missing_Data -->
        <xsl:for-each select="fileTxt/dataMsng">
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-weight="bold" text-decoration="underline">
                <xsl:value-of select="$i18n-Missing_Data" />
              </fo:block>
              <xsl:apply-templates select="."/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>

        <!-- Notes -->
        <xsl:for-each select="notes">
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-weight="bold" text-decoration="underline">
                <xsl:value-of select="$i18n-Notes" />
              </fo:block>
              <xsl:apply-templates select="."/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>

      </fo:table-body>
    </fo:table>

</xsl:template>

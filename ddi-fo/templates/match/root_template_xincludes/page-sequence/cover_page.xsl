<?xml version='1.0' encoding='UTF-8'?>
<!-- cover_page.xsl -->
<!-- ========================= -->
<!-- <xsl:if> cover page       -->
<!-- value: <fo:page-sequence> -->
<!-- ========================= -->

<!-- functions: -->
<!-- normalize-space() [Xpath 1.0] -->
<!-- util:trim() [local]           -->

<xsl:if test="$page.cover.show = 'True'"
        xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:page-sequence master-reference="{$layout.page_master}"
                    font-family="Helvetica"
                    font-size="{$layout.font_size}">

    <!-- =========================================== -->
    <!-- page content                                -->
    <!-- =========================================== -->

    <fo:flow flow-name="body">

      <fo:block id="cover-page">

        <!-- top logo -->
        <fo:block text-align="center">
          <fo:external-graphic src="{$layout.logo_file}" />
        </fo:block>

        <!-- This is the small logos in the lower left and right corner: -->
        <!-- either replace them or remove/comment them out. You can -->
        <!-- uncomment the placeholder logos for experimenting. -->
               
        <!-- left corner logo (using Swedish Research Council graphic) -->
        <fo:block-container absolute-position="fixed" top="248mm" left="20mm">
          <fo:block>            
            <fo:external-graphic src="{$layout.left_bottom_logo_file}" content-height="33mm" scaling="uniform"/>
          </fo:block>        
        </fo:block-container>
        
        <!-- right corner logo (using Gothenburg University graphic) -->
        <fo:block-container absolute-position="fixed" top="250mm" left="150mm">
          <fo:block>
            <fo:external-graphic src="{$layout.right_bottom_logo_file}" content-height="25mm" scaling="uniform"/>
          </fo:block>
        </fo:block-container>

        <!-- left corner logo (using placeholder graphic) -->
        <!-- <fo:block-container absolute-position="fixed" top="250mm" left="20mm">
          <fo:block>
            <fo:external-graphic src="../images/placeholder_corner_logo.png" content-height="33mm" scaling="uniform"/>
          </fo:block>        
        </fo:block-container> -->
        
        <!-- right corner logo (using placeholder graphic) -->
        <!-- <fo:block-container absolute-position="fixed" top="250mm" left="150mm">
          <fo:block>
            <fo:external-graphic src="../images/placeholder_corner_logo.png" content-height="33mm" scaling="uniform"/>
          </fo:block>
        </fo:block-container> -->
 
        <!-- blank line ('&#x00A0;' is the equivalent of HTML '&nbsp;') -->
        <fo:block white-space-treatment="preserve" font-size="60pt"> &#x00A0; </fo:block>

        <!-- title -->
        <fo:block font-size="20pt" font-weight="bold" space-before="5mm" text-align="center" space-after="0.0mm">
          <xsl:value-of select="normalize-space(/codeBook/stdyDscr/citation/titlStmt/titl)" />
        </fo:block>

        <!-- blank line -->
        <fo:block white-space-treatment="preserve" font-size="25pt"> &#x00A0; </fo:block>

        <!-- responsible part(ies) -->      
        <xsl:for-each select="/codeBook/stdyDscr/citation/rspStmt/AuthEnty">
          <fo:block font-size="14pt" font-weight="bold" space-before="0.0mm" text-align="center" space-after="0.0mm">
            <xsl:value-of select="util:trim(.)" />
          </fo:block>

          <xsl:if test="@affiliation">
            <fo:block font-size="12pt" text-align="center">
              <xsl:value-of select="@affiliation" />
            </fo:block>
          </xsl:if>           
          
          <!-- blank line -->
          <fo:block white-space-treatment="preserve" font-size="5pt"> &#x00A0; </fo:block>
            
        </xsl:for-each>
        
      </fo:block>
                     
    </fo:flow>
  </fo:page-sequence>
</xsl:if>

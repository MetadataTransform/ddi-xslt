<?xml version='1.0' encoding='utf-8'?>
<!-- match: ddi:*|text() -->
<!-- value: <fo:block> / [-] -->
<!-- the default text -->

<!--
  Variables set:
  trimmed

  Functions/templates called:
  trim
-->

<xsl:template match="ddi:*|text()"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <!-- variables -->
  <xsl:variable name="trimmed">
    <xsl:call-template name="trim">
      <xsl:with-param name="s" select="." />
    </xsl:call-template>
  </xsl:variable>

  <!-- content -->
  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0in">
    <xsl:value-of select="$trimmed"/>
  </fo:block>

</xsl:template>

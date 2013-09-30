<?xml version='1.0' encoding='utf-8'?>
<!-- Match: ddi:fileName -->
<!-- Value: filename minus .NSDstat extension -->

<!--
  Variables set:
  filename

  Functions/templates called:
  contains(), normalize-space(), string-length(), substring()
-->

<xsl:template match="ddi:fileName"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <!-- variables -->
    <xsl:variable name="filename" select="normalize-space(.)" />

    <!-- content -->
    <xsl:choose>

      <!-- case: filename contains .NSDstat-->
      <xsl:when test=" contains( $filename , '.NSDstat' )">
        <xsl:value-of select="substring($filename, 1, string-length($filename)-8)" />
      </xsl:when>

      <!-- does not contain .NSDstat -->
      <xsl:otherwise>
        <xsl:value-of select="$filename" />
      </xsl:otherwise>

    </xsl:choose>

</xsl:template>

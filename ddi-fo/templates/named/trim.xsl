<?xml version='1.0' encoding='utf-8'?>
<!-- =================== -->
<!-- name: trim          -->
<!-- value: string       -->
<!-- =================== -->

<!-- read: -->
<!-- $string [param] -->

<!-- functions: -->
<!-- concat(), substring(), translate(), substring-after() [Xpath 1.0] -->

<!-- called: -->
<!-- rtrim -->

<xsl:template name="trim"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <!-- params -->
    <xsl:param name="s" />

    <!-- perform trimming (from right)-->
    <xsl:call-template name="rtrim">
      <xsl:with-param name="s" select="concat(substring(translate($s ,' &#x9;&#xA;&#xD;',''), 1, 1),
                                       substring-after($s, substring(translate($s, ' &#x9;&#xA;&#xD;', ''), 1, 1)))" />
    </xsl:call-template>

</xsl:template>

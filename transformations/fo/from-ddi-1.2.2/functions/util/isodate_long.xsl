<?xml version='1.0' encoding='utf-8'?>
<!-- util-isodate_long.xsl -->

<!-- ============================================= -->
<!-- xs:string util:isodate-long(xs:date isodate)  -->
<!-- ============================================= -->

<!-- converts an ISO date string to a "prettier" format -->

<!-- read: -->
<!-- $language-code -->

<!-- called: -->
<!-- substring(), contains() [Xpath 1.0] -->
<!-- util:isodate_month_name() [local] -->


<xsl:function name="util:isodate_long" as="xs:string"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:param name="isodate" as="xs:string" />


  <!-- determine local date-format from $language-code string -->
  <xsl:value-of select="
    (: european format :)
    if (contains('fr es', $i18n.language_code)) then
      concat(substring($isodate, 9, 2), ' ', util:isodate_month_name($isodate), ' ', substring($isodate, 1, 4))
    (: japanese format :)
    else if (contains('ja', $i18n.language_code)) then
      $isodate
    (: english format :)
    else concat(util:isodate_month_name($isodate), ' ', substring($isodate, 9, 2), ' ', substring($isodate, 1, 4)) "/>

</xsl:function>

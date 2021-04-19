<?xml version="1.0" encoding="UTF-8"?>
<!-- util-isodate_month_name.xsl -->

<!-- ========================================================= -->
<!-- xs:string util:isodate_month_name(xs:string isodate)      -->
<!-- ========================================================= -->

<!-- returns month name from a ISO-format date string -->

<!-- set: -->
<!-- $month, $month_string -->

<!-- functions: -->
<!-- number(), substring() [Xpath 1.0] -->

<xsl:function name="util:isodate_month_name" as="xs:string"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:param name="isodate" as="xs:string" /> 
  

  <!-- extract month number from date string -->
  <xsl:variable name="month" select="number(substring($isodate, 6, 2))"/>
  
  <!-- determine month name -->
  <xsl:variable name="month_string" select="
    if ($month = 1) then i18n:get('January')
    else if ($month = 2) then i18n:get('February')
    else if ($month = 3) then i18n:get('March')
    else if ($month = 4) then i18n:get('April')
    else if ($month = 5) then i18n:get('May')
    else if ($month = 6) then i18n:get('June')
    else if ($month = 7) then i18n:get('July')
    else if ($month = 8) then i18n:get('August')
    else if ($month = 9) then i18n:get('September')
    else if ($month = 10) then i18n:get('October')
    else if ($month = 11) then i18n:get('November')
    else if ($month = 12) then i18n:get('December')
    else ()  "/>


  <!-- return value -->
  <xsl:value-of select="$month_string" />
  
</xsl:function>
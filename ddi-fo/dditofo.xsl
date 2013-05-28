<?xml version='1.0' encoding='utf-8'?>
<!-- dditofo.xsl -->

<!--
	Overview:
	Transforms DDI-XML into XSL-FO to produce study documentation in PDF format
	Developed for DDI documents produced by the International Household Survey Network
	Microdata Managemenet Toolkit (http://www.surveynetwork.org/toolkit) and
	Central Survey Catalog (http://www.surveynetwork.org/surveys)

	Author: Pascal Heus (pascal.heus@gmail.com)
	Version: July 2006
	Platform: XSL 1.0, Apache FOP 0.20.5 (http://xmlgraphics.apache.org/fop)

	Updated for FOP 0.93 2010 - oistein.kristiansen@nsd.uib.no


	License:
	Copyright 2006 Pascal Heus (pascal.heus@gmail.com)

	This program is free software; you can redistribute it and/or modify it under the terms of the
	GNU Lesser General Public License as published by the Free Software Foundation; either version
	2.1 of the License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
	without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
	See the GNU Lesser General Public License for more details.

 	The full text of the license is available at http://www.gnu.org/copyleft/lesser.html


  References:
    XSL-FO:
      http://www.w3.org/Style/XSL/
      http://www.w3schools.com/xslfo/xslfo_reference.asp
      http://www.xslfo.info/
    Apache FOP:
      http://xmlgraphics.apache.org/fop/
    XSL-FO Tutorials:
      http://www.renderx.com/tutorial.html
      http://www.antennahouse.com/XSLsample/XSLsample.htm
    String trimming:
      http://skew.org/xml
-->

<!--
  2006-04:    Added multilingual support and French translation
  2006-06:    Added Spanish and new elements to match IHSN Template v1.2
  2006-07:    Minor fixes and typos
  2006-07:    Added option parameters to hide producers in cover page and questions in variables list page
  2010-03:    Made FOP 0.93 compatible
  2012-11-01: Broken up into parts using xsl:include
  2013-01-22: Changing the file names to match template names better
-->

<xsl:stylesheet xmlns:n1="http://www.icpsr.umich.edu/DDI"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ddi="http://www.icpsr.umich.edu/DDI"
                xmlns:date="http://exslt.org/dates-and-times"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:exsl="http://exslt.org/common"
                xmlns:math="http://exslt.org/math"
                xmlns:str="http://exslt.org/strings"
                xmlns:doc="http://www.icpsr.umich.edu/doc"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                version="1.0"
                extension-element-prefixes="date exsl str">

  <xsl:output version="1.0" encoding="UTF-8" indent="no"
              omit-xml-declaration="no" media-type="text/html"/>

  <!-- Setup global vars and parameters -->
  <xsl:include href='includes/config.xsl' />

  <!-- Templates -->
  <xi:include href="includes/root_template.xml" />

  <!-- templates matching the ddi: namespace -->
  <xi:include href="includes/ddi/ddi-AuthEnty.xml" />
  <xi:include href="includes/ddi/ddi-collDate.xml" />

  <xi:include href="includes/ddi/ddi-contact.xml" />
  <xi:include href="includes/ddi/ddi-dataCollector.xml" />
  <xi:include href="includes/ddi/ddi-fileDscr.xml" />
  <xi:include href="includes/ddi/ddi-fileDscr_variables-description.xml" />
  <xi:include href="includes/ddi/ddi-fileDscr_variables-list.xml" />
  <xi:include href="includes/ddi/ddi-fileName.xml" />
  <xi:include href="includes/ddi/ddi-fundAg.xml" />
  <xi:include href="includes/ddi/ddi-IDNo.xml" />
  <xi:include href="includes/ddi/ddi-othId.xml" />
  <xi:include href="includes/ddi/ddi-producer.xml" />
  <xi:include href="includes/ddi/ddi-timePrd.xml" />
  <xi:include href="includes/ddi/ddi-var.xml" />
  <xi:include href="includes/ddi/ddi-var_variablesList.xml" />
  <xi:include href="includes/ddi/ddi-varGrp.xml" />
  <xi:include href="includes/ddi/ddi_default_text.xml" />

  <!-- templates matching the rdf: namespace -->
  <xi:include href="includes/rdf/rdf-Description.xml" />

  <!-- Named templates -->
  <xi:include href='includes/named/documentation-toc-section.xml' />
  <xi:include href='includes/named/variables-table-col-header.xml' />
  <xi:include href='includes/named/variables-table-col-width.xml' />
  <xi:include href="includes/named/header.xml" />
  <xi:include href="includes/named/footer.xml" />

  <!-- Utility templates -->
  <xi:include href="includes/utilities/isodate-long.xml" />
  <xi:include href="includes/utilities/isodate-month.xml" />
  <xi:include href="includes/utilities/trim/ltrim.xml" />
  <xi:include href="includes/utilities/trim/rtrim.xml" />
  <xi:include href="includes/utilities/trim/trim.xml" />
  <xi:include href='includes/utilities/FixHTML.xml' />
  <xi:include href="includes/utilities/date-date.xml" />
  <xi:include href="includes/utilities/math-max.xml" />

</xsl:stylesheet>

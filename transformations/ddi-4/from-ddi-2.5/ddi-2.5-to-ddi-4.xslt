<!--

Description:
XSLT Stylesheet for conversion between DDI-C version 2.5 and DDI Lifecycle 4

Authors: Alicia Urquidi Diaz <alicia.urquidi@utoronto.ca>, Lucas Bourcier <email>
Version: March 2013

This file is free software: you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation, either
version 3 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library.  If not, see <http://www.gnu.org/licenses/>.

-->


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:foaf="http://xmlns.com/foaf/0.1"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:adms="http://www.w3.org/ns/adms#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:locn="http://www.w3.org/ns/locn#"
  xmlns:prov="http://www.w3.org/ns/prov#"
  xmlns:schema="http://schema.org"
  xmlns:odrs="http://schema.theodi.org/odrs"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:dct="http://purl.org/dc/terms/"
  xmlns:c="ddi:codebook:2_5"
  xmlns:ddi="ddi:instance:4_0"
  xmlns:meta="transformation:metadata"
  xsi:schemaLocation="ddi:codebook:2_5 http://www.ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/codebook.xsd"
<meta:metadata>
      <identifier>ddi-2.5-to-ddi-4</identifier>
      <title>DDI 2.5 to DDI Lifecycle 4</title>
      <description>Convert DDI Codebook (2.5) to DDI Lifecycle 4</description>
      <outputFormat>XML</outputFormat>
      <parameters>
        <parameter name="root-element" format="xs:string" description="Root element"/>
      </parameters>
    </meta:metadata>
 
    <xsl:output method="xml" indent="yes" />
<xsl:stylesheet   
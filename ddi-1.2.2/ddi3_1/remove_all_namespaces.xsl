<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output indent="yes" method="xml" encoding="utf-8" omit-xml-declaration="no"/>

    <!-- 
        Stylesheet to remove all namespaces from a document. 
        Based on: http://stackoverflow.com/a/5875074

        Nodes that cannot have a namespace are copied as such.

        Note: This will lead to attribute name clash, if an element contains
        two attributes with same local name but different namespace prefix.        
    -->

    <!-- template to copy elements -->
    <xsl:template match="*">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>

    <!-- template to copy attributes -->
    <xsl:template match="@*">
        <xsl:attribute name="{local-name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <!-- template to copy the rest of the nodes -->
    <xsl:template match="comment() | text() | processing-instruction()">
        <xsl:copy/>
    </xsl:template>
</xsl:stylesheet>

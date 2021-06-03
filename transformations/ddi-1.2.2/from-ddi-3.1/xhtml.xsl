<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns="http://xcri.org/profiles/catalog"
    xmlns:s="ddi:studyunit:3_1" xmlns:r="ddi:reuseable:3_1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:xhtml="http://www.w3.org/1999/xhtml">
    <xsl:import href="copy.xsl"/>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <!--
    Temple to transform xhtml
    
    Is dirived work of Tavis Reddick, Adam Smith College, tavisreddick@adamsmith.ac.uk
    
    This work is licenced under the Creative Commons Attribution 3.0 Unported License.
    To view a copy of this licence, visit http://creativecommons.org/licenses/by/3.0/ or send
    a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California 94105, USA.
    -->
    
    <!--xsl:strip-space elements="*" /-->
    
    <!-- param for bulletlist character -->
    <xsl:param name="bullet" select="'&#x2022;'"/>
    
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
        </xsl:template>
    <xsl:template match="xhtml:div | xhtml:p | xhtml:h1 | xhtml:h2 | xhtml:h3 | xhtml:h4 | xhtml:h5">
        <!-- For each block text item, replace with linebreak-content-linebreak. -->
        <!--xsl:value-of select="." /-->
        <xsl:text>&#xa;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>
    <xsl:template match="xhtml:ul | xhtml:ol">
        <!-- For each unordered or ordered list, apply templates and add opening and closing linebreaks. -->
        <xsl:text>&#xa;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>
    <xsl:template match="xhtml:span[./text()] | xhtml:strong | xhtml:u">
        <!-- For each span containing text, strong emphases or underlines, lose the element and apply templates. -->
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="xhtml:span[./*]">
        <!-- For each span containing other elements, apply templates and add a closing linebreak. -->
        <xsl:apply-templates/>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>
    <xsl:template match="xhtml:a | xhtml:font">
        <!-- For inline elements like a and font, replace elements by applying templates. -->
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="xhtml:li[parent::xhtml:ul]">
        <!-- For each unordered list item, replace with bullet-tab-content-linebreak. -->
        <xsl:value-of select="$bullet"/>
        <xsl:text>&#x9;</xsl:text>
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>
    <xsl:template match="xhtml:li[parent::xhtml:ol]">
        <!-- For each ordered list item, replace with number-tab-content-linebreak. -->
        <xsl:value-of select="position()"/>
        <xsl:text>&#x9;</xsl:text>
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>
    <xsl:template match="xhtml:br">
        <!-- For each break element, replace with a linebreak. -->
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>
    <!-- Remove empty XHTML elements. -->
    <xsl:template
        match="xhtml:*[normalize-space(.) = ' ' or normalize-space(.) = ''][not(self::xhtml:br)]"/>
</xsl:stylesheet>

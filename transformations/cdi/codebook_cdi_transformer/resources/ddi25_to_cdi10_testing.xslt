<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xml="http://www.w3.org/XML/1998/namespace"
xmlns:meta="transformation:metadata"
xmlns:c="ddi:codebook:2_5"
xmlns:ddi="http://www.ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/codebook.xsd"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:cdi="https://ddi-alliance.bitbucket.io/DDI-CDI/DDI-CDI_2022-10-06/encoding/xsd/DDI-CDI_1-0.xsd"
version="2.0"
exclude-result-prefixes="#all">

    <meta:metadata>
        <identifier>ddi-c-2.5-to-ddi-cdi-1.0</identifier>
        <title>DDI-C 2.5 to DDI-CDI 1.0</title>
        <description>Convert DDI-Codebook (2.5) to DDI-CDI (1.0)</description>
        <outputFormat>XML</outputFormat>
    </meta:metadata>

    <xsl:output indent="yes" omit-xml-declaration="yes" />

    <xsl:template match="c:codeBook">
        <cdi:DDICDIModels xmlns:cdi="https://ddi-alliance.bitbucket.io/DDI-CDI/DDI-CDI_2022-10-06/encoding/xsd/DDI-CDI_1-0.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="https://ddi-alliance.bitbucket.io/DDI-CDI/DDI-CDI_2022-10-06/encoding/xsd/DDI-CDI_1-0.xsd https://ddi-alliance.bitbucket.io/DDI-CDI/DDI-CDI_2022-10-06/encoding/xsd/DDI-CDI_1-0.xsd">
            <cdi:WideDataStructure>
                <cdi:identifier>
                    <xsl:for-each select="c:stdyDscr/c:citation/c:titlStmt/c:IDNo">
                        <xsl:choose>
                            <!-- @agency should only contain values from https://vocabularies.cessda.eu/vocabulary/CessdaPersistentIdentifierTypes?lang=en but sometimes also has values such as datacite (which means DOI) -->
                            <xsl:when test="@agency='ARK' or @agency='DOI' or @agency='Handle' or @agency='URN' or @agency='datacite'">
                                WDS_<xsl:value-of select="text()" />
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </cdi:identifier>
                <cdi:WideDataSet>
                    <!-- CatalogDetails -->
                    <cdi:catalogDetails>
                        <cdi:title>
                            <xsl:choose>
                                <xsl:when test="c:stdyDscr/c:citation/c:titlStmt/c:titl">
                                    <xsl:value-of select="c:stdyDscr/c:citation/c:titlStmt/c:titl"/>
                                </xsl:when>
                                <xsl:when test="c:stdyDscr/c:citation/c:titlStmt/c:parTitl">
                                    <xsl:value-of select="c:stdyDscr/c:citation/c:titlStmt/c:parTitl"/>
                                </xsl:when>
                            </xsl:choose>
                        </cdi:title>
                        <cdi:abstract>
                            <xsl:value-of select="c:stdyDscr/c:stdyInfo/c:abstract"/>
                        </cdi:abstract>
                        <xsl:copy-of select="meta:getIfExists('accessRights', c:stdyDscr/c:dataAccs/c:useStmt/c:restrctn)" />
                    </cdi:catalogDetails>
                    <!-- RepresentedVariable -->
                    <xsl:for-each select="c:dataDscr/c:var">
                        <xsl:element name="cdi:RepresentedVariable">
                            <xsl:element name="cdi:identifier">
                                RV_<xsl:value-of select="@ID" />
                            </xsl:element>
                            <xsl:element name="cdi:descriptiveText">
                                <xsl:value-of select="c:labl" />
                            </xsl:element>
                            <xsl:element name="cdi:testingIncrementalId">
                                <xsl:value-of select="position()" />
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </cdi:WideDataSet>
            </cdi:WideDataStructure>
        </cdi:DDICDIModels>
    </xsl:template>

    <xsl:function name="meta:getIfExists">
        <xsl:param name="cdiname" />
        <xsl:param name="element" />
        <xsl:for-each select="$element">
            <xsl:element name="cdi:{$cdiname}">
                <xsl:value-of select="text()"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:function>
    <xsl:function name="meta:getLangEn">
        <xsl:param name="element" />
        <xsl:for-each select="$element">         
            <xsl:choose>
                <xsl:when test="@xml:lang='en'">
                    <xsl:value-of select="text()"/>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:function>
    <xsl:function name="meta:getLangEnIfExists">
        <xsl:param name="cdiname" />
        <xsl:param name="element" />
        <xsl:for-each select="$element">
            <xsl:choose>
                <xsl:when test="@xml:lang='en'">
                    <xsl:element name="cdi:{$cdiname}">
                        <xsl:value-of select="text()"/>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:function>
    <xsl:function name="meta:getLangEnByAttribute">
        <xsl:param name="element" />
        <xsl:param name="attribute" />
        <xsl:for-each select="$element">
            <xsl:choose>
                <xsl:when test="@xml:lang='en'">
                    <xsl:value-of select="@*[name() = $attribute]" />
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:function>
</xsl:stylesheet>
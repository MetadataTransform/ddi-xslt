<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:g="ddi:group:3_1" xmlns:d="ddi:datacollection:3_1" xmlns:dce="ddi:dcelements:3_1"
    xmlns:c="ddi:conceptualcomponent:3_1" xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:a="ddi:archive:3_1" xmlns:m1="ddi:physicaldataproduct/ncube/normal:3_1"
    xmlns:ddi="ddi:instance:3_1" xmlns:m2="ddi:physicaldataproduct/ncube/tabular:3_1"
    xmlns:l="ddi:logicalproduct:3_1" xmlns:m3="ddi:physicaldataproduct/ncube/inline:3_1"
    xmlns:pd="ddi:physicaldataproduct:3_1" xmlns:cm="ddi:comparative:3_1"
    xmlns:s="ddi:studyunit:3_1" xmlns:r="ddi:reusable:3_1" xmlns:pi="ddi:physicalinstance:3_1"
    xmlns:ds="ddi:dataset:3_1" xmlns:pr="ddi:profile:3_1"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:util="https://code.google.com/p/ddixslt/#util" version="2.0"
    xsi:schemaLocation="ddi:instance:3_1 http://www.ddialliance.org/sites/default/files/schema/ddi3.1/instance.xsd">

        <xsl:template match="/ddi:DDIInstance">
            <username-codes>
                <xsl:for-each select="s:StudyUnit/l:LogicalProduct/l:VariableScheme/l:Variable">
                <result>
                    <username>
                        <xsl:value-of select="l:VariableName"/>
                    </username>
                    <nbrcodes>
                        <xsl:variable name="codeSchemeRef"
                            select="l:Representation/l:CodeRepresentation/r:CodeSchemeReference/r:ID"/>
                        <xsl:for-each select="../../l:CodeScheme">
                            <xsl:if test="@id=$codeSchemeRef">
                                <xsl:value-of select="count(l:Code)"/>
                            </xsl:if>
                        </xsl:for-each>
                    </nbrcodes>
                </result>
            </xsl:for-each>
            </username-codes>
        </xsl:template>

</xsl:stylesheet>

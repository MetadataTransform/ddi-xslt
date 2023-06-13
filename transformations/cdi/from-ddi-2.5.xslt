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
            <cdi:WideDataSet>
                <cdi:catalogDetails>
                    <cdi:publisher></cdi:publisher>
                    <cdi:title>
                        <cdi:languageSpecificString>
                            <cdi:content></cdi:content>
                        </cdi:languageSpecificString>
                    </cdi:title>
                </cdi:catalogDetails>
                <cdi:identifier>
                    <cdi:ddiIdentifier>
                        <cdi:dataIdentifier>
                            WDS_<xsl:value-of select="c:docDscr/c:citation/c:titlStmt/c:IDNo"/>
                        </cdi:dataIdentifier>
                        <cdi:registrationAuthorityIdentifier>
                            <xsl:value-of select="c:docDscr/c:citation/c:titlStmt/c:IDNo/@agency"/>
                        </cdi:registrationAuthorityIdentifier>
                    </cdi:ddiIdentifier>
                </cdi:identifier>
                <cdi:DataSet_isStructuredBy_DataStructure-Target>
                <cdi:uri>
                    <xsl:value-of select="c:docDscr/c:citation/c:titlStmt/c:IDNo/@agency"/>:WDSt_<xsl:value-of select="c:docDscr/c:citation/c:titlStmt/c:IDNo"/>:<xsl:value-of select="c:stdyDscr/c:citation/c:verStmt/c:version"/>
                </cdi:uri>
                <cdi:typeOfClass>WideDataStructure</cdi:typeOfClass>
                <cdi:versionIdentifier><xsl:value-of select="c:stdyDscr/c:citation/c:verStmt/c:version"/></cdi:versionIdentifier>
                </cdi:DataSet_isStructuredBy_DataStructure-Target>
            </cdi:WideDataSet>
            <cdi:WideDataStructure>
                <cdi:identifier>
                    <cdi:ddiIdentifier>
                        <cdi:dataIdentifier>WDSt_<xsl:value-of select="c:docDscr/c:citation/c:titlStmt/c:IDNo"/></cdi:dataIdentifier>
                        <cdi:registrationAuthorityIdentifier>
                            <xsl:value-of select="c:docDscr/c:citation/c:titlStmt/c:IDNo/@agency"/>
                        </cdi:registrationAuthorityIdentifier>
                        <cdi:versionIdentifier><xsl:value-of select="c:stdyDscr/c:citation/c:verStmt/c:version"/></cdi:versionIdentifier>
                    </cdi:ddiIdentifier>
                </cdi:identifier>
                <xsl:for-each select="c:dataDscr/c:var">
                    <cdi:DataStructure_has_DataStructureComponent-Target>
                        <cdi:uri>
                            <xsl:value-of select="/c:codeBook/c:docDscr/c:citation/c:titlStmt/c:IDNo/@agency"/>:IC_<xsl:value-of select="/c:codeBook/c:docDscr/c:citation/c:titlStmt/c:IDNo"/>_<xsl:value-of select="position()" />:<xsl:value-of select="/c:codeBook/c:stdyDscr/c:citation/c:verStmt/c:version"/>
                        </cdi:uri>
                        <!-- Need to differentiate between IdentifierComponent, MeasureComponent and AttributeComponent here -->
                        <!-- e.g. no catgry elements means IdentifierComponent or AttributeComponent -->
                        <cdi:typeOfClass>IdentifierComponent</cdi:typeOfClass>
                    </cdi:DataStructure_has_DataStructureComponent-Target>
                </xsl:for-each>
                <xsl:for-each select="c:dataDscr/c:var">
                    <cdi:DataStructure_has_ComponentPosition-Target>
                        <cdi:uri>
                            <xsl:value-of select="/c:codeBook/c:docDscr/c:citation/c:titlStmt/c:IDNo/@agency"/>:CP_<xsl:value-of select="/c:codeBook/c:docDscr/c:citation/c:titlStmt/c:IDNo"/>_<xsl:value-of select="position()" />:<xsl:value-of select="/c:codeBook/c:stdyDscr/c:citation/c:verStmt/c:version"/>
                        </cdi:uri>
                        <cdi:typeOfClass>ComponentPosition</cdi:typeOfClass>
                    </cdi:DataStructure_has_ComponentPosition-Target>
                </xsl:for-each>
            </cdi:WideDataStructure>
            <xsl:for-each select="c:dataDscr/c:var">
                <cdi:ComponentPosition>
                    <cdi:value><xsl:value-of select="position()" /></cdi:value>
                    <cdi:identifier>
                    <cdi:ddiIdentifier>
                        <cdi:dataIdentifier>CP_<xsl:value-of select="/c:codeBook/c:docDscr/c:citation/c:titlStmt/c:IDNo"/>_<xsl:value-of select="position()" /></cdi:dataIdentifier>
                        <cdi:registrationAuthorityIdentifier><xsl:value-of select="/c:codeBook/c:docDscr/c:citation/c:titlStmt/c:IDNo/@agency"/></cdi:registrationAuthorityIdentifier>
                        <cdi:versionIdentifier><xsl:value-of select="/c:codeBook/c:stdyDscr/c:citation/c:verStmt/c:version"/></cdi:versionIdentifier>
                    </cdi:ddiIdentifier>
                    </cdi:identifier>
                    <cdi:ComponentPosition_indexes_DataStructureComponent-Target>
                        <cdi:uri>
                            <xsl:value-of select="/c:codeBook/c:docDscr/c:citation/c:titlStmt/c:IDNo/@agency"/>:IC_<xsl:value-of select="/c:codeBook/c:docDscr/c:citation/c:titlStmt/c:IDNo"/>_<xsl:value-of select="position()" />:<xsl:value-of select="/c:codeBook/c:stdyDscr/c:citation/c:verStmt/c:version"/>
                        </cdi:uri>
                        <!-- Need to differentiate between IdentifierComponent, MeasureComponent and AttributeComponent here -->
                    <cdi:typeOfClass>IdentifierComponent</cdi:typeOfClass>
                    </cdi:ComponentPosition_indexes_DataStructureComponent-Target>
                </cdi:ComponentPosition>
            </xsl:for-each>
            <!-- Everything from here on is WIP-->
            <cdi:IdentifierComponent>
                <cdi:identifier>
                <cdi:ddiIdentifier>
                    <cdi:dataIdentifier>IC_FSD3134_1</cdi:dataIdentifier>
                    <cdi:registrationAuthorityIdentifier>fsd.tuni.fi</cdi:registrationAuthorityIdentifier>
                    <cdi:versionIdentifier>0.0.1</cdi:versionIdentifier>
                </cdi:ddiIdentifier>
                </cdi:identifier>
                <cdi:DataStructureComponent_isDefinedBy_RepresentedVariable-Target>
                <cdi:uri>fsd.tuni.fi:RV_FSD3134_FSD_ID_var:0.0.1</cdi:uri>
                <cdi:typeOfClass>RepresentedVariable</cdi:typeOfClass>
                </cdi:DataStructureComponent_isDefinedBy_RepresentedVariable-Target>
            </cdi:IdentifierComponent>
            <cdi:MeasureComponent>
                <cdi:identifier>
                <cdi:ddiIdentifier>
                    <cdi:dataIdentifier>MC_FSD3134_2</cdi:dataIdentifier>
                    <cdi:registrationAuthorityIdentifier>fsd.tuni.fi</cdi:registrationAuthorityIdentifier>
                    <cdi:versionIdentifier>0.0.1</cdi:versionIdentifier>
                </cdi:ddiIdentifier>
                </cdi:identifier>
                <cdi:DataStructureComponent_isDefinedBy_RepresentedVariable-Target>
                <cdi:uri>fsd.tuni.fi:RV_FSD3134_BV1_var:0.0.1</cdi:uri>
                <cdi:typeOfClass>RepresentedVariable</cdi:typeOfClass>
                </cdi:DataStructureComponent_isDefinedBy_RepresentedVariable-Target>
            </cdi:MeasureComponent>
            <cdi:AttributeComponent>
                <cdi:identifier>
                <cdi:ddiIdentifier>
                    <cdi:dataIdentifier>AC_FSD3134_3</cdi:dataIdentifier>
                    <cdi:registrationAuthorityIdentifier>fsd.tuni.fi</cdi:registrationAuthorityIdentifier>
                    <cdi:versionIdentifier>0.0.1</cdi:versionIdentifier>
                </cdi:ddiIdentifier>
                </cdi:identifier>
                <cdi:semantic>
                <cdi:extent>
                    <cdi:entryValue>linkable</cdi:entryValue>
                </cdi:extent>
                <cdi:term>
                    <cdi:entryValue>None</cdi:entryValue>
                </cdi:term>
                </cdi:semantic>
                <cdi:DataStructureComponent_isDefinedBy_RepresentedVariable-Target>
                <cdi:uri>fsd.tuni.fi:FSD3134_FSD_ID_var:0.0.1</cdi:uri>
                <cdi:typeOfClass>RepresentedVariable</cdi:typeOfClass>
                </cdi:DataStructureComponent_isDefinedBy_RepresentedVariable-Target>
            </cdi:AttributeComponent>
            <cdi:RepresentedVariable>
                <cdi:displayLabel>
                <cdi:languageSpecificString>
                    <cdi:content>[fsd_id] FSD case id</cdi:content>
                </cdi:languageSpecificString>
                </cdi:displayLabel>
                <cdi:identifier>
                <cdi:ddiIdentifier>
                    <cdi:dataIdentifier>RV_FSD3134_FSD_ID_var</cdi:dataIdentifier>
                    <cdi:registrationAuthorityIdentifier>fsd.tuni.fi</cdi:registrationAuthorityIdentifier>
                    <cdi:versionIdentifier>0.0.1</cdi:versionIdentifier>
                </cdi:ddiIdentifier>
                </cdi:identifier>
                <cdi:name>
                <cdi:name>FSD3134_FSD_ID_var</cdi:name>
                </cdi:name>
                <cdi:RepresentedVariable_isBasedOn_ConceptualVariable-Target>
                <cdi:uri>fsd.tuni.fi:CV_FSD3134_FSD_ID_var:0.0.1</cdi:uri>
                <cdi:typeOfClass>ConceptualVariable</cdi:typeOfClass>
                </cdi:RepresentedVariable_isBasedOn_ConceptualVariable-Target>
            </cdi:RepresentedVariable>
            <cdi:RepresentedVariable>
                <cdi:displayLabel>
                <cdi:languageSpecificString>
                    <cdi:content>[bv1] Gender of the child</cdi:content>
                </cdi:languageSpecificString>
                </cdi:displayLabel>
                <cdi:identifier>
                <cdi:ddiIdentifier>
                    <cdi:dataIdentifier>RV_FSD3134_BV1_var</cdi:dataIdentifier>
                    <cdi:registrationAuthorityIdentifier>fsd.tuni.fi</cdi:registrationAuthorityIdentifier>
                    <cdi:versionIdentifier>0.0.1</cdi:versionIdentifier>
                </cdi:ddiIdentifier>
                </cdi:identifier>
                <cdi:name>
                <cdi:name>FSD3134_BV1_var</cdi:name>
                </cdi:name>
                <cdi:RepresentedVariable_isBasedOn_ConceptualVariable-Target>
                <cdi:uri>fsd.tuni.fi:CV_FSD3134_BV1_var:0.0.1</cdi:uri>
                <cdi:typeOfClass>ConceptualVariable</cdi:typeOfClass>
                </cdi:RepresentedVariable_isBasedOn_ConceptualVariable-Target>
                <cdi:RepresentedVariable_takesSubstantiveValuesFrom_SubstantiveValueDomain-Target>
                <cdi:uri>fsd.tuni.fi:SVD_FSD3134_BV1_var:0.0.1</cdi:uri>
                <cdi:typeOfClass>SubstantiveValueDomain</cdi:typeOfClass>
                </cdi:RepresentedVariable_takesSubstantiveValuesFrom_SubstantiveValueDomain-Target>
            </cdi:RepresentedVariable>
            <cdi:RepresentedVariable>
                <cdi:displayLabel>
                <cdi:languageSpecificString>
                    <cdi:content>[paino] Weighting coefficient</cdi:content>
                </cdi:languageSpecificString>
                </cdi:displayLabel>
                <cdi:identifier>
                <cdi:ddiIdentifier>
                    <cdi:dataIdentifier>RV_FSD3134_PAINO_var</cdi:dataIdentifier>
                    <cdi:registrationAuthorityIdentifier>fsd.tuni.fi</cdi:registrationAuthorityIdentifier>
                    <cdi:versionIdentifier>0.0.1</cdi:versionIdentifier>
                </cdi:ddiIdentifier>
                </cdi:identifier>
                <cdi:name>
                <cdi:name>FSD3134_PAINO_var</cdi:name>
                </cdi:name>
                <cdi:RepresentedVariable_isBasedOn_ConceptualVariable-Target>
                <cdi:uri>fsd.tuni.fi:CV_FSD3134_PAINO_var:0.0.1</cdi:uri>
                <cdi:typeOfClass>ConceptualVariable</cdi:typeOfClass>
                </cdi:RepresentedVariable_isBasedOn_ConceptualVariable-Target>
            </cdi:RepresentedVariable>
            <cdi:SubstantiveValueDomain>
                <cdi:identifier>
                <cdi:ddiIdentifier>
                    <cdi:dataIdentifier>SVD_FSD3134_BV1_var</cdi:dataIdentifier>
                    <cdi:registrationAuthorityIdentifier>fsd.tuni.fi</cdi:registrationAuthorityIdentifier>
                    <cdi:versionIdentifier>0.0.1</cdi:versionIdentifier>
                </cdi:ddiIdentifier>
                </cdi:identifier>
                <cdi:SubstantiveValueDomain_takesValuesFrom_EnumerationDomain-Target>
                <cdi:uri>fsd.tuni.fi:CL_FSD3134_BV1_var:0.0.1</cdi:uri>
                <cdi:typeOfClass>CodeList</cdi:typeOfClass>
                </cdi:SubstantiveValueDomain_takesValuesFrom_EnumerationDomain-Target>
            </cdi:SubstantiveValueDomain>
            <cdi:CodeList>
                <cdi:identifier>
                <cdi:ddiIdentifier>
                    <cdi:dataIdentifier>CL_FSD3134_BV1_var</cdi:dataIdentifier>
                    <cdi:registrationAuthorityIdentifier>org.ukds</cdi:registrationAuthorityIdentifier>
                    <cdi:versionIdentifier>0.0.1</cdi:versionIdentifier>
                </cdi:ddiIdentifier>
                </cdi:identifier>
                <cdi:CodeList_has_Code-Target>
                <cdi:uri>fsd.tuni.fi:C_FSD3134_BV1_1:0.0.1</cdi:uri>
                <cdi:typeOfClass>Code</cdi:typeOfClass>
                </cdi:CodeList_has_Code-Target>
                <cdi:CodeList_has_Code-Target>
                <cdi:uri>fsd.tuni.fi:C_FSD3134_BV1_2:0.0.1</cdi:uri>
                <cdi:typeOfClass>Code</cdi:typeOfClass>
                </cdi:CodeList_has_Code-Target>
            </cdi:CodeList>
            <cdi:Category>
                <cdi:displayLabel>
                <cdi:languageSpecificString>
                    <cdi:content>Boy</cdi:content>
                </cdi:languageSpecificString>
                </cdi:displayLabel>
                <cdi:identifier>
                <cdi:ddiIdentifier>
                    <cdi:dataIdentifier>Ct_FSD3134_BV1_1</cdi:dataIdentifier>
                    <cdi:registrationAuthorityIdentifier>fsd.tuni.fi</cdi:registrationAuthorityIdentifier>
                    <cdi:versionIdentifier>0.0.1</cdi:versionIdentifier>
                </cdi:ddiIdentifier>
                </cdi:identifier>
                <cdi:name>
                <cdi:name>Boy</cdi:name>
                </cdi:name>
            </cdi:Category>
            <cdi:Category>
                <cdi:displayLabel>
                <cdi:languageSpecificString>
                    <cdi:content>Girl</cdi:content>
                </cdi:languageSpecificString>
                </cdi:displayLabel>
                <cdi:identifier>
                <cdi:ddiIdentifier>
                    <cdi:dataIdentifier>Ct_FSD3134_BV1_2</cdi:dataIdentifier>
                    <cdi:registrationAuthorityIdentifier>fsd.tuni.fi</cdi:registrationAuthorityIdentifier>
                    <cdi:versionIdentifier>0.0.1</cdi:versionIdentifier>
                </cdi:ddiIdentifier>
                </cdi:identifier>
                <cdi:name>
                <cdi:name>Girl</cdi:name>
                </cdi:name>
            </cdi:Category>
            <cdi:CodeList>
                <cdi:identifier>
                <cdi:ddiIdentifier>
                    <cdi:dataIdentifier>CL_FSD3134_BV1_sub</cdi:dataIdentifier>
                    <cdi:registrationAuthorityIdentifier>fsd.tuni.fi</cdi:registrationAuthorityIdentifier>
                    <cdi:versionIdentifier>0.0.1</cdi:versionIdentifier>
                </cdi:ddiIdentifier>
                </cdi:identifier>
                <cdi:CodeList_has_Code-Target>
                <cdi:uri>fsd.tuni.fi:C_FSD3134_BV1_1:0.0.1</cdi:uri>
                <cdi:typeOfClass>Code</cdi:typeOfClass>
                </cdi:CodeList_has_Code-Target>
                <cdi:CodeList_has_Code-Target>
                <cdi:uri>fsd.tuni.fi:C_FSD3134_BV1_2:0.0.1</cdi:uri>
                <cdi:typeOfClass>Code</cdi:typeOfClass>
                </cdi:CodeList_has_Code-Target>
            </cdi:CodeList>
            <cdi:Notation>
                <cdi:content>
                <cdi:content>1</cdi:content>
                </cdi:content>
                <cdi:identifier>
                <cdi:ddiIdentifier>
                    <cdi:dataIdentifier>N_FSD3134_BV1_1</cdi:dataIdentifier>
                    <cdi:registrationAuthorityIdentifier>fsd.tuni.fi</cdi:registrationAuthorityIdentifier>
                    <cdi:versionIdentifier>0.0.1</cdi:versionIdentifier>
                </cdi:ddiIdentifier>
                </cdi:identifier>
            </cdi:Notation>
            <cdi:Notation>
                <cdi:content>
                <cdi:content>2</cdi:content>
                </cdi:content>
                <cdi:identifier>
                <cdi:ddiIdentifier>
                    <cdi:dataIdentifier>N_FSD3134_BV1_2</cdi:dataIdentifier>
                    <cdi:registrationAuthorityIdentifier>fsd.tuni.fi</cdi:registrationAuthorityIdentifier>
                    <cdi:versionIdentifier>0.0.1</cdi:versionIdentifier>
                </cdi:ddiIdentifier>
                </cdi:identifier>
            </cdi:Notation>
            <cdi:InstanceVariable>
                <cdi:displayLabel>
                <cdi:languageSpecificString>
                    <cdi:content>[fsd_id] FSD case id</cdi:content>
                </cdi:languageSpecificString>
                </cdi:displayLabel>
                <cdi:identifier>
                <cdi:ddiIdentifier>
                    <cdi:dataIdentifier>IV_FSD3134_FSD_ID_var</cdi:dataIdentifier>
                    <cdi:registrationAuthorityIdentifier>fsd.tuni.fi</cdi:registrationAuthorityIdentifier>
                    <cdi:versionIdentifier>0.0.1</cdi:versionIdentifier>
                </cdi:ddiIdentifier>
                </cdi:identifier>
                <cdi:name>
                <cdi:name>FSD case id</cdi:name>
                </cdi:name>
                <cdi:InstanceVariable_isBasedOn_RepresentedVariable-Target>
                <cdi:uri>fsd.tuni.fi:RV_FSD3134_FSD_ID_var:0.0.1</cdi:uri>
                <cdi:typeOfClass>RepresentedVariable</cdi:typeOfClass>
                </cdi:InstanceVariable_isBasedOn_RepresentedVariable-Target>
            </cdi:InstanceVariable>
            <cdi:InstanceVariable>
                <cdi:displayLabel>
                <cdi:languageSpecificString>
                    <cdi:content>[bv1] Gender of the child</cdi:content>
                </cdi:languageSpecificString>
                </cdi:displayLabel>
                <cdi:identifier>
                <cdi:ddiIdentifier>
                    <cdi:dataIdentifier>IV_FSD3134_BV1_var</cdi:dataIdentifier>
                    <cdi:registrationAuthorityIdentifier>fsd.tuni.fi</cdi:registrationAuthorityIdentifier>
                    <cdi:versionIdentifier>0.0.1</cdi:versionIdentifier>
                </cdi:ddiIdentifier>
                </cdi:identifier>
                <cdi:name>
                <cdi:name>Gender of the child</cdi:name>
                </cdi:name>
                <cdi:InstanceVariable_isBasedOn_RepresentedVariable-Target>
                <cdi:uri>fsd.tuni.fi:RV_FSD3134_BV1_var:0.0.1</cdi:uri>
                <cdi:typeOfClass>RepresentedVariable</cdi:typeOfClass>
                </cdi:InstanceVariable_isBasedOn_RepresentedVariable-Target>
            </cdi:InstanceVariable>
            <cdi:InstanceVariable>
                <cdi:displayLabel>
                <cdi:languageSpecificString>
                    <cdi:content>[paino] Weighting coefficient</cdi:content>
                </cdi:languageSpecificString>
                </cdi:displayLabel>
                <cdi:identifier>
                <cdi:ddiIdentifier>
                    <cdi:dataIdentifier>IV_FSD3134_PAINO_var</cdi:dataIdentifier>
                    <cdi:registrationAuthorityIdentifier>fsd.tuni.fi</cdi:registrationAuthorityIdentifier>
                    <cdi:versionIdentifier>0.0.1</cdi:versionIdentifier>
                </cdi:ddiIdentifier>
                </cdi:identifier>
                <cdi:name>
                <cdi:name>Weighting coefficient</cdi:name>
                </cdi:name>
                <cdi:variableFunction>
                <cdi:entryValue>None</cdi:entryValue>
                </cdi:variableFunction>
                <cdi:InstanceVariable_isBasedOn_RepresentedVariable-Target>
                <cdi:uri>fsd.tuni.fi:RV_FSD3134_PAINO_var:0.0.1</cdi:uri>
                <cdi:typeOfClass>RepresentedVariable</cdi:typeOfClass>
                </cdi:InstanceVariable_isBasedOn_RepresentedVariable-Target>
            </cdi:InstanceVariable>
            <cdi:ConceptualVariable>
                <cdi:displayLabel>
                <cdi:languageSpecificString>
                    <cdi:content>[fsd_id] FSD case id</cdi:content>
                </cdi:languageSpecificString>
                </cdi:displayLabel>
                <cdi:identifier>
                <cdi:ddiIdentifier>
                    <cdi:dataIdentifier>CV_FSD3134_FSD_ID_var</cdi:dataIdentifier>
                    <cdi:registrationAuthorityIdentifier>fsd.tuni.fi</cdi:registrationAuthorityIdentifier>
                    <cdi:versionIdentifier>0.0.1</cdi:versionIdentifier>
                </cdi:ddiIdentifier>
                </cdi:identifier>
                <cdi:ConceptualVariable_uses_Concept-Target>
                <cdi:uri>fsd.tuni.fi:Cn_FSD3134_FSD_ID_var:0.0.1</cdi:uri>
                <cdi:typeOfClass>Concept</cdi:typeOfClass>
                </cdi:ConceptualVariable_uses_Concept-Target>
            </cdi:ConceptualVariable>
            <cdi:ConceptualVariable>
                <cdi:displayLabel>
                <cdi:languageSpecificString>
                    <cdi:content>[bv1] Gender of the child</cdi:content>
                </cdi:languageSpecificString>
                </cdi:displayLabel>
                <cdi:identifier>
                <cdi:ddiIdentifier>
                    <cdi:dataIdentifier>CV_FSD3134_BV1_var</cdi:dataIdentifier>
                    <cdi:registrationAuthorityIdentifier>fsd.tuni.fi</cdi:registrationAuthorityIdentifier>
                    <cdi:versionIdentifier>0.0.1</cdi:versionIdentifier>
                </cdi:ddiIdentifier>
                </cdi:identifier>
                <cdi:ConceptualVariable_uses_Concept-Target>
                <cdi:uri>fsd.tuni.fi:Cn_FSD3134_BV1_var:0.0.1</cdi:uri>
                <cdi:typeOfClass>Concept</cdi:typeOfClass>
                </cdi:ConceptualVariable_uses_Concept-Target>
            </cdi:ConceptualVariable>
            <cdi:ConceptualVariable>
                <cdi:displayLabel>
                <cdi:languageSpecificString>
                    <cdi:content>[paino] Weighting coefficient</cdi:content>
                </cdi:languageSpecificString>
                </cdi:displayLabel>
                <cdi:identifier>
                <cdi:ddiIdentifier>
                    <cdi:dataIdentifier>CV_FSD3134_PAINO_var</cdi:dataIdentifier>
                    <cdi:registrationAuthorityIdentifier>fsd.tuni.fi</cdi:registrationAuthorityIdentifier>
                    <cdi:versionIdentifier>0.0.1</cdi:versionIdentifier>
                </cdi:ddiIdentifier>
                </cdi:identifier>
                <cdi:ConceptualVariable_uses_Concept-Target>
                <cdi:uri>fsd.tuni.fi:Cn_FSD3134_PAINO_var:0.0.1</cdi:uri>
                <cdi:typeOfClass>Concept</cdi:typeOfClass>
                </cdi:ConceptualVariable_uses_Concept-Target>
            </cdi:ConceptualVariable>
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
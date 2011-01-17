<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:r="ddi:reusable:3_1"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:dce="ddi:dcelements:3_1"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:a="ddi:archive:3_1"
	xmlns:o="ddi:organizations:3_1"
	xmlns:g="ddi:group:3_1"
	xmlns:cm="ddi:comparative:3_1"
	xmlns:c="ddi:conceptualcomponent:3_1"
	xmlns:d="ddi:datacollection:3_1"
	xmlns:l="ddi:logicalproduct:3_1"
	xmlns:pd="ddi:physicaldataproduct:3_1"
	xmlns:ds="ddi:dataset:3_1"
	xmlns:pi="ddi:physicalinstance:3_1"
	xmlns:m1="ddi:physicaldataproduct/ncube/normal:3_1"
	xmlns:m2="ddi:physicaldataproduct/ncube/tabular:3_1"
	xmlns:m3="ddi:physicaldataproduct/ncube/inline:3_1"
	xmlns:s="ddi:studyunit:3_1"
	xmlns:pr="ddi:profile:3_1"
	xmlns:ddi="ddi:instance:3_1"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="ddi:instance:3_1 http://www.ddialliance.org/sites/default/files/schema/ddi3.1/instance.xsd">

	<xsl:variable name="lang">sv</xsl:variable>
	
	<xsl:template match="/ddi:DDIInstance">
		<html>
			<head>
				<title><xsl:value-of select="s:StudyUnit/r:Citation/r:Title[@xml:lang=$lang]"/></title>
				<meta charset="utf-8" />
			</head>
			<body>
				<h1><xsl:value-of select="s:StudyUnit/r:Citation/r:Title[@xml:lang=$lang]"/></h1>
				<h2><xsl:value-of select="s:StudyUnit/@id"/></h2>
				
				<h3>Abstract</h3>
				<p><xsl:value-of select="s:StudyUnit/s:Abstract/r:Content[@xml:lang=$lang]"/></p>

				<h3>Coverage</h3>
				<xsl:for-each select="s:StudyUnit/r:Coverage/r:TemporalCoverage">
					<p><xsl:value-of select="r:ReferenceDate/r:StartDate"/> - <xsl:value-of select="r:ReferenceDate/r:EndDate"/></p>
			    </xsl:for-each>
				
				<h3>Universe</h3>
				<xsl:for-each select="s:StudyUnit/c:ConceptualComponent/c:UniverseScheme/c:Universe">
					<p><xsl:value-of select="c:HumanReadable[@xml:lang=$lang]"/></p>
			    </xsl:for-each>
			    
			    <h3>Questions</h3>
			    <xsl:for-each select="s:StudyUnit/d:DataCollection/d:QuestionScheme/d:QuestionItem">
			    	<div class="question">
			    	<strong class="questionName" style="width:50px"><xsl:value-of select="d:QuestionItemName[@xml:lang=$lang]"/></strong>
			    	<p class="questionText">
			    		<xsl:value-of select="d:QuestionText[@xml:lang=$lang]/d:LiteralText/d:Text"/>
			    	</p>
			    	</div>
			    </xsl:for-each>
			</body>
		</html>	
	</xsl:template>
</xsl:stylesheet>
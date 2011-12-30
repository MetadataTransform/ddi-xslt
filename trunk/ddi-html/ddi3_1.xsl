<xsl:stylesheet
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:g="ddi:group:3_1"
                xmlns:d="ddi:datacollection:3_1"
                xmlns:dce="ddi:dcelements:3_1"
                xmlns:c="ddi:conceptualcomponent:3_1"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:a="ddi:archive:3_1"
                xmlns:m1="ddi:physicaldataproduct/ncube/normal:3_1"
                xmlns:ddi="ddi:instance:3_1"
                xmlns:m2="ddi:physicaldataproduct/ncube/tabular:3_1"
                xmlns:o="ddi:organizations:3_1"
                xmlns:l="ddi:logicalproduct:3_1"
                xmlns:m3="ddi:physicaldataproduct/ncube/inline:3_1"
                xmlns:pd="ddi:physicaldataproduct:3_1"
                xmlns:cm="ddi:comparative:3_1"
                xmlns:s="ddi:studyunit:3_1"
                xmlns:r="ddi:reusable:3_1"
                xmlns:pi="ddi:physicalinstance:3_1"
                xmlns:ds="ddi:dataset:3_1"
                xmlns:pr="ddi:profile:3_1"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0"
                xsi:schemaLocation="ddi:instance:3_1 http://www.ddialliance.org/sites/default/files/schema/ddi3.1/instance.xsd">

    
    <xsl:import href="ddi3_1_datacollection.xsl"/>
    <xsl:import href="ddi3_1_logicalproduct.xsl"/>

    <!-- render text-elements of this language-->
    <xsl:param name="lang">da</xsl:param>
    <!-- if the requested language is not found for e.g. questionText, use fallback language-->
    <xsl:param name="fallback-lang">en</xsl:param>
    <!-- render all html-elements or just the content of body--> 
    <xsl:param name="render-as-document">true</xsl:param>
    <!-- include interactive js and jquery for navigation (external links to eXist)-->
    <xsl:param name="include-js">false</xsl:param> 
    <!-- [optional] if include-js is true this is the backend for ajax-requests -->
    <xsl:param name="exist-backend">http://bull.ssd.gu.se:8080/rest/ddi</xsl:param>
    <!-- print anchors for eg QuestionItems-->
    <xsl:param name="print-anchor">1</xsl:param>
    <!-- show the title (and subtitle) of the study-->
    <xsl:param name="show-study-title">1</xsl:param>
    <!-- show the questions as a separate flow from the variables-->
    <xsl:param name="show-questionnaires">1</xsl:param>
    <!-- show navigation-bar-->
    <xsl:param name="show-navigration-bar">1</xsl:param>
    <!-- show study-information-->
    <xsl:param name="show-study-information">1</xsl:param>    
    <!-- path prefix to the theme css-files-->
    <xsl:param name="theme-path">theme/default</xsl:param> 
    

    <!-- path prefix (used for css, js when rendered on the web)-->
    <xsl:param name="path-prefix">../ddi-html</xsl:param>    
    

    <xsl:param name="translations">i18n/messages_en.properties.xml</xsl:param>
    <xsl:variable name="msg" select="document($translations)"/>	
    
    <xsl:output method="html" 
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" 
      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" 
      indent="yes"
      />
    
    <xsl:template match="/ddi:DDIInstance"> 
        <html>
            <head>
                <title>
                    <xsl:choose>
                        <xsl:when test="s:StudyUnit/r:Citation/r:Title/@xml:lang">
                            <xsl:value-of select="s:StudyUnit/r:Citation/r:Title[@xml:lang=$lang]"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="s:StudyUnit/r:Citation/r:Title"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </title>
                <xsl:choose>
                    <xsl:when test="$include-js">
                        <script type="text/javascript">
                            <xsl:attribute name="src"><xsl:value-of select="$path-prefix"/>/js/jquery-1.7.1.min.js</xsl:attribute>
                        </script>
                        
                        <script type="text/javascript">
                            <xsl:attribute name="src"><xsl:value-of select="$path-prefix"/>/js/config.js</xsl:attribute>
                        </script>
                        
                        <script type="text/javascript" src="js/exist-requests.js">
                            
                        </script>
                        <xsl:choose>
                            <xsl:when test="$show-navigration-bar">
                                <script type="text/javascript">
                                    <xsl:attribute name="src"><xsl:value-of select="$path-prefix"/>/js/navaigation-bar.js</xsl:attribute>
                                </script>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
                
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></meta>
                <link type="text/css" rel="stylesheet" media="all">
                     <xsl:attribute name="href"><xsl:value-of select="$path-prefix"/>/<xsl:value-of select="$theme-path"/>/ddi.css</xsl:attribute>
                </link>
            </head>
            <body>
                <xsl:apply-templates select="s:StudyUnit"/>   
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="s:StudyUnit">
        <div id="study">
            <xsl:if test="$show-study-title = 1">
                <h1>
                    <xsl:choose>
                        <xsl:when test="r:Citation/r:Title/@xml:lang">
                            <xsl:value-of select="r:Citation/r:Title[@xml:lang=$lang]"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="r:Citation/r:Title"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </h1>
                <p>
                    <strong>
                    <xsl:value-of select="r:Citation/r:AlternateTitle[@xml:lang=$lang]"/>
                    </strong>
                </p>
            </xsl:if>

            <xsl:if test="$show-study-information = 1">
                <p class="refNr">
                    Ref. nr: <strong><xsl:value-of select="@id"/></strong>
                </p>
                <h3><xsl:value-of select="$msg/*/entry[@key='Abstract']"/></h3>
                <xsl:choose>
                    <xsl:when test="s:Abstract/@xml:lang">
                        <xsl:copy-of select="s:Abstract[@xml:lang=$lang]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="s:Abstract"/>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:apply-templates select="r:Citation"/>

                <xsl:apply-templates select="r:Coverage"/>

                <xsl:if test="s:KindOfData">
                    <h3><xsl:value-of select="$msg/*/entry[@key='Kind_of_Data']"/></h3>
                    <xsl:for-each select="s:KindOfData">
                        <p>
                            <xsl:value-of select="."/>
                        </p>
                    </xsl:for-each>
                </xsl:if>

                <xsl:if test="c:ConceptualComponent/c:UniverseScheme">           
                    <h3><xsl:value-of select="$msg/*/entry[@key='Universe']"/></h3>
                    <xsl:apply-templates select="c:ConceptualComponent/c:UniverseScheme"/>
                </xsl:if>
                <xsl:apply-templates select="r:SeriesStatement"/>                           
            </xsl:if>

            <xsl:apply-templates select="d:DataCollection"/>
            <xsl:apply-templates select="l:LogicalProduct"/>
        </div>        
    </xsl:template>
    
    <xsl:template match="s:Coverage">
        <h3><xsl:value-of select="$msg/*/entry[@key='Scope_and_Coverage']"/></h3>
        <xsl:for-each select="r:TemporalCoverage">
            <p>
                <xsl:value-of select="r:ReferenceDate/r:StartDate"/> - <xsl:value-of select="r:ReferenceDate/r:EndDate"/>
            </p>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="c:UniverseScheme">
        <xsl:for-each select="c:Universe">
            <p>
                <xsl:value-of select="c:HumanReadable[@xml:lang=$lang]"/>
            </p>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="a:Archive">
        <div class="archive">

        </div>
    </xsl:template>

    <xsl:template match="r:Citation">
        <xsl:if test="count(r:Creator) > 0">
	        <h3><xsl:value-of select="$msg/*/entry[@key='Primary_Investigators']"/></h3>
	        <ul class="creator">
	            <xsl:for-each select="r:Creator[@xml:lang=$lang]">
	                <li>
	                    <xsl:value-of select="."/>, <em>
	                        <xsl:value-of select="@affiliation"/>
	                    </em>
	                </li>
	            </xsl:for-each>
	        </ul>
        </xsl:if>
        <xsl:if test="count(r:Publisher[@xml:lang=$lang]) > 0">
	        <h3><xsl:value-of select="$msg/*/entry[@key='Publishers']"/></h3>
	        <ul class="publisher">
	            <xsl:for-each select="r:Publisher[@xml:lang=$lang]">
	                <li>
	                    <xsl:value-of select="."/>
	                </li>
	            </xsl:for-each>
	        </ul>
        </xsl:if>
    </xsl:template>

    <xsl:template match="r:SeriesStatement">
        <h3><xsl:value-of select="$msg/*/entry[@key='Series']"/></h3>
        <p>
        	<strong><xsl:value-of select="$msg/*/entry[@key='Name']"/>: </strong>
        	<xsl:value-of select="r:SeriesName[@xml:lang=$lang]"/>
        </p>
        <p>
        	<xsl:value-of select="r:SeriesDescription[@xml:lang=$lang]"/>
        </p>
    </xsl:template>

    <xsl:template match="r:OtherMaterial">
        <li>
            <!-- used for setting class for icon for the filetype-->
            <xsl:attribute name="class">
                <xsl:value-of select="substring-after(r:MIMEType,'/')"/>
            </xsl:attribute>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="r:ExternalURLReference"/>
                </xsl:attribute>
                <xsl:value-of select="r:Citation/r:Title[@xml:lang=$lang]"/>
            </a>
        </li>
    </xsl:template>
</xsl:stylesheet>
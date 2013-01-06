<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:g="ddi:group:3_1" xmlns:d="ddi:datacollection:3_1" xmlns:dce="ddi:dcelements:3_1" xmlns:c="ddi:conceptualcomponent:3_1" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:a="ddi:archive:3_1"
    xmlns:m1="ddi:physicaldataproduct/ncube/normal:3_1" xmlns:ddi="ddi:instance:3_1" xmlns:m2="ddi:physicaldataproduct/ncube/tabular:3_1" xmlns:o="ddi:organizations:3_1" xmlns:l="ddi:logicalproduct:3_1" xmlns:m3="ddi:physicaldataproduct/ncube/inline:3_1" xmlns:pd="ddi:physicaldataproduct:3_1"
    xmlns:cm="ddi:comparative:3_1" xmlns:s="ddi:studyunit:3_1" xmlns:r="ddi:reusable:3_1" xmlns:pi="ddi:physicalinstance:3_1" xmlns:ds="ddi:dataset:3_1" xmlns:pr="ddi:profile:3_1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:util="https://code.google.com/p/ddixslt/#util" version="2.0" xsi:schemaLocation="ddi:instance:3_1 http://www.ddialliance.org/sites/default/files/schema/ddi3.1/instance.xsd">

    <!-- imports -->
    <xsl:import href="ddi3_1_util.xsl"/>
    <xsl:import href="ddi3_1_datacollection.xsl"/>
    <xsl:import href="ddi3_1_logicalproduct.xsl"/>
    <xsl:import href="ddi3_1_conceptualcomponent.xsl"/>


    <!--  SVN version -->
    <xsl:param name="svn-revision">$Revision: 103 $</xsl:param>
    <!-- render text-elements of this language-->
    <xsl:param name="lang">sv</xsl:param>
    <!-- if the requested language is not found for e.g. questionText, use fallback language-->
    <xsl:param name="fallback-lang">en</xsl:param>
    <!-- render all html-elements or just the content of body-->
    <xsl:param name="render-as-document">true</xsl:param>
    <!-- include interactive js and jquery for navigation (external links to eXist)-->
    <xsl:param name="include-js">true</xsl:param>
    <!-- coma-separated list for language switch (js-navigation)-->
    <xsl:param name="languageSwitch">sv,en</xsl:param>
    <!-- print anchors for eg QuestionItems-->
    <xsl:param name="print-anchor">true</xsl:param>
    <!-- show the title (and subtitle) of the study-->
    <xsl:param name="show-study-title">true</xsl:param>
    <!-- show citaion as part study-information-->
    <xsl:param name="show-citation">true</xsl:param>
    <!-- show the coverage as part of study-information -->
    <xsl:param name="show-coverage">true</xsl:param>
    <!-- show the Table Of Content in top of document -->
    <xsl:param name="show-toc">true</xsl:param>
    <!-- show the abstract as part of study-information -->
    <xsl:param name="show-abstract">true</xsl:param>
    <!-- show the questions as a separate flow from the variables-->
    <xsl:param name="show-questionnaires">true</xsl:param>
    <!-- show navigation-bar-->
    <xsl:param name="show-navigration-bar">true</xsl:param>
    <!-- show category-statistics-->
    <xsl:param name="show-category-statistics">false</xsl:param>
    <!-- show inline variable list-->
    <xsl:param name="show-variable-list">true</xsl:param>
    <!-- show study-information-->
    <xsl:param name="show-study-information">true</xsl:param>
    <!-- guidances and curration process -->
    <xsl:param name="show-guidance">false</xsl:param>
    <xsl:param name="guidancelink">#</xsl:param>
    <xsl:param name="currationprocesslink">#</xsl:param>
    <!-- show kind-of-data-->
    <xsl:param name="show-kind-of-data">true</xsl:param>
    <!-- show universe on variable -->
    <xsl:param name="show-universe">true</xsl:param>
    <!-- path prefix to the theme css-files-->
    <xsl:param name="theme-path">theme/default</xsl:param>

    <!-- path prefix (used for css, js when rendered on the web)-->
    <xsl:param name="path-prefix">../ddi-html</xsl:param>

    <xsl:param name="translations">i18n/messages_en.properties.xml</xsl:param>
    <xsl:variable name="msg" select="document($translations)"/>

    <xsl:output method="html" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" indent="yes"/>

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
                
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                
                <xsl:choose>
                    <xsl:when test="$include-js='true'">
                        <script type="text/javascript">
                            <!--xsl:attribute name="src">http://code.jquery.com/jquery.min.js</xsl:attribute-->
                            <xsl:attribute name="src">http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js</xsl:attribute>
                        </script>
                        
                        <!-- Translations and settings for javascript plugins-->
                        <script type="text/javascript">
                            <xsl:text>var i18n = {};</xsl:text>
                            <xsl:text>i18n.questions = '</xsl:text><xsl:value-of select="util:i18n('Questions')"/><xsl:text>';</xsl:text>
                            <xsl:text>i18n.variables = '</xsl:text><xsl:value-of select="util:i18n('Variables')"/><xsl:text>';</xsl:text>
                            <xsl:text>i18n.filter = '</xsl:text><xsl:value-of select="util:i18n('Filter')"/><xsl:text>';</xsl:text>
                            <xsl:text>i18n.language = '</xsl:text><xsl:value-of select="util:i18n('Language')"/><xsl:text>';</xsl:text>
                            
                            <xsl:text>var languageSwitch = '</xsl:text><xsl:value-of select="$languageSwitch"/><xsl:text>';</xsl:text>
                        </script>

                        <script type="text/javascript">
                            <xsl:attribute name="src"><xsl:value-of select="$path-prefix"/>/js/config.js</xsl:attribute>
                        </script>

                        <script type="text/javascript" src="js/exist-requests.js"> </script>
                        
                        <xsl:choose>
                            <xsl:when test="$show-navigration-bar ='true'">
                                <script type="text/javascript">
                                    <xsl:attribute name="src"><xsl:value-of select="$path-prefix"/>/js/navaigation-bar.js</xsl:attribute>
                                </script>
                            </xsl:when>
                        </xsl:choose>
                        
                        <!-- flot graph -->
                        <xsl:choose>
                            <xsl:when test="$show-category-statistics='true'">
                                <xsl:comment>[if lte IE 8<![CDATA[>]]>&lt;script type="text/javascript" src="<xsl:value-of select="$path-prefix"/>/js/excanvas.min.js"&gt;&lt;/script&gt;<![CDATA[<![endif]]]></xsl:comment>                                    
                                <script type="text/javascript">
                                    <xsl:attribute name="src"><xsl:value-of select="$path-prefix"/>/js/jquery.flot.js</xsl:attribute>
                                </script>
                                <script type="text/javascript">
                                    <xsl:attribute name="src"><xsl:value-of select="$path-prefix"/>/js/jquery.flot.pie.js</xsl:attribute>
                                </script>
                                <script type="text/javascript">
                                    <xsl:attribute name="src"><xsl:value-of select="$path-prefix"/>/js/jquery.flot.tooltip.min.js</xsl:attribute>
                                </script>                                
                            </xsl:when>           
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
                
                <link type="text/css" rel="stylesheet" media="all">
                    <xsl:attribute name="href"><xsl:value-of select="$path-prefix"/>/<xsl:value-of select="$theme-path"/>/ddi.css</xsl:attribute>
                </link>
            </head>
            <body>
                <div class="version">
                    <xsl:value-of select="$svn-revision"/>
                </div>
                <xsl:apply-templates select="s:StudyUnit"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="s:StudyUnit">
        <div id="study" itemscope="" itemtype="http://schema.org/CreativeWork">
            <xsl:if test="$show-study-title = 'true'">
                <h1 itemprop="name">
                    <xsl:choose>
                        <xsl:when test="r:Citation/r:Title/@xml:lang">
                            <xsl:value-of select="r:Citation/r:Title[@xml:lang=$lang]"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="r:Citation/r:Title"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </h1>
                <a>
                    <xsl:attribute name="href">#Title</xsl:attribute>
                </a>
                <p>
                    <strong itemprop="alternativeHeadline">
                        <xsl:value-of select="r:Citation/r:AlternateTitle[@xml:lang=$lang]"/>
                    </strong>
                </p>
            </xsl:if>

            <xsl:if test="$show-study-information = 'true'">
                <div id="studyId">
                    <h2>
                        <xsl:value-of select="util:i18n('RefNo')"/>
                        <strong>
                            <xsl:choose>
                                <xsl:when test="a:Archive/a:ArchiveSpecific/a:Collection/a:CallNumber">
                                    <xsl:value-of select="a:Archive/a:ArchiveSpecific/a:Collection/a:CallNumber"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@id"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </strong>
                    </h2>
                </div>

                <!-- guidances and curration process -->
                <xsl:if test="$show-guidance = 'true'">
                    <h3>
                        <xsl:value-of select="util:i18n('Instruction')"/>
                    </h3>
                    <div class="guidance">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="util:i18n($guidancelink)"/>
                            </xsl:attribute>
                            <xsl:value-of select="util:i18n('GuidanceText')"/>
                        </a>
                        <br/>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="util:i18n($currationprocesslink)"/>
                            </xsl:attribute>
                            <xsl:value-of select="util:i18n('CurrationProcessText')"/>
                        </a>
                    </div>
                </xsl:if>

                <xsl:if test="$show-toc = 'true'">
                    <h3>
                        <xsl:value-of select="util:i18n('Indholdsfortegnelse')"/>
                    </h3>
                    <dl>
                        <div class="toc">
                           <xsl:if test="$show-variable-list = 'true'">
                            	<dt>
                                	<a>
                                    	<xsl:attribute name="href">#VariableList</xsl:attribute>
                                    	<xsl:value-of select="util:i18n('VariableList')"/>
                                	</a>
                            	</dt>
			    </xsl:if>
                            <dt>
                                <a>
                                    <xsl:attribute name="href">#UniverseList</xsl:attribute>
                                    <xsl:value-of select="util:i18n('Universe')"/>
                                </a>
                            </dt>
                            <dt>
                                <a>
                                    <xsl:attribute name="href">#ConceptList</xsl:attribute>
                                    <xsl:value-of select="util:i18n('Concepts')"/>
                                </a>
                            </dt>
                            <dt>
                                <a>
                                    <xsl:attribute name="href">#Instrumentation</xsl:attribute>
                                    <xsl:value-of select="util:i18n('Instrumentation')"/>
                                </a>
                            </dt>
                        </div>
                    </dl>
                </xsl:if>

                <xsl:if test="$show-abstract = 'true'">
                    <h3>
                        <xsl:value-of select="util:i18n('Abstract')"/>
                    </h3>
                    <a>
                        <xsl:attribute name="href">#Abstract</xsl:attribute>
                    </a>
                    <p itemprop="description">
                        <xsl:choose>
                            <xsl:when test="s:Abstract/r:Content[@xml:lang=$lang]">
                                <xsl:value-of select="s:Abstract/r:Content[@xml:lang=$lang]"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="s:Abstract/r:Content"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </p>
                </xsl:if>

                <xsl:if test="$show-citation = 'true'">
                    <xsl:apply-templates select="r:Citation"/>
                </xsl:if>

                <xsl:if test="$show-coverage = 'true'">
                    <xsl:apply-templates select="r:Coverage"/>
                </xsl:if>

                <xsl:if test="$show-variable-list = 'true'">
                    <xsl:if test="count(l:LogicalProduct/l:VariableScheme/l:Variable) > 0">
                        <p>
                            <h3 id="VariableList">
                                <xsl:value-of select="util:i18n('VariableList')"/>
                            </h3>
                            <div class="varlist">
                                <dl>
                                    <xsl:for-each select="l:LogicalProduct/l:VariableScheme/l:Variable">
                                        <dt>
                                            <a>
                                                <!-- Note: JS Navigation Bar - does not support not supported anchors with version -->
                                                <!-- <xsl:attribute name="href">#<xsl:value-of select="@id"/></xsl:attribute> -->
                                                <xsl:attribute name="href">#<xsl:value-of select="@id"/>.<xsl:value-of select="@version"/></xsl:attribute>
                                                <xsl:value-of select="l:VariableName"/>
                                                <xsl:text> </xsl:text>
                                                <xsl:value-of select="r:Label"/>
                                            </a>
                                        </dt>
                                    </xsl:for-each>
                                </dl>
                            </div>
                        </p>
                    </xsl:if>
                </xsl:if>

                <xsl:if test="$show-kind-of-data='true'">
                    <xsl:if test="s:KindOfData">
                        <h3>
                            <xsl:value-of select="util:i18n('Kind_of_Data')"/>
                        </h3>
                        <xsl:for-each select="s:KindOfData">
                            <p>
                                <xsl:value-of select="."/>
                            </p>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:if>

                <xsl:if test="c:ConceptualComponent/c:UniverseScheme">
                    <h3 id="UniverseList">
                        <xsl:value-of select="util:i18n('Universe')"/>
                    </h3>

                    <div class="universeScheme">
                        <!-- Study Unit Unverse Reference -->
                        <h4>
                            <xsl:value-of select="util:i18n('MainUniverse')"/>
                        </h4>
                        <xsl:for-each select="r:UniverseReference/r:ID">
                            <xsl:variable name="univRefId" select="."/>
                            <xsl:for-each select="../../c:ConceptualComponent/c:UniverseScheme/c:Universe">
                                <xsl:if test="@id = $univRefId">
                                    <xsl:call-template name="Universe"/>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:for-each>

                        <!-- Sub Universes -->
                        <xsl:if test="$show-universe = 'true'">
                            <h4>
                                <xsl:value-of select="util:i18n('AllUniverses')"/>
                            </h4>
                            <xsl:for-each select="c:ConceptualComponent/c:UniverseScheme/c:Universe">
                                <xsl:call-template name="Universe"/>
                            </xsl:for-each>
                        </xsl:if>
                    </div>
                </xsl:if>

                <xsl:apply-templates select="r:SeriesStatement"/>
            </xsl:if>

            <xsl:if test="r:OtherMaterial">
                <h4>
                    <xsl:value-of select="util:i18n('Other_documents')"/>
                </h4>
                <ul>
                    <xsl:apply-templates select="r:OtherMaterial"/>
                </ul>
            </xsl:if>


            <xsl:apply-templates select="c:ConceptualComponent"/>

            <xsl:if test="$show-questionnaires = 'true'">
                <xsl:apply-templates select="d:DataCollection"/>
            </xsl:if>

            <xsl:apply-templates select="l:LogicalProduct"/>
        </div>
    </xsl:template>

    <xsl:template match="r:Coverage">
        <h3>
            <xsl:value-of select="util:i18n('Scope_and_Coverage')"/>
        </h3>

        <h4>
            <xsl:value-of select="util:i18n('Time_Periods')"/>
        </h4>
        <xsl:for-each select="r:TemporalCoverage">
            <p itemscope="" itemtype="http://schema.org/Event">
                <span itemprop="startDate">
                    <xsl:value-of select="r:ReferenceDate/r:StartDate"/>
                </span> - <span itemprop="endDate">
                    <xsl:value-of select="r:ReferenceDate/r:EndDate"/>
                </span>
            </p>
        </xsl:for-each>


        <xsl:apply-templates select="r:TopicalCoverage"/>
    </xsl:template>

    <xsl:template match="r:TopicalCoverage">
        <h4>
            <xsl:value-of select="util:i18n('Topics')"/>
        </h4>
        <xsl:if test="r:Subject">
            <ul class="subjects">
                <xsl:for-each select="r:Subject">
                    <xsl:if test="./@xml:lang=$lang">
                        <li itemprop="keywords">
                            <xsl:value-of select="."/>
                        </li>
                    </xsl:if>
                </xsl:for-each>
            </ul>
        </xsl:if>
        <h4>
            <xsl:value-of select="util:i18n('Keywords')"/>
        </h4>
        <xsl:if test="r:Keyword">
            <ul class="keywords">
                <xsl:for-each select="r:Keyword">
                    <xsl:if test="./@xml:lang=$lang">
                        <li itemprop="keywords">
                            <xsl:value-of select="."/>
                        </li>
                    </xsl:if>
                </xsl:for-each>
            </ul>
        </xsl:if>
    </xsl:template>

    <xsl:template match="c:Universe">
        <xsl:call-template name="Universe"/>
    </xsl:template>

    <xsl:template name="Universe">
        <xsl:variable name="uniId" select="@id"/>
        <ul>
            <li class="universeList">
                <xsl:text> </xsl:text>
                <xsl:call-template name="CreateLink"/>
                <xsl:text> </xsl:text>
                <strong>
                    <xsl:value-of select="c:HumanReadable[@xml:lang=$lang]"/>
                </strong>

                <xsl:if test="../../../l:LogicalProduct/l:VariableScheme/l:Variable/r:UniverseReference/r:ID=$uniId">
                    <ul>
                        <li class="variable">
                            <xsl:for-each select="../../../l:LogicalProduct/l:VariableScheme/l:Variable">
                                <xsl:if test="$uniId = r:UniverseReference/r:ID">
                                    <a>
                                        <xsl:attribute name="href">#<xsl:value-of select="@id"/>.<xsl:value-of select="@version"/></xsl:attribute>
                                        <xsl:value-of select="l:VariableName"/>
                                    </a>
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </li>
                    </ul>
                </xsl:if>
            </li>
        </ul>
    </xsl:template>

    <xsl:template match="a:Archive">
        <div class="archive"> </div>
    </xsl:template>

    <xsl:template match="r:Citation">
        <xsl:if test="count(r:Creator) > 0">
            <h3>
                <xsl:value-of select="util:i18n('Primary_Investigators')"/>
            </h3>
            <ul class="creator">
                <xsl:for-each select="r:Creator[@xml:lang=$lang]">
                    <li itemscope="" itemtype="http://schema.org/Person">
                        <span itemprop="name">
                            <xsl:value-of select="."/>
                        </span>, <em>
                            <span itemprop="affiliation">
                                <xsl:value-of select="@affiliation"/>
                            </span>
                        </em>
                    </li>
                </xsl:for-each>
            </ul>
        </xsl:if>
        <xsl:if test="count(r:Publisher[@xml:lang=$lang]) > 0">
            <h3>
                <xsl:value-of select="util:i18n('Publishers')"/>
            </h3>
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
        <h3>
            <xsl:value-of select="util:i18n('Series')"/>
        </h3>
        <p>
            <strong><xsl:value-of select="util:i18n('Name')"/>: </strong>
            <xsl:value-of select="r:SeriesName[@xml:lang=$lang]"/>
        </p>
        <p>
            <xsl:value-of select="r:SeriesDescription[@xml:lang=$lang]"/>
        </p>
    </xsl:template>

    <xsl:template match="r:OtherMaterial">
        <xsl:choose>
            <xsl:when test="./@type = 'publication'">
                <li class="publication" itemscope="" itemtype="http://schema.org/Article">
                    <xsl:choose>
                        <xsl:when test="r:ExternalURLReference">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="r:ExternalURLReference"/>
                                </xsl:attribute>
                                <span itemprop="name">
                                    <xsl:value-of select="r:Citation/r:Title[@xml:lang=$lang]"/>
                                </span>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <span itemprop="name">
                                <xsl:value-of select="r:Citation/r:Title[@xml:lang=$lang]"/>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:for-each select="r:Citation/r:Creator[@xml:lang=$lang]">
                        <span itemprop="author"><xsl:value-of select="."/>, </span>
                    </xsl:for-each>
                    <xsl:choose>
                        <xsl:when test="r:Citation/r:Publisher[@xml:lang=$lang]">
                            <xsl:for-each select="r:Citation/r:Publisher[@xml:lang=$lang]">
                                <span itemprop="publisher">
                                    <xsl:value-of select="."/>
                                </span>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="r:Citation/r:Publisher">
                            <xsl:for-each select="r:Citation/r:Publisher">
                                <span itemprop="publisher">
                                    <xsl:value-of select="."/>
                                </span>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                </li>
            </xsl:when>
            <xsl:otherwise>
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
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>

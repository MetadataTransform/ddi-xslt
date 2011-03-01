<xsl:stylesheet xmlns:dc="http://purl.org/dc/elements/1.1/"
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
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0"
                xsi:schemaLocation="ddi:instance:3_1 http://www.ddialliance.org/sites/default/files/schema/ddi3.1/instance.xsd">
    <xsl:param name="lang">da</xsl:param>
    <xsl:param name="fallback-lang">en</xsl:param>
    <xsl:param name="render-as-document">true</xsl:param>
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
                <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"/>
                <meta charset="utf-8"/>
                <link type="text/css" rel="stylesheet" media="all" href="ddi.css"/>
            </head>
            <body>
                <h1>
                    <xsl:choose>
                        <xsl:when test="s:StudyUnit/r:Citation/r:Title/@xml:lang">
                            <xsl:value-of select="s:StudyUnit/r:Citation/r:Title[@xml:lang=$lang]"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="s:StudyUnit/r:Citation/r:Title"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </h1>

                <strong>
                    <xsl:value-of select="s:StudyUnit/r:Citation/r:AlternateTitle[@xml:lang=$lang]"/>
                </strong>

                <p class="refNr">
                 Ref. nr: <strong><xsl:value-of select="s:StudyUnit/@id"/></strong>
                </p>

                <xsl:apply-templates select="s:StudyUnit/s:Abstract"/>
                
                <xsl:apply-templates select="s:StudyUnit/r:Citation"/>

                <xsl:apply-templates select="s:StudyUnit/r:Coverage"/>

                <xsl:apply-templates select="s:StudyUnit/c:ConceptualComponent/c:UniverseScheme"/>

                <xsl:apply-templates select="s:StudyUnit/r:SeriesStatement"/>
                <xsl:apply-templates select="s:StudyUnit/d:DataCollection"/>
                <xsl:apply-templates select="s:StudyUnit/l:LogicalProduct"/>

            </body>
        </html>
    </xsl:template>
    <xsl:template match="s:Abstract">
        <h3>Abstract</h3>
        <p><xsl:value-of select="r:Content[@xml:lang=$lang]"/></p>
    </xsl:template>

    <xsl:template match="s:Coverage">
        <h3>Coverage</h3>
        <xsl:for-each select="r:TemporalCoverage">
            <p>
                <xsl:value-of select="r:ReferenceDate/r:StartDate"/> - <xsl:value-of select="r:ReferenceDate/r:EndDate"/>
            </p>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="c:UniverseScheme">
        <h3>Universe</h3>
        <xsl:for-each select="c:Universe">
            <p>
                <xsl:value-of select="c:HumanReadable[@xml:lang=$lang]"/>
            </p>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="l:LogicalProduct">
        <div class="variableSchemes">
             <xsl:apply-templates select="l:DataRelationship/l:LogicalRecord/l:VariablesInRecord/l:VariableSchemeReference"/>
        </div>
    </xsl:template>

    <xsl:template match="d:DataCollection">
        <div class="dataCollection">
            <ul class="otherMaterial">
                <xsl:apply-templates select="r:OtherMaterial"/>
            </ul>
            <div class="questionSchemes">
                <xsl:apply-templates select="d:QuestionScheme"/>
            </div>


        </div>
    </xsl:template>
    <xsl:template match="r:Citation">
        <h3>Creator</h3>
        <ul class="creator">
            <xsl:for-each select="r:Creator[@xml:lang=$lang]">
                <li>
                    <xsl:value-of select="."/>, <em>
                        <xsl:value-of select="@affiliation"/>
                    </em>
                </li>
            </xsl:for-each>
        </ul>
        <h3>Creator</h3>
        <ul class="publisher">
            <xsl:for-each select="r:Publisher[@xml:lang=$lang]">
                <li>
                    <xsl:value-of select="."/>
                </li>
            </xsl:for-each>
        </ul>

    </xsl:template>
    <xsl:template match="r:SeriesStatement">
        <h3>Series</h3>
        <strong>Name: </strong>
        <xsl:value-of select="r:SeriesName[@xml:lang=$lang]"/>
        <br/>
        <xsl:value-of select="r:SeriesDescription[@xml:lang=$lang]"/>
    </xsl:template>
    <xsl:template match="d:QuestionScheme">
        <div class="questionScheme">
            <xsl:attribute name="id">questionScheme-<xsl:value-of select="@id"/>
            </xsl:attribute>
            <a>
                <xsl:attribute name="name">questionScheme-<xsl:value-of select="@id"/>
                </xsl:attribute>
            </a>
            <h3 class="questionSchemeName">
                <xsl:value-of select="d:QuestionSchemeName[@xml:lang=$lang]"/>
            </h3>
            <ul class="questions">
                <xsl:for-each select="child::*">
                    <xsl:apply-templates select="."/>
                </xsl:for-each>
            </ul>
        </div>
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
    <xsl:template match="d:QuestionItem">
        <li class="question">
            <!-- use optional external question-id as id to the li-element -->
            <xsl:attribute name="id">question-<xsl:value-of select="r:UserID[@type='question_id']"/>
            </xsl:attribute>
            <a>
                <xsl:attribute name="name">question-<xsl:value-of select="r:UserID[@type='question_id']"/>
                </xsl:attribute>
            </a>
            <strong class="questionName">
                <xsl:value-of select="d:QuestionItemName[@xml:lang=$lang]"/>
            </strong>
            <xsl:choose>
                <xsl:when test="d:QuestionText[@xml:lang=$lang]/d:LiteralText/d:Text">
                    <xsl:value-of select="d:QuestionText[@xml:lang=$lang]/d:LiteralText/d:Text"/>
                </xsl:when>
                <xsl:otherwise>
                    <em>
                        <xsl:value-of select="d:QuestionText[@xml:lang=$fallback-lang]/d:LiteralText/d:Text"/>
                    </em>
                </xsl:otherwise>
            </xsl:choose>
            <!--
            <xsl:value-of select="r:VersionRationale"/> -->
            <xsl:apply-templates select="d:CodeDomain" />
            <xsl:apply-templates select="d:NumericDomain" />
        </li>
    </xsl:template>

    <xsl:template match="d:CodeDomain">
        <ul>
            <li class="codeDomain">
                <xsl:variable name="csID" select="r:CodeSchemeReference/r:ID" />

                <xsl:apply-templates select="//l:CodeScheme[@id = $csID]" />
            </li>
        </ul>

    </xsl:template>

    <xsl:template match="d:NumericDomain">
        <ul><li class="numreric"><xsl:value-of select="@type" /></li></ul>
    </xsl:template>

    <xsl:template match="l:CodeScheme">
        <table class="codeScheme">
            <tbody>
                <xsl:apply-templates select="l:Code"></xsl:apply-templates> 
            </tbody>
        </table>
    </xsl:template>


    <xsl:template match="l:Code">
        <tr>
            <td><xsl:value-of select="l:Value" /></td>
            <xsl:apply-templates select ="l:CategoryReference" />
        </tr>
    </xsl:template>

    <xsl:template match="l:CategoryReference">
        <xsl:variable name="csID" select="r:ID" />
        <xsl:apply-templates select="//l:Category[@id = $csID]" />
    </xsl:template>

    <xsl:template match="l:Category">
            <xsl:choose>
                <xsl:when test="@missing">
                    <td><em><xsl:value-of select="r:Label" /></em></td>
                </xsl:when>
                <xsl:otherwise>
                    <td><xsl:value-of select="r:Label" /></td>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>

    <xsl:template match="d:MultipleQuestionItem">
        <li class="question">
            <!-- use optional external question-id as id to the li-element -->
            <xsl:attribute name="id">question-<xsl:value-of select="r:UserID[@type='question_id']"/>
            </xsl:attribute>
            <strong class="questionName">
                <xsl:value-of select="d:MultipleQuestionItemName[@xml:lang=$lang]"/>
            </strong>
            <xsl:choose>
                <xsl:when test="d:QuestionText[@xml:lang=$lang]/d:LiteralText/d:Text">
                    <xsl:value-of select="d:QuestionText[@xml:lang=$lang]/d:LiteralText/d:Text"/>
                </xsl:when>
                <xsl:otherwise>
                    <em>
                        <xsl:value-of select="d:QuestionText[@xml:lang=$fallback-lang]/d:LiteralText/d:Text"/>
                    </em>
                </xsl:otherwise>
            </xsl:choose>
            <ul class="questions">
                <xsl:apply-templates select="d:SubQuestions"/>
            </ul>
        </li>
    </xsl:template>
    <xsl:template match="d:SubQuestions">
        <ul class="questions">
            <xsl:for-each select="child::*">
                <xsl:apply-templates select="."/>
            </xsl:for-each>
        </ul>
    </xsl:template>

    <xsl:template match="l:VariableScheme">
        <ul class="variables"> 
        <xsl:apply-templates select="l:Variable" />
        </ul>
    </xsl:template>

    <xsl:template match="l:Variable">
          <li>
              <strong><xsl:value-of select="l:VariableName"/></strong> <xsl:value-of select="r:Label"/>
              
          </li>
    </xsl:template>

    <xsl:template match="l:VariableSchemeReference">
        <xsl:variable name="vsID" select="r:ID" />
        <xsl:apply-templates select="//l:VariableScheme[@id = $vsID]" />
    </xsl:template>


</xsl:stylesheet>
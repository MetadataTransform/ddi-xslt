<!-- 
Copyright 2012 
Danish Data Archive (http://www.dda.dk) 
Swedish National Data Service (http://snd.gu.se)

This program is free software; you can redistribute it and/or modify it 
under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation; either Version 3 of the License, or 
(at your option) any later version.

This program is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU Lesser General Public License for more details.
 
You should have received a copy of the GNU Lesser General Public 
License along with this library; if not, write to the 
Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, 
Boston, MA  02110-1301  USA
The full text of the license is also available on the Internet at 
http://www.gnu.org/copyleft/lesser.html
-->
<xsl:stylesheet xmlns="http://www.icpsr.umich.edu/DDI" xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:g="ddi:group:3_1" xmlns:d="ddi:datacollection:3_1" xmlns:dce="ddi:dcelements:3_1"
  xmlns:c="ddi:conceptualcomponent:3_1" xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:a="ddi:archive:3_1" xmlns:m1="ddi:physicaldataproduct/ncube/normal:3_1"
  xmlns:ddi="ddi:instance:3_1" xmlns:m2="ddi:physicaldataproduct/ncube/tabular:3_1"
  xmlns:o="ddi:organizations:3_1" xmlns:l="ddi:logicalproduct:3_1"
  xmlns:m3="ddi:physicaldataproduct/ncube/inline:3_1" xmlns:pd="ddi:physicaldataproduct:3_1"
  xmlns:cm="ddi:comparative:3_1" xmlns:s="ddi:studyunit:3_1" xmlns:r="ddi:reusable:3_1"
  xmlns:pi="ddi:physicalinstance:3_1" xmlns:ds="ddi:dataset:3_1" xmlns:pr="ddi:profile:3_1"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0"
  xsi:schemaLocation="http://www.icpsr.umich.edu/DDI http://www.icpsr.umich.edu/DDI/Version1-2-2.xsd">

  <xsl:import href="ddi3_1_util.xsl"/>
  
  <!-- output -->
  <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
  <xsl:decimal-format name="euro" decimal-separator="," grouping-separator="."/>

  <!-- skip headers -->
  <xsl:template match="ddi:DDIInstance">
    <xsl:apply-templates select="s:StudyUnit"/>
  </xsl:template>

  <!-- do transformation -->
  <xsl:template match="s:StudyUnit">
    <codeBook>

      <!-- default study description -->
      <stdyDscr>
        <citation>
          <titlStmt>
              <titl><xsl:value-of select="r:Citation/r:Title"/></titl>
              <xsl:apply-templates select="r:Citation/r:AlternateTitle" />
              <xsl:apply-templates select="r:Citation/r:InternationalIdentifier" />
          </titlStmt>
        </citation>

        <prodStmt>
            <xsl:apply-templates select="r:FundingInformation" />
        </prodStmt>        
        <stdyInfo>
            <xsl:apply-templates select="s:Abstract" />
            <xsl:apply-templates select="r:Coverage" />
        </stdyInfo>
      </stdyDscr>

      <!-- default file description -->
      <fileDscr>
        <fileTxt ID="F1"/>
      </fileDscr>

      <!-- data description -->
      <dataDscr>
        <xsl:call-template name="variableGroup"/>
        <xsl:apply-templates select="*//l:Variable"/>
      </dataDscr>
    </codeBook>
  </xsl:template>
  
  <xsl:template match="r:AlternateTitle">
      <altTitl><xsl:value-of select="."/></altTitl>
  </xsl:template>
  
  <xsl:template match="s:Abstract">
      <abstract>
          <xsl:if test="r:Content/@xml:lang">
              <xsl:attribute name="xml:lang"><xsl:value-of select="r:Content/@xml:lang" /></xsl:attribute>
          </xsl:if>
          <xsl:value-of select="r:Content"/>
      </abstract>
  </xsl:template>

  <xsl:template match="r:Coverage">
      <xsl:if test="r:TopicalCoverage">
          <subject>
            <xsl:for-each select="r:TopicalCoverage/r:Subject | r:TopicalCoverage/r:Keyword">
                <keyword>
                    <xsl:if test="@xml:lang">
                        <xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang" /></xsl:attribute>
                    </xsl:if>          
                    <xsl:if test="@codeListID">
                        <xsl:attribute name="vocab"><xsl:value-of select="@codeListID" /></xsl:attribute>
                    </xsl:if>                                
                    <xsl:value-of select="."/>
                </keyword>
            </xsl:for-each>
          </subject>
      </xsl:if>
  </xsl:template>  
  
      
  <xsl:template match="r:InternationalIdentifier">
      <IDNo><xsl:value-of select="."/></IDNo>
  </xsl:template>  
  
  <xsl:template match="r:FundingInformation">
      <fundAg><xsl:value-of select="a:Organization[@id=r:AgencyOrganizationReference/r:ID]/a:OrganizationName"/></fundAg>
      <xsl:if test="r:GrantNumber">
        <grantNo><xsl:value-of select="r:GrantNumber"/></grantNo>
      </xsl:if>
  </xsl:template>

  <!-- variable groups defined by concepts -->
  <xsl:template name="variableGroup">
    <xsl:for-each select="*//c:Concept">
      <xsl:variable name="cId" select="@id"/>
      <xsl:variable name="name" select="@name"/>
      <xsl:variable name="varRefNames">
        <xsl:for-each
          select="../../../l:LogicalProduct/l:VariableScheme/l:Variable/l:ConceptReference">
          <xsl:if test="r:ID/text() = $cId ">
            <xsl:text> </xsl:text>
            <xsl:value-of select="../l:VariableName"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>

      <varGrp ID="VG{position()}" type="subject" var="">
        <xsl:attribute name="var">
          <xsl:value-of select="normalize-space($varRefNames)"/>
        </xsl:attribute>
        <labl>
          <xsl:call-template name="DisplayLabel"/>
        </labl>
      </varGrp>
    </xsl:for-each>
  </xsl:template>

  <!--  variables -->
  <xsl:template match="l:Variable">
    <xsl:variable name="varID" select="@id"/>
    <var>
      <!-- att ID -->
      <xsl:attribute name="ID">
        <xsl:text>V</xsl:text>
        <xsl:value-of select="position()"/>
      </xsl:attribute>

      <!-- att name -->
      <xsl:attribute name="name">
        <xsl:value-of select="l:VariableName"/>
      </xsl:attribute>

      <!-- att data file ref -->
      <xsl:attribute name="files">
        <!-- TODO using default file ref -->
        <xsl:text>F1</xsl:text>
      </xsl:attribute>

      <!-- att decimal position -->
      <xsl:attribute name="dcml">
        <xsl:choose>
          <xsl:when test="l:Representation/l:NumericRepresentation!=null"/>
          <xsl:otherwise>
            <xsl:text>0</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <!-- att intrvl -->
      <xsl:variable name="classificationLevel" select="*/@classificationLevel">
        <!-- CategoryRepresentation, CodeRepresentation, DateTimeRepresentation, ExternalCategoryRepresentation, GeographicRepresentation, NumericRepresentation, TextRepresentation -->
      </xsl:variable>
      <xsl:attribute name="intrvl">
        <xsl:choose>
          <xsl:when test="$classificationLevel!=null">
            <!-- TODO map from ddi-3.1 "Nominal"  "Ordinal"  "Interval"  "Ratio" "Continuous" -->
            <!-- to ddi-1.2.2 "discrete" "contin" -->
            <xsl:value-of select="$classificationLevel"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>contin</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <!-- location -->
      <!-- TODO location in file -->
      <location width="5" RecSegNo="1"/>

      <!-- label -->
      <labl>
        <xsl:choose>
          <xsl:when test="r:Label">
            <xsl:call-template name="DisplayLabel"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="r:Description">
              <xsl:call-template name="DisplayDescription"/>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </labl>

      <!-- 
        NOT implemented
          imputation
          security
          embargo
          respUnit
          anlysUnit          
       -->

      <!-- qstn question text -->
      <xsl:if test="l:QuestionReference">
        <qstn>
          <qstnLit>
            <xsl:variable name="qiID" select="l:QuestionReference/r:ID"/>

            <xsl:if
              test="count(../../../d:DataCollection/d:QuestionScheme/d:QuestionItem[@id = $qiID]/d:QuestionText/d:LiteralText/d:Text) > 0">
              <xsl:value-of
                select="../../../d:DataCollection/d:QuestionScheme/d:QuestionItem[@id = $qiID]/d:QuestionText/d:LiteralText/d:Text"
              />
            </xsl:if>

            <xsl:if
              test="count(../../../d:DataCollection/d:QuestionScheme/d:MultipleQuestionItem/d:SubQuestions/d:QuestionItem[@id = $qiID]/d:QuestionText/d:LiteralText/d:Text) > 0">
              <xsl:value-of
                select="../../../d:DataCollection/d:QuestionScheme/d:MultipleQuestionItem/d:SubQuestions/d:QuestionItem[@id = $qiID]/../../d:QuestionText/d:LiteralText/d:Text"/>
              <xsl:value-of
                select="../../../d:DataCollection/d:QuestionScheme/d:MultipleQuestionItem/d:SubQuestions/d:QuestionItem[@id = $qiID]/d:QuestionText/d:LiteralText/d:Text"
              />
            </xsl:if>
          </qstnLit>
        </qstn>
      </xsl:if>

      <!-- valrng -->
      <!-- TODO valid range aply to NumericRepresentation, CodeRepresentation 
        <valrng>
          <range UNITS="REAL" min="0.85" max="1.189"/>
        </valrng>
      -->

      <!-- invalrng -->
      <xsl:variable name="missingValue">
        <xsl:for-each select="l:Representation/l:NumericRepresentation">
          <xsl:value-of select="@missingValue"/>
        </xsl:for-each>
        <xsl:for-each select="l:Representation/l:CodeRepresentation">
          <xsl:value-of select="@missingValue"/>
        </xsl:for-each>
        <xsl:for-each select="l:Representation/l:CategoryRepresentation">
          <xsl:value-of select="@missingValue"/>
        </xsl:for-each>
        <xsl:for-each select="l:Representation/l:GeographicRepresentation">
          <xsl:value-of select="@missingValue"/>
        </xsl:for-each>
        <xsl:for-each select="l:Representation/l:DateTimeRepresentation">
          <xsl:value-of select="@missingValue"/>
        </xsl:for-each>
        <xsl:for-each select="l:Representation/l:TextRepresentation">
          <xsl:value-of select="@missingValue"/>
        </xsl:for-each>
      </xsl:variable>
      <xsl:if test="$missingValue!=''">
        <invalrng>
          <xsl:for-each select="tokenize($missingValue,' ')">
            <item UNITS="REAL" VALUE="{.}"/>
          </xsl:for-each>
        </invalrng>
      </xsl:if>

      <!--
        NOT implemented
        undocCod
        -->

      <!-- universe -->
      <xsl:for-each select="r:UniverseReference">
        <xsl:variable name="uID" select="r:ID"/>
        <xsl:for-each
          select="../../../../c:ConceptualComponent/c:UniverseScheme/c:Universe[@id = $uID]">
          <universe clusion="I">
            <xsl:call-template name="DisplayLabel"/>
          </universe>
        </xsl:for-each>
      </xsl:for-each>

      <!-- TotlResp -->
      <xsl:if
        test="l:Representation/l:NumericRepresentation or l:Representation/l:CodeRepresentation">
        <xsl:for-each
          select="../../../pi:PhysicalInstance/pi:Statistics/pi:VariableStatistics/pi:VariableReference[r:ID = $varID]">
          <xsl:if test="../pi:TotalResponses">
            <TotlResp>
              <xsl:value-of select="../pi:TotalResponses"/>
            </TotlResp>
          </xsl:if>
        </xsl:for-each>
      </xsl:if>

      <!-- sumStat vald invd -->
      <xsl:if
        test="l:Representation/l:NumericRepresentation or l:Representation/l:CodeRepresentation">
        <!-- using standard ddi cv for statistics urn:ddi-cv:SummaryStatisticType:1.0.0-->
        <xsl:for-each
          select="../../../pi:PhysicalInstance/pi:Statistics/pi:VariableStatistics/pi:VariableReference[r:ID = $varID]">
          <xsl:for-each select="../pi:SummaryStatistic">
            <xsl:if test="pi:SummaryStatisticTypeCoded = 'ValidCases'">
              <sumStat type="vald">
                <xsl:value-of select="pi:Value"/>
              </sumStat>
            </xsl:if>
            <xsl:if test="pi:SummaryStatisticTypeCoded = 'InvalidCases'">
              <sumStat type="invd">
                <xsl:value-of select="pi:Value"/>
              </sumStat>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:if>

      <!-- sumStat min max mean stdev -->
      <xsl:if test="l:Representation/l:NumericRepresentation">
        <!-- using standard ddi cv for statistics urn:ddi-cv:SummaryStatisticType:1.0.0-->
        <xsl:for-each
          select="../../../pi:PhysicalInstance/pi:Statistics/pi:VariableStatistics/pi:VariableReference[r:ID = $varID]">
          <xsl:for-each select="../pi:SummaryStatistic">
            <xsl:if test="pi:SummaryStatisticTypeCoded = 'Minimum'">
              <sumStat type="min">
                <xsl:value-of select="pi:Value"/>
              </sumStat>
            </xsl:if>
            <xsl:if test="pi:SummaryStatisticTypeCoded = 'Maximum'">
              <sumStat type="max">
                <xsl:value-of select="pi:Value"/>
              </sumStat>
            </xsl:if>
            <xsl:if test="pi:SummaryStatisticTypeCoded = 'ArithmeticMean'">
              <sumStat type="mean">
                <xsl:value-of select="pi:Value"/>
              </sumStat>
            </xsl:if>
            <xsl:if test="pi:SummaryStatisticTypeCoded = 'StandardDeviation'">
              <sumStat type="stdev">
                <xsl:value-of select="pi:Value"/>
              </sumStat>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:if>

      <!-- 
        NOT implemented
        txt
        stdCatgry
        catgryGrp
        -->

      <!-- catgry -->
      <xsl:if test="l:Representation/l:CodeRepresentation">
        <!-- define missing values -->
        <xsl:variable name="uoplyst">
          <xsl:call-template name="splitMissingValue">
            <xsl:with-param name="in-string" select="$missingValue"/>
            <xsl:with-param name="lastChar" select="'9'"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="irrelevant">
          <xsl:call-template name="splitMissingValue">
            <xsl:with-param name="in-string" select="$missingValue"/>
            <xsl:with-param name="lastChar" select="'0'"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="deltagerIkke">
          <xsl:call-template name="splitMissingValue">
            <xsl:with-param name="in-string" select="$missingValue"/>
            <xsl:with-param name="lastChar" select="'1'"/>
          </xsl:call-template>
        </xsl:variable>

        <!-- define  decimalPosition and code scheme id-->
        <xsl:variable name="decimalPosition"
          select="l:Representation/l:CodeRepresentation/@decimalPositions"/>
        <xsl:variable name="csID"
          select="l:Representation/l:CodeRepresentation/r:CodeSchemeReference/r:ID"/>

        <!-- do catVal by looping throgh statistics -->
        <xsl:if
          test="../../../pi:PhysicalInstance/pi:Statistics/pi:VariableStatistics/pi:VariableReference/r:ID = $varID">
          <xsl:for-each select="../../../pi:PhysicalInstance/pi:Statistics/pi:VariableStatistics">
            <!-- find statistics for current variable -->
            <xsl:if test="pi:VariableReference/r:ID = $varID">

              <!-- display statistics -->
              <xsl:call-template name="displayVariableStatistics">
                <xsl:with-param name="varId">
                  <xsl:value-of select="$varID"/>
                </xsl:with-param>
                <xsl:with-param name="csId">
                  <xsl:value-of select="$csID"/>
                </xsl:with-param>
                <xsl:with-param name="uoplyst">
                  <xsl:value-of select="$uoplyst"/>
                </xsl:with-param>
                <xsl:with-param name="irrelevant">
                  <xsl:value-of select="$irrelevant"/>
                </xsl:with-param>
                <xsl:with-param name="deltagerIkke">
                  <xsl:value-of select="$deltagerIkke"/>
                </xsl:with-param>
                <xsl:with-param name="decimalPosition">
                  <xsl:value-of select="$decimalPosition"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </xsl:for-each>
        </xsl:if>
      </xsl:if>

      <!--  
        NOT implemented
        codInstr
        verStmt
        concept [not used]
        derivation
        notes
       -->

      <!-- varFormat -->
      <xsl:choose>
        <xsl:when
          test="l:Representation/l:NumericRepresentation or l:Representation/l:CodeRepresentation">
          <varFormat>numeric</varFormat>
        </xsl:when>
        <xsl:otherwise>
          <varFormat>character</varFormat>
        </xsl:otherwise>
      </xsl:choose>

    </var>
  </xsl:template>

  <!-- display variable statistics: Parameters: varId -->
  <xsl:template name="displayVariableStatistics">
    <xsl:param name="varId"/>
    <xsl:param name="csId"/>
    <xsl:param name="uoplyst"/>
    <xsl:param name="irrelevant"/>
    <xsl:param name="deltagerIkke"/>
    <xsl:param name="decimalPosition"/>

    <!-- Statistics / Code / Category  -->
    <xsl:for-each select="pi:CategoryStatistics">
      <xsl:call-template name="displayCategoryStatistics">
        <xsl:with-param name="varID">
          <xsl:value-of select="$varId"/>
        </xsl:with-param>
        <xsl:with-param name="csID">
          <xsl:value-of select="$csId"/>
        </xsl:with-param>
        <xsl:with-param name="uoplyst">
          <xsl:value-of select="$uoplyst"/>
        </xsl:with-param>
        <xsl:with-param name="irrelevant">
          <xsl:value-of select="$irrelevant"/>
        </xsl:with-param>
        <xsl:with-param name="deltagerIkke">
          <xsl:value-of select="$deltagerIkke"/>
        </xsl:with-param>
        <xsl:with-param name="decimalPosition">
          <xsl:value-of select="$decimalPosition"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <!-- Split whitespace separated Missing Value string -->
  <!-- Parameters: lastChar -->
  <!-- Context: any -->
  <xsl:template name="splitMissingValue">
    <xsl:param name="in-string"/>
    <xsl:param name="lastChar"/>
    <xsl:choose>
      <xsl:when test="contains($in-string, ' ')">
        <xsl:variable name="integer">
          <xsl:choose>
            <xsl:when test="contains(substring-before($in-string, ' '),'.')">
              <xsl:value-of select="substring-before(substring-before($in-string, ' '),'.')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="substring-before($in-string, ' ')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="substring($integer, string-length($integer)) = $lastChar">
            <xsl:value-of select="$integer"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="splitMissingValue">
              <xsl:with-param name="in-string" select="substring-after($in-string, ' ')"/>
              <xsl:with-param name="lastChar" select="$lastChar"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- return string if lastChar is last char -->
        <xsl:choose>
          <xsl:when test="contains($in-string, '.')">
            <xsl:if
              test="substring(substring-before($in-string,'.'), string-length(substring-before($in-string,'.'))) = $lastChar">
              <xsl:value-of select="substring-before($in-string,'.')"/>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="substring($in-string, string-length($in-string)) = $lastChar">
              <xsl:value-of select="$in-string"/>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Display Category Statistics: 
  Context: CategoryStatistics -->
  <xsl:template name="displayCategoryStatistics">
    <xsl:param name="varID"/>
    <xsl:param name="csID"/>
    <xsl:param name="uoplyst"/>
    <xsl:param name="irrelevant"/>
    <xsl:param name="deltagerIkke"/>
    <xsl:param name="decimalPosition"/>
    <xsl:if test="count(pi:CategoryStatistic) > 0">
      <xsl:variable name="codeValue" select="pi:CategoryValue"/>
      <xsl:variable name="categoryRef">
        <xsl:value-of
          select="../../../../l:LogicalProduct/l:CodeScheme[@id=$csID]/l:Code[l:Value=$codeValue]/l:CategoryReference/r:ID"/>
        <xsl:for-each select="../../../../../g:ResourcePackage">
          <xsl:value-of
            select="l:CodeScheme[@id=$csID]/l:Code[l:Value=$codeValue]/l:CategoryReference/r:ID"/>
        </xsl:for-each>
      </xsl:variable>

      <!-- code value -->
      <catgry>
        <catValu>
          <xsl:choose>
            <xsl:when test="$decimalPosition = '0'">
              <xsl:value-of select="format-number($codeValue, '0', 'euro')"/>
            </xsl:when>
            <xsl:when test="$decimalPosition = '1'">
              <xsl:value-of select="format-number($codeValue, '0,0', 'euro')"/>
            </xsl:when>
            <xsl:when test="$decimalPosition = '2'">
              <xsl:value-of select="format-number($codeValue, '0,00', 'euro')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$codeValue"/>
            </xsl:otherwise>
          </xsl:choose>
        </catValu>

        <!-- category value -->
        <labl>
          <xsl:for-each
            select="../../../../l:LogicalProduct/l:CategoryScheme/l:Category[@id=$categoryRef]">
            <xsl:call-template name="DisplayLabel"/>
          </xsl:for-each>
          <xsl:for-each
            select="../../../../../g:ResourcePackage/l:CategoryScheme/l:Category[@id=$categoryRef]">
            <resource>
              <xsl:call-template name="DisplayLabel"/>
            </resource>
          </xsl:for-each>

          <!-- category value for missing values -->
          <xsl:if test="normalize-space($codeValue) = $uoplyst">
            <xsl:value-of select="$msg/*/entry[@key='Unknown']"/>
          </xsl:if>
          <xsl:if test="normalize-space($codeValue) = $irrelevant">
            <xsl:value-of select="$msg/*/entry[@key='Irrelevant']"/>
          </xsl:if>
          <xsl:if test="normalize-space($codeValue) = $deltagerIkke">
            <xsl:value-of select="$msg/*/entry[@key='NotParticipating']"/>
          </xsl:if>
        </labl>

        <!-- category statistic frequency -->
        <xsl:call-template name="displayCategoryStatistic">
          <xsl:with-param name="type" select="'Frequency'"/>
          <xsl:with-param name="value" select="$codeValue"/>
        </xsl:call-template>

      </catgry>
    </xsl:if>
  </xsl:template>

  <!-- category statistics-->
  <xsl:template name="displayCategoryStatistic">
    <xsl:param name="type"/>
    <xsl:param name="value"/>

    <xsl:for-each select="pi:CategoryStatistic">
      <!-- not using cv justed coded as Frequency -->
      <xsl:if test="$type = 'Frequency' and pi:CategoryStatisticTypeCoded = 'Frequency'">
        <catStat type="freq">
          <xsl:value-of select="format-number(pi:Value, &quot;0&quot;)"/>
        </catStat>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- DisplayInstructionText -->
  <!-- Context:  Instruction-->
  <xsl:template name="displayInstructionText">
    <xsl:choose>
      <xsl:when test="d:InstructionText/@xml:lang">
        <xsl:choose>
          <xsl:when test="d:InstructionText[@xml:lang=$lang]">
            <xsl:value-of select="d:InstructionText[@xml:lang=$lang]/d:LiteralText"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="d:InstructionText[@xml:lang=$fallback-lang]/d:LiteralText"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="d:InstructionText/d:LiteralText"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- DisplayStatementItemText -->
  <!-- Context:  StatementItem-->
  <xsl:template name="displayStatementItemText">
    <xsl:choose>
      <xsl:when test="d:DisplayText/@xml:lang">
        <xsl:choose>
          <xsl:when test="d:DisplayText[@xml:lang=$lang]">
            <xsl:value-of select="d:DisplayText[@xml:lang=$lang]/d:LiteralText"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="d:DisplayText[@xml:lang=$fallback-lang]/d:LiteralText"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="d:DisplayText/d:LiteralText"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

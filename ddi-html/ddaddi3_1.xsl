<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:g="ddi:group:3_1" xmlns:d="ddi:datacollection:3_1" xmlns:dce="ddi:dcelements:3_1" xmlns:c="ddi:conceptualcomponent:3_1" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:a="ddi:archive:3_1"
  xmlns:m1="ddi:physicaldataproduct/ncube/normal:3_1" xmlns:ddi="ddi:instance:3_1" xmlns:m2="ddi:physicaldataproduct/ncube/tabular:3_1" xmlns:o="ddi:organizations:3_1" xmlns:l="ddi:logicalproduct:3_1" xmlns:m3="ddi:physicaldataproduct/ncube/inline:3_1" xmlns:pd="ddi:physicaldataproduct:3_1"
  xmlns:cm="ddi:comparative:3_1" xmlns:s="ddi:studyunit:3_1" xmlns:r="ddi:reusable:3_1" xmlns:pi="ddi:physicalinstance:3_1" xmlns:ds="ddi:dataset:3_1" xmlns:pr="ddi:profile:3_1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0"
  xsi:schemaLocation="ddi:instance:3_1 http://www.ddialliance.org/sites/default/files/schema/ddi3.1/instance.xsd">

  <xsl:import href="ddi3_1.xsl"/>
  <xsl:import href="ddi3_1_util.xsl"/>

  <!--  svn version -->
  <xsl:param name="svn-revision">Revision: 260</xsl:param>
  
  <!-- show frequencies on numeric variable with missing values -->
  <xsl:param name="show-numeric-var-frequence">0</xsl:param>
  
  <!-- upper lower case translations-->
  <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyzæøå'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ'"/>

  <!-- output -->
  <xsl:output method="html" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" indent="yes"/>
  <xsl:decimal-format name="euro" decimal-separator="," grouping-separator="."/>

  <!-- study - universe - concepts inherited from ddi3_1.xsl -->
  
  <!-- variables and control constructs -->
  <xsl:template match="l:LogicalProduct">
    <div class="variableSchemes">
      <xsl:apply-templates select="l:VariableScheme"/>
    </div>
    <div class="ControlConstructScheme">
      <xsl:apply-templates select="../d:DataCollection/d:ControlConstructScheme"/>
    </div>
  </xsl:template>

  <!--  variables -->
  <xsl:template match="l:Variable">
    <xsl:variable name="varID" select="@id"/>
    <li class="variableName">
      <a>
        <xsl:attribute name="name"><xsl:value-of select="@id"/>.<xsl:value-of select="@version"/>
        </xsl:attribute>
      </a>
      <strong class="variableName">
        <xsl:value-of select="l:VariableName"/>
        <xsl:text> </xsl:text>
        <span class="label">
          <xsl:call-template name="DisplayLabel"/>
        </span>
      </strong>
        <xsl:if test="r:Description">
          <div class="description">
              <xsl:call-template name="DisplayDescription"/>
          </div>
        </xsl:if>
    </li>

    <ul>
      <!-- concept -->
      <xsl:variable name="cID" select="l:ConceptReference/r:ID"/>
      <xsl:if test="$cID">
        <li class="concepts">
          <xsl:for-each select="../../../c:ConceptualComponent/c:ConceptScheme/c:Concept[@id = $cID]">
            <a>
              <xsl:attribute name="href">#<xsl:value-of select="$cID"/>.<xsl:value-of select="@version"/>
              </xsl:attribute>
              <xsl:attribute name="title">
                <xsl:call-template name="DisplayDescription"/>
              </xsl:attribute>
              <xsl:call-template name="DisplayLabel"/>
            </a>
          </xsl:for-each>
        </li>
      </xsl:if>
      
      <!-- universe -->
      <xsl:if test="$show-universe = 1">
          <xsl:for-each select="r:UniverseReference">
            <xsl:variable name="uID" select="r:ID"/>
            <xsl:for-each select="../../../../c:ConceptualComponent/c:UniverseScheme/c:Universe[@id = $uID]">
              <li class="universes">
                <a>
                  <xsl:attribute name="href">#<xsl:value-of select="$uID"/>.<xsl:value-of select="@version"/></xsl:attribute>
                  <xsl:call-template name="DisplayLabel"/>
                </a>
               </li>
            </xsl:for-each>
          </xsl:for-each>
      </xsl:if>

      <!-- filter -->
      <xsl:variable name="filterInfo">
        <xsl:call-template name="traverseFilters">
          <xsl:with-param name="variableName">
            <xsl:value-of select="translate(l:VariableName, $lowercase, $uppercase)"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="$filterInfo != ''">
        <xsl:for-each select="$filterInfo">
          <li class="filteredby">
            <xsl:copy-of select="."/>
          </li>
        </xsl:for-each>
      </xsl:if>

      <!-- question text -->
      <xsl:if test="l:QuestionReference">
        <li class="questionsmargin">
          <xsl:variable name="qiID" select="l:QuestionReference/r:ID"/>
          <a>
            <xsl:attribute name="name">
              <xsl:value-of select="$qiID"/>
            </xsl:attribute>
          </a>

          <xsl:if test="count(../../../d:DataCollection/d:QuestionScheme/d:QuestionItem[@id = $qiID]/d:QuestionText/d:LiteralText/d:Text) > 0">
            <xsl:value-of select="../../../d:DataCollection/d:QuestionScheme/d:QuestionItem[@id = $qiID]/d:QuestionText/d:LiteralText/d:Text"/>
          </xsl:if>
          <xsl:if test="count(../../../d:DataCollection/d:QuestionScheme/d:MultipleQuestionItem/d:SubQuestions/d:QuestionItem[@id = $qiID]/d:QuestionText/d:LiteralText/d:Text) > 0">
            <span class="multipleQuestion">
              <xsl:value-of select="../../../d:DataCollection/d:QuestionScheme/d:MultipleQuestionItem/d:SubQuestions/d:QuestionItem[@id = $qiID]/../../d:QuestionText/d:LiteralText/d:Text"/>
            </span>
            <!--br/-->
            <div class="question">
              <xsl:value-of select="../../../d:DataCollection/d:QuestionScheme/d:MultipleQuestionItem/d:SubQuestions/d:QuestionItem[@id = $qiID]/d:QuestionText/d:LiteralText/d:Text"/>
            </div>
          </xsl:if>
        </li>
      </xsl:if>

      <!--  -->
      <!-- representation -->
      <!--  -->
      <!-- missing value  -->
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

      <!-- statistics -->
      <xsl:variable name="decimalPosition" select="l:Representation/l:NumericRepresentation/@decimalPositions"/>
      <xsl:if test="l:Representation/l:CodeRepresentation or 
        (l:Representation/l:NumericRepresentation and $show-numeric-var-frequence = 1 and $missingValue != '' and $filterInfo != '')">
        <xsl:variable name="csID" select="l:Representation/l:CodeRepresentation/r:CodeSchemeReference/r:ID"/>
        <xsl:if test="../../../pi:PhysicalInstance/pi:Statistics/pi:VariableStatistics/pi:VariableReference/r:ID = $varID">
          <li class="codeDomain">
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
          </li>
        </xsl:if>
      </xsl:if>
      <xsl:for-each select="../../../pi:PhysicalInstance/pi:Statistics/pi:VariableStatistics">
        <!-- find statistics for current variable -->
        <xsl:if test="pi:VariableReference/r:ID = $varID">
          <xsl:call-template name="displayMiminumMaximum"/>
        </xsl:if>
      </xsl:for-each>
      <xsl:apply-templates select="l:Representation/l:NumericRepresentation"/>
      <xsl:apply-templates select="l:Representation/l:TextRepresentation"/>
    </ul>

    <!-- numeric -->
    <xsl:for-each select="l:Representation/l:NumericRepresentation">
      <p>
        <xsl:call-template name="displayMissingValue"/>
      </p>
    </xsl:for-each>
    <!-- code -->
    <xsl:for-each select="l:Representation/l:CodeRepresentation">
      <xsl:if test="@classificationLevel">
        <p>
          <xsl:value-of select="$msg/*/entry[@key='Messure']"/>
          <xsl:text>: </xsl:text>
          <xsl:value-of select="@classificationLevel"/>
        </p>
      </xsl:if>
    </xsl:for-each>
    <!-- other -->
    <xsl:for-each select="l:Representation/l:CategoryRepresentation | 
      l:Representation/l:GeographicRepresentation | 
      l:Representation/l:DateTimeRepresentation | 
      l:Representation/l:TextRepresentation">
      <xsl:call-template name="displayMissingValue"/>
    </xsl:for-each>
  </xsl:template>

  <!-- display variable statistics: Parameters: varId -->
  <xsl:template name="displayVariableStatistics">
    <xsl:param name="varId"/>
    <xsl:param name="csId"/>
    <xsl:param name="uoplyst"/>
    <xsl:param name="irrelevant"/>
    <xsl:param name="deltagerIkke"/>
    <xsl:param name="decimalPosition"/>
    <!-- Main Statistic table - includes two tables -->
    <table class="table.categoryStatistics">
      <!-- table header - statistics table -->
      <tr>
        <td>
          <strong>%</strong>
        </td>
        <td>
          <strong>
            <xsl:value-of select="$msg/*/entry[@key='MD%']"/>
          </strong>
        </td>
        <td>
          <strong>
            <xsl:value-of select="$msg/*/entry[@key='Number']"/>
          </strong>
        </td>
        <td class="right">
          <strong>
            <xsl:value-of select="$msg/*/entry[@key='Code']"/>
          </strong>
        </td>
        <td class="left">
          <strong>
            <xsl:value-of select="$msg/*/entry[@key='Category']"/>
          </strong>
        </td>
      </tr>
      <!-- Statistics / Code / Category table -->
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

      <!-- Summary: -->
      <xsl:call-template name="displaySummary"/>
    </table>

    <!-- Total response rate: -->
    <xsl:for-each select="pi:SummaryStatistic">
      <xsl:if test="pi:SummaryStatisticTypeCoded[@otherValue = 'ValidPercent'] = 'UseOther'">
        <strong>
          <xsl:value-of select="$msg/*/entry[@key='ValidPercent']"/>
          <xsl:text>: </xsl:text>
        </strong>
        <xsl:value-of select="format-number(pi:Value, '0', 'euro')"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- Split whitespace separated string -->
  <!-- Parameters: in-string -->
  <!-- Context: any -->
  <xsl:template name="splitAtWhitespace">
    <xsl:param name="in-string"/>
    <xsl:choose>
      <xsl:when test="contains($in-string, ' ')">
        <xsl:value-of select="substring-before($in-string, ' ')"/>
        <xsl:text>, </xsl:text>
        <xsl:call-template name="splitAtWhitespace">
          <xsl:with-param name="in-string" select="substring-after($in-string, ' ')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$in-string"/>
        <xsl:text>.</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
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
            <xsl:if test="substring(substring-before($in-string,'.'), string-length(substring-before($in-string,'.'))) = $lastChar">
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
        <xsl:value-of select="../../../../l:LogicalProduct/l:CodeScheme[@id=$csID]/l:Code[l:Value=$codeValue]/l:CategoryReference/r:ID"/>
        <xsl:for-each select="../../../../../g:ResourcePackage">
          <xsl:value-of select="l:CodeScheme[@id=$csID]/l:Code[l:Value=$codeValue]/l:CategoryReference/r:ID"/>
        </xsl:for-each>
      </xsl:variable>
      <tr>
        <xsl:call-template name="displayCategoryStatistic">
          <xsl:with-param name="type" select="'Percent'"/>
        </xsl:call-template>
        <xsl:call-template name="displayCategoryStatistic">
          <xsl:with-param name="type" select="'ValidPercent'"/>
        </xsl:call-template>
        <xsl:call-template name="displayCategoryStatistic">
          <xsl:with-param name="type" select="'Frequency'"/>
        </xsl:call-template>
        <td class="right">
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
        </td>
        <td class="left">
          <xsl:for-each select="../../../../l:LogicalProduct/l:CategoryScheme/l:Category[@id=$categoryRef]">
            <xsl:call-template name="DisplayLabel"/>
          </xsl:for-each>
          <xsl:for-each select="../../../../../g:ResourcePackage/l:CategoryScheme/l:Category[@id=$categoryRef]">
            <resource>
              <xsl:call-template name="DisplayLabel"/>
            </resource>
          </xsl:for-each>

          <!-- test for Missing Values -->
          <xsl:if test="normalize-space($codeValue) = $uoplyst">
            <xsl:value-of select="$msg/*/entry[@key='Unknown']"/>
          </xsl:if>
          <xsl:if test="normalize-space($codeValue) = $irrelevant">
            <xsl:value-of select="$msg/*/entry[@key='Irrelevant']"/>
          </xsl:if>
          <xsl:if test="normalize-space($codeValue) = $deltagerIkke">
            <xsl:value-of select="$msg/*/entry[@key='NotParticipating']"/>
          </xsl:if>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>

  <!-- Display Category Statistic of a given type -->
  <!-- Parameter: type -->
  <!-- Context:  CategoryStatistics-->
  <xsl:template name="displayCategoryStatistic">
    <xsl:param name="type"/>

    <xsl:choose>
      <xsl:when test="$type = 'ValidPercent'">
        <xsl:if test="count(pi:CategoryStatistic/pi:CategoryStatisticTypeCoded[@otherValue = 'ValidPercent']) = 0">
          <td>
            <xsl:text> </xsl:text>
          </td>
        </xsl:if>
      </xsl:when>
    </xsl:choose>

    <xsl:for-each select="pi:CategoryStatistic">
      <xsl:if test="$type = 'Percent' and pi:CategoryStatisticTypeCoded = 'Percent'">
        <td align="right" valign="top">
          <xsl:value-of select="format-number(pi:Value, &quot;0&quot;)"/>
        </td>
      </xsl:if>
      <xsl:if test="$type = 'ValidPercent' and count(pi:CategoryStatisticTypeCoded[@otherValue = 'ValidPercent']) > 0">
        <td align="right" valign="top">
          <xsl:value-of select="format-number(pi:Value, &quot;0&quot;)"/>
        </td>
      </xsl:if>
      <xsl:if test="$type = 'Frequency' and pi:CategoryStatisticTypeCoded = 'Frequency'">
        <td align="right" valign="top">
          <xsl:value-of select="format-number(pi:Value, &quot;0&quot;)"/>
        </td>
      </xsl:if>
    </xsl:for-each>

  </xsl:template>

  <!-- Display Summary i.e. Sum Percent, Sum Valid Percent and Total Response  -->
  <!-- Concext: VariableStatistics -->
  <xsl:template name="displaySummary">
    <tr bgcolor="#C0C0C0">
      <xsl:for-each select="pi:SummaryStatistic">
        <xsl:if test="pi:SummaryStatisticTypeCoded[@otherValue = 'Percent'] = 'UseOther'">
          <td align="right">
            <xsl:if test="string-length(pi:Value) = 0">
              <xsl:text>?</xsl:text>
            </xsl:if>
            <xsl:if test="string-length(pi:Value) > 0">
              <xsl:value-of select="pi:Value"/>
            </xsl:if>
          </td>
        </xsl:if>
        <xsl:if test="pi:SummaryStatisticTypeCoded[@otherValue = 'ValidTotalPercent'] = 'UseOther'">
          <td align="right">
            <xsl:if test="string-length(pi:Value) = 0">
              <xsl:text>?</xsl:text>
            </xsl:if>
            <xsl:if test="string-length(pi:Value) > 0">
              <xsl:value-of select="pi:Value"/>
            </xsl:if>
          </td>
        </xsl:if>
      </xsl:for-each>
      <td align="right">
        <xsl:value-of select="pi:TotalResponses"/>
      </td>
    </tr>
  </xsl:template>

  <!-- Display minimum and maximum of SummaryStatistic -->
  <!-- Concext: VariableStatistics -->
  <xsl:template name="displayMiminumMaximum">
    <p>
      <xsl:for-each select="pi:SummaryStatistic">
        <xsl:if test="pi:SummaryStatisticTypeCoded = 'Minimum'">
          <xsl:if test="string-length(pi:Value) = 0">
            <xsl:text>?</xsl:text>
          </xsl:if>
          <xsl:if test="string-length(pi:Value) > 0">
            <xsl:value-of select="$msg/*/entry[@key='Interval']"/>
            <xsl:value-of select="pi:Value"/>
          </xsl:if>
        </xsl:if>
        <xsl:if test="pi:SummaryStatisticTypeCoded = 'Maximum'">
          <xsl:if test="string-length(pi:Value) = 0">
            <xsl:text>?</xsl:text>
          </xsl:if>
          <xsl:if test="string-length(pi:Value) > 0">
            <xsl:value-of select="$msg/*/entry[@key='To']"/>
            <xsl:value-of select="pi:Value"/>
          </xsl:if>
        </xsl:if>
      </xsl:for-each>
    </p>
  </xsl:template>

  <!-- Display MissingValue attribute -->
  <!-- Context: Code/Numeric/Text Representation -->
  <xsl:template name="displayMissingValue">
    <xsl:if test="@missingValue">
      <xsl:value-of select="$msg/*/entry[@key='MissingValue']"/>
      <xsl:call-template name="splitAtWhitespace">
        <xsl:with-param name="in-string" select="@missingValue"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- Get higher level ItThenElse - if any exists
    Parameters: ifth - id of low level IfThenElse
    Context: IfThenElse -->
  <xsl:template name="getHigherIfThenElse">
    <xsl:param name="ifth"/>
    <!-- get Sequence pointing to this IfThenElse via Control Constuct Reference -->
    <xsl:for-each select="../d:Sequence">
      <xsl:variable name="seqLabel" select="r:Label"/>
      <xsl:variable name="seqc" select="@id"/>
      <xsl:for-each select="./d:ControlConstructReference">
        <xsl:if test="r:ID=$ifth">
          <!-- Sequence found - get higher IfThenElse referring to this Sequence -->
          <xsl:for-each select="../../d:IfThenElse">
            <xsl:variable name="h-ifth" select="@id"/>
            <xsl:if test="d:ThenConstructReference/r:ID=$seqc or d:ElseConstructReference/r:ID=$seqc">
              <p/>
              <xsl:value-of select="$msg/*/entry[@key='FilteredBy']"/>
              <xsl:text>: </xsl:text>
              <xsl:call-template name="splitCondition">
                <xsl:with-param name="condition" select="d:IfCondition/r:Code"/>
              </xsl:call-template>
              <p/>
              <xsl:call-template name="getHigherIfThenElse">
                <xsl:with-param name="ifth" select="$h-ifth"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:for-each>
        </xsl:if>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <!-- Traverse QuestionItems:
    Parameters: 
    variableName - pseudo variable ID
    mquei - ID of parent Multiple Question Item - if any
    Context: QuestionItem -->
  <xsl:template name="traverseQuestionItem">
    <xsl:param name="variableName"/>
    <xsl:param name="mquei"/>
    <xsl:if test="r:UserID=$variableName">
      <xsl:variable name="quei" select="@id"/>
      <!-- get Question Construct -->
      <xsl:for-each select="../../d:ControlConstructScheme/d:QuestionConstruct | ../../../../d:ControlConstructScheme/d:QuestionConstruct">
        <xsl:if test="d:QuestionReference/r:ID=$quei or d:QuestionReference/r:ID=$mquei">
          <xsl:variable name="quec" select="@id"/>
          <!-- get Sequence pointing to Question Construct via Control Constuct Reference -->
          <xsl:for-each select="../d:Sequence">
            <xsl:variable name="seqc" select="@id"/>
            <xsl:for-each select="d:ControlConstructReference[r:ID=$quec]">
              <!-- get IfThenElse pointing to this Sequence -->
              <xsl:for-each select="../../d:IfThenElse">
                <xsl:variable name="ifth" select="@id"/>
                <xsl:if test="d:ThenConstructReference/r:ID=$seqc or d:ElseConstructReference/r:ID=$seqc">
                  <!--p-->
                  <xsl:value-of select="$msg/*/entry[@key='FilteredBy']"/>
                  <xsl:text>: </xsl:text>
                  <xsl:call-template name="splitCondition">
                    <xsl:with-param name="condition" select="d:IfCondition/r:Code"/>
                  </xsl:call-template>
                  <!--/p-->
                  <xsl:call-template name="getHigherIfThenElse">
                    <xsl:with-param name="ifth" select="$ifth"/>
                  </xsl:call-template>
                </xsl:if>
              </xsl:for-each>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <!-- Traverse Filters:
  Parameters: variableName
  Context: Variable -->
  <xsl:template name="traverseFilters">
    <xsl:param name="variableName"/>
    <!-- get Question Item of current variable name  -->
    <xsl:for-each select="../../../d:DataCollection/d:QuestionScheme/d:QuestionItem">
      <xsl:call-template name="traverseQuestionItem">
        <xsl:with-param name="variableName" select="$variableName"/>
        <xsl:with-param name="mquei"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="../../../d:DataCollection/d:QuestionScheme/d:MultipleQuestionItem/d:SubQuestions/d:QuestionItem">
      <xsl:call-template name="traverseQuestionItem">
        <xsl:with-param name="variableName" select="$variableName"/>
        <xsl:with-param name="mquei" select="../../@id"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <!-- Split condition to enable wrap lines 
   Prameters
   condition - condition to split
  -->
  <xsl:template name="splitCondition">
    <xsl:param name="condition"/>
    <xsl:variable name="and" select="replace($condition,'&amp;&amp;', ' &amp;&amp; ')"/>
    <xsl:variable name="or" select="replace($and,'\|\|', ' || ')"/>
    <xsl:value-of select="$or"/>
  </xsl:template>

  <!-- Instrumentation -->
  <xsl:template match="d:ControlConstructScheme">
    <h3>
      <xsl:value-of select="$msg/*/entry[@key='Instrumentation']"/>
    </h3>
    <xsl:variable name="mainSeqId" select="../d:Instrument/d:ControlConstructReference/r:ID"/>

    <!-- Main sequence -->
    <xsl:for-each select="d:Sequence">
      <xsl:if test="@id = $mainSeqId">
        <h4>
          <xsl:value-of select="$msg/*/entry[@key='MainSequence']"/>
        </h4>
        <div class="instrumentation">
          <ul class="sequences">
            <xsl:call-template name="sequenceLabel"/>
            <xsl:call-template name="sequence"/>
          </ul>
        </div>
      </xsl:if>
    </xsl:for-each>

    <!-- All other sequences -->
    <h4>
      <xsl:value-of select="$msg/*/entry[@key='Sequences']"/>
    </h4>
    <div class="instrumentation">
      <ul class="sequences">
        <xsl:for-each select="d:Sequence">
          <xsl:choose>
            <xsl:when test="not($mainSeqId)">
              <xsl:call-template name="sequenceLabel"/>
              <xsl:call-template name="sequence"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="@id != $mainSeqId">
                <xsl:call-template name="sequenceLabel"/>
                <xsl:call-template name="sequence"/>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:template>

  <!-- Render Sequence Label -->
  <!-- Context:  Sequence-->
  <xsl:template name="sequenceLabel">
    <li class="sequences">
      <a>
        <xsl:attribute name="name"><xsl:value-of select="@id"/>.<xsl:value-of select="@version"/>
        </xsl:attribute>
      </a>
      <strong>
        <xsl:value-of select="r:Label"/>
      </strong>
    </li>
  </xsl:template>

  <!-- Sequences -->
  <!-- Context:  Sequence-->
  <xsl:template name="sequence">
    <ul class="padleft">
      <xsl:for-each select="d:ControlConstructReference">
        <xsl:variable name="qcId" select="r:ID"/>

        <!-- look for Question Constructs -->
        <xsl:for-each select="../../d:QuestionConstruct[@id=$qcId]">
          <!--  Question Item -->
          <xsl:variable name="qrId" select="d:QuestionReference/r:ID"/>

          <!--  look for Interview Instructions -->
          <xsl:for-each select="d:InterviewerInstructionReference">
            <xsl:variable name="iiId" select="r:ID"/>
            <xsl:for-each select="../../../d:InterviewerInstructionScheme/d:Instruction[@id=$iiId]">
              <li class="instructions">
                <!-- <xsl:xsl:call-template name="DisplayLabel"/><xsl:text>: </xsl:text> -->
                <xsl:call-template name="DisplayInstructionText"/>
                <xsl:if test="string-length(d:InstructionText/d:ConditionalText) > 0">
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="$msg/*/entry[@key='If']"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="d:InstructionText/d:ConditionalText/d:Expression/r:Code"/>
                </xsl:if>
              </li>
            </xsl:for-each>
          </xsl:for-each>

          <xsl:for-each select="../../d:QuestionScheme/d:QuestionItem[@id=$qrId] |
                      ../../d:QuestionScheme/d:MultipleQuestionItem[@id=$qrId]/d:SubQuestions/d:QuestionItem">
            <xsl:variable name="userId" select="r:UserID"/>
            <xsl:variable name="qId" select="@id"/>

            <li class="questions">
              <!-- get anchor of variable referencing this question item -->
              <xsl:for-each select="../../../../../l:LogicalProduct/l:VariableScheme/l:Variable |
                      ../../../l:LogicalProduct/l:VariableScheme/l:Variable">
                <xsl:if test="l:QuestionReference/r:ID = $qId">
                  <a>
                    <xsl:attribute name="href">#<xsl:value-of select="@id"/>.<xsl:value-of select="@version"/></xsl:attribute>
                    <xsl:value-of select="$userId"/>
                  </a>
                </xsl:if>
              </xsl:for-each>
              <xsl:text>: </xsl:text>
              <xsl:value-of select="d:QuestionText"/>
            </li>
          </xsl:for-each>
        </xsl:for-each>

        <!-- look for statement items -->
        <xsl:if test="../../d:StatementItem[@id=$qcId]">
          <li class="statements">
            <!-- xsl:value-of select="../../d:StatementItem[@id=$qcId]/r:Label"/-->
            <xsl:for-each select="../../d:StatementItem[@id=$qcId]">
              <xsl:call-template name="DisplayStatementItemText"/>
            </xsl:for-each>
          </li>
        </xsl:if>

        <!-- look for ifthenelse -->
        <xsl:for-each select="../../d:IfThenElse[@id=$qcId]">
          <li class="ifthenelses">
            <xsl:text>If </xsl:text>
            <xsl:call-template name="splitCondition">
              <xsl:with-param name="condition" select="d:IfCondition/r:Code"/>
            </xsl:call-template>
            <xsl:variable name="tid" select="d:ThenConstructReference/r:ID"/>
            <xsl:variable name="tversion" select="d:ThenConstructReference/r:Version"/>
            <xsl:variable name="eid" select="d:ElseConstructReference/r:ID"/>
            <xsl:variable name="eversion" select="d:ElseConstructReference/r:Version"/>
            <xsl:text> then </xsl:text>
            <a>
              <xsl:attribute name="href">#<xsl:value-of select="$tid"/><xsl:text>.</xsl:text><xsl:value-of select="$tversion"/></xsl:attribute>
              <xsl:value-of select="../d:Sequence[@id=$tid]/r:Label"/>
            </a>
            <xsl:if test="$eid">
              <xsl:text> else </xsl:text>
              <!--xsl:value-of select="schema-element(../d:ControlConstruct[@id=$eid])/r:Label"/-->
              <xsl:value-of select="../d:Sequence[@id=$eid]/r:Label"/>
            </xsl:if>
          </li>
        </xsl:for-each>

        <!-- look for sequences -->
        <xsl:for-each select="../../d:Sequence[@id=$qcId]">
          <xsl:variable name="seq" select="../../d:Sequence[@id=$qcId]"/>
          <li class="subsequences">
            <a>
              <xsl:attribute name="href">#<xsl:value-of select="@id"/>.<xsl:value-of select="@version"/>
              </xsl:attribute>
              <xsl:value-of select="r:Label"/>
            </a>
          </li>
        </xsl:for-each>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <!-- DisplayInstructionText -->
  <!-- Context:  Instruction-->
  <xsl:template name="DisplayInstructionText">
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
  <xsl:template name="DisplayStatementItemText">
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

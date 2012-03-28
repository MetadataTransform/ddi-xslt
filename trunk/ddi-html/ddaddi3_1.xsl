<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:g="ddi:group:3_1" xmlns:d="ddi:datacollection:3_1" xmlns:dce="ddi:dcelements:3_1" xmlns:c="ddi:conceptualcomponent:3_1" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:a="ddi:archive:3_1"
  xmlns:m1="ddi:physicaldataproduct/ncube/normal:3_1" xmlns:ddi="ddi:instance:3_1" xmlns:m2="ddi:physicaldataproduct/ncube/tabular:3_1" xmlns:o="ddi:organizations:3_1" xmlns:l="ddi:logicalproduct:3_1" xmlns:m3="ddi:physicaldataproduct/ncube/inline:3_1" xmlns:pd="ddi:physicaldataproduct:3_1"
  xmlns:cm="ddi:comparative:3_1" xmlns:s="ddi:studyunit:3_1" xmlns:r="ddi:reusable:3_1" xmlns:pi="ddi:physicalinstance:3_1" xmlns:ds="ddi:dataset:3_1" xmlns:pr="ddi:profile:3_1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0"
  xsi:schemaLocation="ddi:instance:3_1 http://www.ddialliance.org/sites/default/files/schema/ddi3.1/instance.xsd">

  <xsl:import href="ddi3_1.xsl"/>

  <!--  SVN version -->
  <xsl:param name="svn-revision">0.1.1</xsl:param>
  <!-- render text-elements of this language-->
  <xsl:param name="lang">da</xsl:param>
  <!-- if the requested language is not found for e.g. questionText, use fallback language-->
  <xsl:param name="fallback-lang">en</xsl:param>
  <!-- render all html-elements or just the content of body-->
  <xsl:param name="render-as-document">true</xsl:param>
  <!-- include interactive js and jquery for navigation (external links to eXist)-->
  <xsl:param name="include-js">0</xsl:param>
  <!-- print anchors for eg QuestionItems-->
  <xsl:param name="print-anchor">1</xsl:param>
  <!-- show the title (and subtitle, creator, etc.) of the study-->
  <xsl:param name="show-study-title">1</xsl:param>
  <!-- show the abstract as part of study-information-->
  <xsl:param name="show-abstract">0</xsl:param>
  <!-- show the questions as a separate flow from the variables-->
  <xsl:param name="show-questionnaires">0</xsl:param>
  <!-- show variable navigation-bar-->
  <xsl:param name="show-navigration-bar">0</xsl:param>
  <!-- show inline variable toc-->
  <xsl:param name="show-inline-toc">1</xsl:param>
  <!-- show study-information-->
  <xsl:param name="show-study-information">1</xsl:param>
  <!-- path prefix to the css-files-->
  <xsl:param name="theme-path">theme/default</xsl:param>
  
  <!-- path prefix (used for css, js when rendered on the web)-->
  <xsl:param name="path-prefix">.</xsl:param>

  <xsl:param name="translations">i18n/messages_da.properties.xml</xsl:param>
  <xsl:variable name="msg" select="document($translations)"/>
  <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyzæøå'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ'"/>

  <xsl:output method="html" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" indent="yes"/>

  <!-- DisplayLabel -->
  <!-- Context:  Variable, Concept, Category-->
  <xsl:template name="DisplayLabel">
    <xsl:choose>
      <xsl:when test="r:Label/@xml:lang">
        <xsl:choose>
          <xsl:when test="r:Label[@xml:lang=$lang]">
            <xsl:value-of select="r:Label[@xml:lang=$lang]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="r:Label[@xml:lang=$fallback-lang]"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="r:Label"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--  Variables -->
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
        <xsl:call-template name="DisplayLabel"/>
      </strong>
      <xsl:if test="count(l:ConceptReference) > 0">
        <xsl:variable name="cID" select="l:ConceptReference/r:ID"/>
        <li class="concepts">
          <xsl:for-each select="../../../c:ConceptualComponent/c:ConceptScheme/c:Concept[@id = $cID]">
            <xsl:call-template name="DisplayLabel"/>
          </xsl:for-each>
        </li>
      </xsl:if>
      <!-- Question Text: -->
      <li class="questions">
        <xsl:variable name="qiID" select="l:QuestionReference/r:ID"/>
        <xsl:if test="count(../../../d:DataCollection/d:QuestionScheme/d:QuestionItem[@id = $qiID]/d:QuestionText/d:LiteralText/d:Text) > 0">
          <xsl:value-of select="../../../d:DataCollection/d:QuestionScheme/d:QuestionItem[@id = $qiID]/d:QuestionText/d:LiteralText/d:Text"/>
        </xsl:if>
        <xsl:if test="count(../../../d:DataCollection/d:QuestionScheme/d:MultipleQuestionItem/d:SubQuestions/d:QuestionItem[@id = $qiID]/d:QuestionText/d:LiteralText/d:Text) > 0">
          <i>
            <xsl:value-of select="../../../d:DataCollection/d:QuestionScheme/d:MultipleQuestionItem/d:SubQuestions/d:QuestionItem[@id = $qiID]/../../d:QuestionText/d:LiteralText/d:Text"/>
            <xsl:text>: </xsl:text>
          </i>
          <div class="question">
            <xsl:value-of select="../../../d:DataCollection/d:QuestionScheme/d:MultipleQuestionItem/d:SubQuestions/d:QuestionItem[@id = $qiID]/d:QuestionText/d:LiteralText/d:Text"/>
          </div>
        </xsl:if>
      </li>
      <a>
        <!-- Filter: -->
        <xsl:call-template name="traverseFilters">
          <xsl:with-param name="variableName">
            <xsl:value-of select="translate(l:VariableName, $lowercase, $uppercase)"/>
          </xsl:with-param>
        </xsl:call-template>
      </a>
      <!-- Representation: -->
      <!-- Missing Value  -->
      <xsl:variable name="missingValue">
        <xsl:for-each select="l:Representation/l:NumericRepresentation"><xsl:value-of select="@missingValue"/></xsl:for-each>
        <xsl:for-each select="l:Representation/l:CodeRepresentation"><xsl:value-of select="@missingValue"/></xsl:for-each>
        <xsl:for-each select="l:Representation/l:CategoryRepresentation"><xsl:value-of select="@missingValue"/></xsl:for-each>
        <xsl:for-each select="l:Representation/l:GeographicRepresentation"><xsl:value-of select="@missingValue"/></xsl:for-each>
        <xsl:for-each select="l:Representation/l:DateTimeRepresentation"><xsl:value-of select="@missingValue"/></xsl:for-each>
        <xsl:for-each select="l:Representation/l:TextRepresentation"><xsl:value-of select="@missingValue"/></xsl:for-each>
      </xsl:variable>
      <xsl:variable name="uoplyst">
        <xsl:call-template name="splitMissingValue"><xsl:with-param name="in-string" select="$missingValue"/><xsl:with-param name="lastChar" select="'9'"/></xsl:call-template>
      </xsl:variable>
      <xsl:variable name="irrelevant">        
        <xsl:call-template name="splitMissingValue"><xsl:with-param name="in-string" select="$missingValue"/><xsl:with-param name="lastChar" select="'0'"/></xsl:call-template>
      </xsl:variable>
      <xsl:variable name="deltagerIkke">
        <xsl:call-template name="splitMissingValue"><xsl:with-param name="in-string" select="$missingValue"/><xsl:with-param name="lastChar" select="'1'"/></xsl:call-template>
      </xsl:variable>
      
      <!-- - Numeric -->
      <xsl:for-each select="l:Representation/l:NumericRepresentation">
        <p>
          <xsl:for-each select="r:NumberRange">
            <xsl:value-of select="$msg/*/entry[@key='Interval']"/>
            <xsl:value-of select="r:Low"/>
            <xsl:value-of select="$msg/*/entry[@key='To']"/>
            <xsl:value-of select="r:High"/>
          </xsl:for-each>
          <xsl:call-template name="displayMissingValue"/>
        </p>
      </xsl:for-each>
      <!-- Code -->
      <xsl:for-each select="l:Representation/l:CodeRepresentation">
        <xsl:if test="@classificationLevel">
          <p>
            <xsl:value-of select="$msg/*/entry[@key='Messure']"/><xsl:text>: </xsl:text>
            <xsl:value-of select="@classificationLevel"/>
          </p>
        </xsl:if>
      </xsl:for-each>
      <!-- Other -->
      <xsl:for-each select="l:Representation/l:CategoryRepresentation | 
        l:Representation/l:GeographicRepresentation | 
        l:Representation/l:DateTimeRepresentation | 
        l:Representation/l:TextRepresentation">
        <xsl:call-template name="displayMissingValue"/>
      </xsl:for-each>
      
      <!-- Statistics: -->
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
              </xsl:call-template>
            </xsl:if>
          </xsl:for-each>
        </li>
      </xsl:if>
      <xsl:apply-templates select="l:Representation/l:NumericRepresentation"/>
      <xsl:apply-templates select="l:Representation/l:TextRepresentation"/>
    </li>
  </xsl:template>

  <!-- Display Variable Statistics: 
    Parameters: varId -->
  <xsl:template name="displayVariableStatistics">
    <xsl:param name="varId"/>
    <xsl:param name="csId"/>
    <xsl:param name="uoplyst"/>
    <xsl:param name="irrelevant"/>
    <xsl:param name="deltagerIkke"/>
    <!-- Main Statistic table - includes two tables -->
    <table class="table.categoryStatistics">
      <tr>
        <td valign="top">
          <!-- Statistics / Code / Category table -->
          <table class="table.categoryStatistics">
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
              </xsl:call-template>
            </xsl:for-each>

            <!-- Summary: -->
            <xsl:call-template name="displaySummary"/>
          </table>
        </td>
      </tr>
    </table>

    <!-- Total response rate: -->
    <xsl:for-each select="pi:SummaryStatistic">
      <xsl:if test="pi:SummaryStatisticTypeCoded[@otherValue = 'ValidPercent'] = 'UseOther'">
        <strong>
          <xsl:value-of select="$msg/*/entry[@key='ValidPercent']"/>
          <xsl:text>: </xsl:text>
        </strong>
        <xsl:value-of select="pi:Value"/>
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
    <xsl:if test="count(pi:CategoryStatistic) > 0">
      <xsl:variable name="codeValue" select="pi:CategoryValue"/>
      <xsl:variable name="categoryRef" select="../../../../l:LogicalProduct/l:CodeScheme[@id=$csID]/l:Code[l:Value=$codeValue]/l:CategoryReference/r:ID"/>
      
        <xsl:if test="(position() = 1)">
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
            <td>
              <strong>
                <xsl:value-of select="$msg/*/entry[@key='Code']"/>
              </strong>
            </td>
            <td  class="left">
              <strong>
                <xsl:value-of select="$msg/*/entry[@key='Category']"/>
              </strong>
            </td>
          </tr>
        </xsl:if>
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
          <td>
            <xsl:value-of select="$codeValue"/>
          </td>
          <td class="left">
            <xsl:for-each select="../../../../l:LogicalProduct/l:CategoryScheme/l:Category[@id=$categoryRef]">
                <xsl:call-template name="DisplayLabel"/>
            </xsl:for-each>
            
            <!-- test for Missing Values --> 
            <xsl:if test="normalize-space($codeValue) = $uoplyst">
              <xsl:value-of select="$msg/*/entry[@key='Unknown']"/>
            </xsl:if>
            <xsl:if test="normalize-space($codeValue) = $irrelevant">
              <xsl:value-of select="$msg/*/entry[@key='Irrelevant']"/>
            </xsl:if>
            <xsl:if test="normalize-space($codeValue) = $deltagerIkke">
              <xsl:value-of select="$msg/*/entry[@key='NotParticiparing']"/>
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
          <xsl:value-of select="pi:Value"/>
        </td>
      </xsl:if>
      <xsl:if test="$type = 'ValidPercent' and count(pi:CategoryStatisticTypeCoded[@otherValue = 'ValidPercent']) > 0">
        <td align="right" valign="top">
          <xsl:value-of select="pi:Value"/>
        </td>
      </xsl:if>
      <xsl:if test="$type = 'Frequency' and pi:CategoryStatisticTypeCoded = 'Frequency'">
        <td align="right" valign="top">
          <xsl:value-of select="pi:Value"/>
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
  
  <!-- Display MissingValue attribute -->
  <!-- Context: Code/Numeric/Text Representation -->
  <xsl:template name="displayMissingValue">
    <br/>
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
              <p>
                <xsl:value-of select="$msg/*/entry[@key='FilteredBy']"/>
                <xsl:text>: </xsl:text>
                <xsl:value-of select="d:IfCondition/r:Code"/>
              </p>
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
                  <p>
                    <xsl:value-of select="$msg/*/entry[@key='FilteredBy']"/>
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="d:IfCondition/r:Code"/>
                  </p>
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

</xsl:stylesheet>

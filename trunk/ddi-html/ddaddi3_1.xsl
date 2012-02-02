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
  xsi:schemaLocation="ddi:instance:3_1 file:///home/dak/ddi/DDI_3_1_2009-10-18_Documentation_XMLSchema/XMLSchema/instance.xsd">

  <xsl:import href="ddi3_1.xsl"/>

  <!--  SVN version -->
  <xsl:param name="svn-revision">$Revision: 103 $</xsl:param>
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

  <xsl:output method="html" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" indent="yes"/>

  <!--  Variables -->
  <xsl:template match="l:Variable">
    <xsl:variable name="varID" select="@id"/>
    <li>
      <a>
        <xsl:attribute name="name"><xsl:value-of select="@id"/>.<xsl:value-of select="@version"/>
        </xsl:attribute>
      </a>
      <strong class="variableName">
        <xsl:value-of select="l:VariableName"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="r:Label"/>
      </strong>
      <xsl:if test="count(l:ConceptReference) > 0">
        <xsl:variable name="cID" select="l:ConceptReference/r:ID"/>
        <li class="concepts">
          <xsl:value-of select="../../../c:ConceptualComponent/c:ConceptScheme/c:Concept[@id = $cID]/r:Label"/>
        </li>
      </xsl:if>
      <li class="questions">
        <xsl:variable name="qiID" select="l:QuestionReference/r:ID"/>
        <xsl:if test="count(../../../d:DataCollection/d:QuestionScheme/d:QuestionItem[@id = $qiID]/d:QuestionText/d:LiteralText/d:Text) > 0">
          <xsl:value-of select="../../../d:DataCollection/d:QuestionScheme/d:QuestionItem[@id = $qiID]/d:QuestionText/d:LiteralText/d:Text"/>
        </xsl:if>
        <xsl:if test="count(../../../d:DataCollection/d:QuestionScheme/d:MultipleQuestionItem/d:SubQuestions/d:QuestionItem[@id = $qiID]/d:QuestionText/d:LiteralText/d:Text) > 0">
          <xsl:value-of select="../../../d:DataCollection/d:QuestionScheme/d:MultipleQuestionItem/d:SubQuestions/d:QuestionItem[@id = $qiID]/d:QuestionText/d:LiteralText/d:Text"/>
        </xsl:if>
      </li>
      <a>
        <xsl:call-template name="showFilter">
          <xsl:with-param name="variableName">
            <xsl:value-of select="l:VariableName"/>
          </xsl:with-param>
        </xsl:call-template>
      </a>
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

    <!-- Main Statistic table - includes two tables -->
    <table class="table.categoryStatistics">
      <tr>
        <td valign="top">
          <!-- Statistics table -->
          <table class="table.categoryStatistics">
            <xsl:for-each select="pi:CategoryStatistics">
              <xsl:call-template name="displayCategoryStatistics">
                <xsl:with-param name="varID">
                  <xsl:value-of select="$varId"/>
                </xsl:with-param>
                <xsl:with-param name="csID">
                  <xsl:value-of select="$csId"/>
                </xsl:with-param>
                <xsl:with-param name="codeCat">
                  <xsl:value-of select="'false'"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:for-each>
            
            <!-- Summary: -->
            <xsl:call-template name="displaySummary"/>
          </table>
        </td>

        <!-- Code / Category table -->
        <td valign="top">
          <table class="table.categoryStatistics">
            <xsl:for-each select="pi:CategoryStatistics">
              <xsl:call-template name="displayCategoryStatistics">
                <xsl:with-param name="varID">
                  <xsl:value-of select="$varId"/>
                </xsl:with-param>
                <xsl:with-param name="csID">
                  <xsl:value-of select="$csId"/>
                </xsl:with-param>
                <xsl:with-param name="codeCat">
                  <xsl:value-of select="'true'"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:for-each>
          </table>
        </td>
      </tr>
    </table>

    <!-- Total response rate: -->
    <xsl:for-each select="pi:SummaryStatistic">
      <xsl:if test="pi:SummaryStatisticTypeCoded[@otherValue = 'ValidPercent'] = 'UseOther'">
        <strong><xsl:value-of select="$msg/*/entry[@key='ValidPercent']"/><xsl:text>: </xsl:text></strong><xsl:value-of select="pi:Value"/>
      </xsl:if>
      </xsl:for-each>

  </xsl:template>

  <!-- Display Category Statistics: 
    Parameters: varID -->
  <xsl:template name="displayCategoryStatistics">
    <xsl:param name="varID"/>
    <xsl:param name="csID"/>
    <xsl:param name="codeCat"/>
    <xsl:if test="count(pi:CategoryStatistic) > 0">
      <xsl:variable name="codeValue" select="pi:CategoryValue"/>

      <xsl:if test="$codeCat = 'false'">
        <xsl:if test="(position() = 1)">
          <!-- table header - statistics table -->
          <tr>
            <td align="right">
              <strong>%</strong>
            </td>
            <td align="right">
              <strong><xsl:value-of select="$msg/*/entry[@key='MD%']"/></strong>
            </td>
            <td align="right">
              <strong><xsl:value-of select="$msg/*/entry[@key='Number']"/></strong>
            </td>
          </tr>
        </xsl:if>
        <tr>
<!--          <xsl:for-each select="pi:CategoryStatistic">
            <xsl:apply-templates select="."/>
            </xsl:for-each>-->
          <xsl:call-template name="displayCategoryStatistic">
            <xsl:with-param name="type" select="'Percent'"/>
          </xsl:call-template>
          <xsl:call-template name="displayCategoryStatistic">
            <xsl:with-param name="type" select="'ValidPercent'"/>
          </xsl:call-template>
          <xsl:call-template name="displayCategoryStatistic">
            <xsl:with-param name="type" select="'Frequency'"/>
          </xsl:call-template>
        </tr>
      </xsl:if>

      <xsl:if test="$codeCat = 'true'">
        <xsl:if test="position() = 1">
          <!-- table header - code / category table -->
          <tr>
            <td align="right">
              <strong><xsl:value-of select="$msg/*/entry[@key='Code']"/></strong>
            </td>
            <td align="left">
              <strong><xsl:value-of select="$msg/*/entry[@key='Category']"/></strong>
            </td>
          </tr>
        </xsl:if>
        <tr>
          <td align="right">
            <xsl:value-of select="$codeValue"/>
          </td>
          <td align="left">
            <xsl:for-each select="../../../../l:LogicalProduct/l:CodeScheme[@id = $csID]/l:Code">
              <xsl:if test="normalize-space(l:Value) = normalize-space($codeValue)">
                <xsl:variable name="categoryID" select="l:CategoryReference/r:ID"/>
                <xsl:value-of select="../../l:CategoryScheme/l:Category[@id=$categoryID]/r:Label"/>
              </xsl:if>
            </xsl:for-each>
          </td>
        </tr>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- Display Category Statistic of a given type -->
  <!-- Parameter: type -->
  <!-- Context:  -->
  <xsl:template name="displayCategoryStatistic">
      <xsl:param name="type"/>

     <xsl:choose>
        <xsl:when test="$type = 'ValidPercent'">
          <xsl:if test="count(pi:CategoryStatistic/pi:CategoryStatisticTypeCoded[@otherValue = 'ValidPercent']) = 0">
            <xsl:text> </xsl:text>  
          </xsl:if>  
        </xsl:when>
     </xsl:choose>
      
    <xsl:for-each select="pi:CategoryStatistic">
    <xsl:if test="$type = 'Percent' and pi:CategoryStatisticTypeCoded = 'Percent'">
      <td align="right">
        <xsl:value-of select="pi:Value"/>
      </td>
    </xsl:if>
    <xsl:if test="$type = 'ValidPercent' and count(pi:CategoryStatisticTypeCoded[@otherValue = 'ValidPercent']) > 0">
      <td align="right">
        <xsl:value-of select="pi:Value"/>
      </td>
    </xsl:if>
    <xsl:if test="$type = 'Frequency' and pi:CategoryStatisticTypeCoded = 'Frequency'">
      <td align="right">
        <xsl:value-of select="pi:Value"/>
      </td>
    </xsl:if>    
    </xsl:for-each>
        
  </xsl:template>

  <!-- Display Summary i.e. Sum Percent, Sum Valid Percent and Total Response  -->
  <!-- Concext: VariableStatistics -->
  <xsl:template name="displaySummary">
    <tr>
    <xsl:for-each select="pi:SummaryStatistic">
      <xsl:if test="pi:SummaryStatisticTypeCoded[@otherValue = 'Percent'] = 'UseOther'">
        <td align="right">
          <xsl:if test="string-length(pi:Value) = 0"><xsl:text>?</xsl:text></xsl:if>
          <xsl:if test="string-length(pi:Value) > 0"><xsl:value-of select="pi:Value"/></xsl:if>
        </td>
      </xsl:if>
      <xsl:if test="pi:SummaryStatisticTypeCoded[@otherValue = 'ValidTotalPercent'] = 'UseOther'">
        <td align="right">
          <xsl:if test="string-length(pi:Value) = 0"><xsl:text>?</xsl:text></xsl:if>
          <xsl:if test="string-length(pi:Value) > 0"><xsl:value-of select="pi:Value"/></xsl:if>
        </td>
      </xsl:if>
    </xsl:for-each>
    <td align="right">
        <xsl:value-of select="pi:TotalResponses"/>
    </td>
    </tr>
  </xsl:template>

  <!-- Display Filter: 
    Parameters: variableName -->
  <xsl:template name="showFilter">
    <xsl:param name="variableName"/>

    <xsl:for-each select="../../../d:DataCollection/d:ControlConstructScheme/d:Sequence">
      <xsl:choose>
        <xsl:when test="r:Label='Main sequence'">
          <!-- Look in the Main Sequence for IfThenElse-->
          <xsl:for-each select="d:ControlConstructReference">
            <xsl:if test="substring(r:ID, 1, 4)='ifth'">
              <!-- - see if current variable is part of condition - if so the variable is filtering -->
              <xsl:variable name="ifthID" select="r:ID"/>
              <xsl:for-each select="../../d:IfThenElse[@id=$ifthID]/d:IfCondition">
                <xsl:variable name="code" select="r:Code"/>
                <xsl:if test="contains($code, $variableName)">
                  <p><xsl:value-of select="$msg/*/entry[@key='FilteredBy']"/><xsl:text>: </xsl:text><xsl:value-of select="$code"/></p>
                </xsl:if>
              </xsl:for-each>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <!-- Look in the Sub-sequence(s) for Questioin Item of current variable -->
          <xsl:variable name="seqID" select="@id"/>
          <xsl:for-each select="d:ControlConstructReference">
            <xsl:if test="substring(r:ID, 1, 4)='quec'">
              <!-- this is a Question Construct reference -->
              <xsl:variable name="qcID" select="r:ID"/>
              <xsl:for-each select="../../d:QuestionConstruct[@id=$qcID]/d:QuestionReference">
                <xsl:variable name="qiID" select="r:ID"/>
                <xsl:for-each select="../../../d:QuestionScheme/d:QuestionItem[@id=$qiID]">
                  <xsl:if test="r:UserID=$variableName">
                    <!-- this is the Question Item releated to the current variable => the variable has been filteret -->
                    <!-- look for the IfThenElse which refers to the current Sequence -->
                    <xsl:for-each select="../../d:ControlConstructScheme/d:Sequence">
                      <xsl:for-each select="d:ControlConstructReference">
                        <xsl:if test="substring(r:ID, 1, 4)='ifth'">
                          <xsl:variable name="ifthId" select="r:ID"/>
                          <xsl:for-each select="../../d:IfThenElse[@id=$ifthId]">
                            <xsl:if test="d:ThenConstructReference/r:ID = $seqID">
                              <!-- this IfThenElse is has a ref. to current sequence  -->
                              <p>Variable filtreret af; <xsl:value-of select="d:IfCondition/r:Code"/></p>
                            </xsl:if>
                          </xsl:for-each>
                        </xsl:if>
                      </xsl:for-each>
                    </xsl:for-each>
                  </xsl:if>
                </xsl:for-each>
              </xsl:for-each>
            </xsl:if>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>

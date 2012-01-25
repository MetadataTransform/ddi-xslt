<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:g="ddi:group:3_1" xmlns:d="ddi:datacollection:3_1" xmlns:dce="ddi:dcelements:3_1" xmlns:c="ddi:conceptualcomponent:3_1" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:a="ddi:archive:3_1"
  xmlns:m1="ddi:physicaldataproduct/ncube/normal:3_1" xmlns:ddi="ddi:instance:3_1" xmlns:m2="ddi:physicaldataproduct/ncube/tabular:3_1" xmlns:o="ddi:organizations:3_1" xmlns:l="ddi:logicalproduct:3_1" xmlns:m3="ddi:physicaldataproduct/ncube/inline:3_1" xmlns:pd="ddi:physicaldataproduct:3_1"
  xmlns:cm="ddi:comparative:3_1" xmlns:s="ddi:studyunit:3_1" xmlns:r="ddi:reusable:3_1" xmlns:pi="ddi:physicalinstance:3_1" xmlns:ds="ddi:dataset:3_1" xmlns:pr="ddi:profile:3_1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0"
  xsi:schemaLocation="ddi:instance:3_1 http://www.ddialliance.org/sites/default/files/schema/ddi3.1/instance.xsd">

  <xsl:import href="ddi3_1.xsl"/>

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
      <a>
        <xsl:for-each select="../../../pi:PhysicalInstance/pi:Statistics/pi:VariableStatistics/pi:VariableReference">
          <!--          <xsl:value-of select="r:ID"/><xsl:text> - </xsl:text>
          <xsl:value-of select="$varID"/><xsl:text> - </xsl:text>-->
          <xsl:if test="r:ID=$varID">
            <xsl:apply-templates select="../pi:CategoryStatistics"/>
          </xsl:if>
        </xsl:for-each>
      </a>
      <xsl:apply-templates select="l:Representation/l:CodeRepresentation"/>
      <xsl:apply-templates select="l:Representation/l:NumericRepresentation"/>
      <xsl:apply-templates select="l:Representation/l:TextRepresentation"/>
    </li>
  </xsl:template>

  <xsl:template match="pi:CategoryStatistics">
    <xsl:text>Category Statistics: </xsl:text>
    <xsl:if test="count(pi:CategoryValue) > 0">
      <table class="CategoryStatistics">
        <tr>
          <th>
            <xsl:text>%</xsl:text>
          </th>
          <th>
            <xsl:text>md%</xsl:text>
          </th>
          <th>
            <xsl:text>antal</xsl:text>
          </th>
          <th>
            <xsl:text>kode</xsl:text>
          </th>
        </tr>
        <tbody>
          <xsl:apply-templates select="pi:CategoryValue"/>
        </tbody>
      </table>
    </xsl:if>
  </xsl:template>

  <xsl:template match="pi:CategoryValue">
    <tr>
      <td>row 1, cell 1</td>
      <td>row 1, cell 2</td>
      <td>row 1, cell 3</td>
      <td>row 1, cell 4</td>
    </tr>
    <tr>
      <td>row 2, cell 1</td>
      <td>row 2, cell 2</td>
      <td>row 1, cell 3</td>
      <td>row 1, cell 4</td>
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
                  <p>Variabel filtrerer med: <xsl:value-of select="$code"/></p>
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
                          <xsl:variable name="ifthID" select="r:ID"/>
                          <xsl:for-each select="../../d:IfThenElse[@id=$ifthID]">
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

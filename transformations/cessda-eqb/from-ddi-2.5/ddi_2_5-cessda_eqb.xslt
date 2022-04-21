<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet  
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:c="ddi:codebook:2_5"
    xmlns:meta="transformation:metadata"
    xmlns:ddi="http://www.ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/codebook.xsd"   
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns="ddi:codebook:2_5"
    xsi:schemaLocation="ddi:codebook:2_5 http://www.ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/codebook.xsd" 
    exclude-result-prefixes=""
    version="2.0">

    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

    <!-- root template    -->

    <!-- by default, all nodes and attributes are copied verbatim to the output 
    Note: can be in the position as the last template in the row to catch any remaining content of the original document
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template> -->

    <xsl:template match="//c:codeBook"> 
        <codeBook>
             <!-- copy the attributes from the origin -->
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select=".//c:docDscr"/>
            <xsl:apply-templates select=".//c:stdyDscr"/>
            <xsl:apply-templates select=".//c:fileDscr"/>
            <xsl:apply-templates select=".//c:dataDscr"/>
            <xsl:apply-templates select=".//c:otherMat"/>            
        </codeBook>
    </xsl:template>

    <xsl:template match="//c:docDscr">
        <docDscr>
            <citation>
            <!-- copy the attributes from the origin -->
            <xsl:copy-of select="@*"/>
            <!-- copy the elements from the origin -->
            <xsl:copy-of select="./c:citation/c:titlStmt"/>
            <xsl:copy-of select="./c:citation/c:rspStmt"/>
                 <prodStmt> 
                    <xsl:copy-of select="./c:citation/c:prodStmt/c:producer"/>
                    <!-- the required element xml:lang attribut is missing: defaults to "en"; 
                    TO DO: read the Codebook language version from one of the existing elements, e.g. title -->
                    <copyright xml:lang="en-GB">
                        <xsl:value-of select="./c:citation/c:prodStmt/c:copyright"/>
                    </copyright>
                    <xsl:copy-of select="./c:citation/c:prodStmt/c:prodDate"/>
                    <xsl:copy-of select="./c:citation/c:prodStmt/c:prodPlac"/>
                    <xsl:copy-of select="./c:citation/c:prodStmt/c:fundAg"/>   
                    <xsl:copy-of select="./c:citation/c:prodStmt/c:grantNo"/>     
                </prodStmt> 
                <xsl:copy-of select="./c:citation/c:distStmt"/>
                <xsl:copy-of select="./c:citation/c:verStmt"/>
                <xsl:copy-of select="./c:citation/c:biblCit"/>
                <xsl:copy-of select="./c:citation/c:holdings"/>
            </citation>
            <xsl:copy-of select="./c:docStatus"/>
        </docDscr>   
    </xsl:template>
    
    <xsl:template match="//c:stdyDscr">
       <stdyDscr>
        <!-- copy the attributes from the origin -->
        <xsl:copy-of select="@*"/>
            <citation>
                <xsl:copy-of select="@*"/>
                <xsl:copy-of select="./c:citation/c:titlStmt"/>
                <xsl:copy-of select="./c:citation/c:rspStmt"/>
                <xsl:copy-of select="./c:citation/c:prodStmt"/>
                <xsl:copy-of select="./c:citation/c:distStmt"/>
                <xsl:copy-of select="./c:citation/c:verStmt"/>
                <xsl:copy-of select="./c:citation/c:biblCit"/>
                <!-- Check if the required element is missing and in case it is, assign the default values-->
                <xsl:copy-of select="./c:citation/c:holdings"/>
                <xsl:if test="not(./c:citation/c:holdings)">
                    <holdings URI="http://www.adp.fdv.uni-lj.si/opisi/">Arhiv družboslovnih podatkov</holdings>
                </xsl:if>
            </citation>
            <xsl:copy-of select="./c:stdyInfo"/>
            <xsl:copy-of select="./c:method"/>
            <xsl:copy-of select="./c:dataAccs"/>
            <xsl:copy-of select="./c:stdyInfo"/>
            <othrStdyMat> 
                <xsl:for-each select="./c:othrStdyMat/c:relMat">
                    <relMat>
                        <!-- copy the attributes from the origin and add the missing attributes -->
                        <xsl:copy-of select="@*"/>
                        <xsl:attribute name="label">Study Related Material</xsl:attribute>
                        <xsl:attribute name="type">Text</xsl:attribute> 
                        <xsl:copy-of select="./c:citation"/>
                    </relMat>
                </xsl:for-each>
            </othrStdyMat>
        </stdyDscr>
    </xsl:template>
    
    <xsl:template match="//c:fileDscr">
        <fileDscr>
        <!-- copy the attributes from the origin -->
        <xsl:copy-of select="@*"/>
           <fileTxt> 
                <xsl:copy-of select="//c:fileName"/>
                <xsl:copy-of select="//c:dimensns"/>
                <!-- Check if the required element is missing and in case it is, assign the default values-->
                <!-- Check if it would be possible to assign the default from study description related to the https://ddialliance.org/controlled-vocabularies-->          
                <xsl:copy-of select="//c:fileType"/>
                    <xsl:if test="not(//c:fileType)">
                        <fileType xml:lang="en-GB">*.txt - TEXT</fileType>
                    </xsl:if>
                <xsl:copy-of select="//c:filePlac"/>
                <xsl:copy-of select="//c:fileTxt/c:verStmt"/>        
            </fileTxt> 
        </fileDscr>
            </xsl:template>

<xsl:template match="//c:dataDscr">
    <dataDscr>
        <xsl:copy-of select="@*"/>
        <xsl:copy-of select="//c:varGrp"/>
        <xsl:for-each-group select="c:var" group-by="c:labl">
        <!-- <xsl:value-of select="current-grouping-key()"/>     -->                
            <xsl:for-each select="current-group()">
                <var>
                <!-- current existent attributes copied:/>         --> 
                <xsl:copy-of select="@*"/>
                <!-- The default value of attribute overwrite the existent false values that resulted from NESSTAR Publisher         -->
                <xsl:attribute name="xml:lang">sl-SI</xsl:attribute>
                <!-- The default value of attribute if missing:        -->         
                <xsl:if test="not(//c:var/c:nature)">
                    <xsl:attribute name="nature">ordinal</xsl:attribute>
                </xsl:if>
                <!-- Variable sequence number: to be used in assigning question id-s when missing:         --> 
                <xsl:variable name="var_seq">
                    <xsl:number count="//c:var" level="any"/>
                </xsl:variable>
                <xsl:if test="not(//c:var/@qstn)">
                    <xsl:attribute name="qstn">
                        <xsl:value-of select="'Q'"/>
                        <xsl:value-of select="$var_seq"/>
                    </xsl:attribute>
                </xsl:if>
                <!-- default values when attribute missing:        -->        
                <xsl:attribute name="representationType">other</xsl:attribute>
                <xsl:attribute name="otherRepresentationType">other</xsl:attribute> 
                <xsl:copy-of select="current-group()//c:location"/>
                <!-- 
                        <xsl:copy-of select="current-group()//c:labl"/> if sytematic error: change to default "sl-SI" xml:lang insted en-GB =  
                -->
                <labl>
                    <xsl:attribute name="xml:lang">sl-SI</xsl:attribute>
                    <xsl:value-of select="current-group()/c:labl"/>
                </labl>
                <!-- The below notation any labl in a group match / not appropriate as labl repeats on lower level elswhere in the node
                            <xsl:copy-of select="current-group()//c:labl"/>
                -->
                <!--  <xsl:copy-of select="current-group()//c:qstn"/>
                      <xsl:if test="not(current-group()//c:qstn)">

                        !!!!!!!!!!!!!!!! overwrite: question attributes and values
                -->          
                <qstn xml:lang="sl-SI">
                    <xsl:attribute name="ID">
                        <xsl:value-of select="'Q'"/>
                        <xsl:value-of select="$var_seq"/>
                    </xsl:attribute>
                    <xsl:attribute name="seqNo">
                        <xsl:value-of select="'No'"/>
                        <xsl:value-of select="$var_seq"/>
                    </xsl:attribute>
                    <xsl:attribute name="elementVersion">1.0</xsl:attribute>
                    <!-- CESSDA Metadata eqb 2.5 validator:    ./@IDNo' is mandatory in /codeBook/dataDscr/var/qstn (lineNumber: 238) ; 
                    even if not described in the ddi2.5 documentation
                    It does not validate therefore need to be excluded
                        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   
                                <xsl:attribute name="IDNo">1.0</xsl:attribute>
                        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                        -->
                    <!-- Check if the required element is present-->
                    <xsl:if test="current-group()//c:qstn/c:qstnLit">
                    <xsl:copy-of select="current-group()//c:qstn/c:qstnLit"/>
                    </xsl:if>
                    <!-- Check if the required element is missing and in case it is, copy the default values from existing label-->
                    <xsl:if test="not(current-group()//c:qstn/c:qstnLit)">
                        <qstnLit xml:lang="en-GB">
                            <xsl:value-of select="current-group()/c:labl"/>
                        </qstnLit>
                    </xsl:if>
                </qstn>
                <xsl:copy-of select="current-group()/c:valrng"/>
                <xsl:copy-of select="current-group()/c:sumStat"/>
                <!-- CHANGE systematic error in xml:lang produced by NESSTAR Publisher: from 'en-GB' to 'sl-SI' +
                add labl if not present 
                -->    
                <xsl:for-each-group select="c:catgry" group-by="c:catValu">
                    <xsl:for-each select="current-group()">
                        <catgry>
                        <!-- current existent attributes copied:   --> 
                            <xsl:copy-of select="@*"/>
                            <xsl:copy-of select="current-group()/c:catValu"/>
                            <labl xml:lang="sl-SI">
                                <xsl:if test="current-group()/c:labl">
                                    <xsl:value-of select="current-group()/c:labl" />
                                </xsl:if> 
                                <xsl:if test="not(current-group()/c:labl)">
                                    <xsl:value-of select="current-group()/c:catValu" />
                                </xsl:if>  
                            </labl>
                            <xsl:copy-of  select="current-group()/c:catStat" />
                        </catgry>
                    </xsl:for-each>
                </xsl:for-each-group>
                <!-- variant with grouping categories
                        <xsl:copy-of select="current-group()/c:catgry"/>
                -->  
                <xsl:copy-of select="current-group()/c:varFormat"/> 
            </var>     
        </xsl:for-each>
    </xsl:for-each-group>
    </dataDscr> 
</xsl:template>

<xsl:template match="//c:otherMat">
    <otherMat>
     <!-- copy the attributes from the origin and add missing with default values
     To do: check if missing information can be extracted from some other fields?      -->
        <xsl:copy-of select="@*"/>
            <xsl:attribute name="type">questionnair</xsl:attribute>      
            <xsl:attribute name="level">datafile</xsl:attribute>  
        <xsl:copy-of select="*"/>
    </otherMat>
</xsl:template>
</xsl:stylesheet>
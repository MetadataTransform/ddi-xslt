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
    Note: can be in teh possiton as the last template in the row to catch any remaining content of the original document 
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template> -->

<!-- declaration of the values of the constants   -->
<xsl:variable name="xml_lang_stdyDscr"><xsl:if test="not(c:codeBook/c:stdyDscr/c:citation/c:titlStmt/c:titl/@xml:lang)">en-GB</xsl:if>
<xsl:if test="(c:codeBook/c:stdyDscr/c:citation/c:titlStmt/c:titl/@xml:lang)">
<xsl:value-of select="c:codeBook/c:stdyDscr/c:citation/c:titlStmt/c:titl/@xml:lang"/><!-- The language derived from title Study Description or else 'en-GB'  -->                  
</xsl:if></xsl:variable>


 <!-- parameters  -->
  <!-- lang_dataDscr  Set the constant to be used for language of the data description section -->
  <xsl:param name="lang_dataDscr">sl-SI</xsl:param>
            
 <!-- -->
<!--<xsl:variable name="xml_lang_dataDscr">
    <xsl:value-of select="c:codeBook/c:fileDscr/c:fileTxt/c:fileCitation/c:titlStmt/c:titl/@xml:lang"/> 
   <xsl:param name="multilang">false</xsl:param>
</xsl:variable>
-->


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
                    <!-- the required element xml:lang attribut is missing: defaults to "$xml_lang_stdyDscr"; 
                    TO DO: read the Codebook language version from one of the existing elements, e.g. title -->
                    <copyright>
                        <xsl:attribute name="xml:lang">
                            <xsl:value-of select="$xml_lang_stdyDscr"/>
                        </xsl:attribute>
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
                <xsl:copy-of select="./c:fileTxt/c:fileName"/>
                <xsl:copy-of select="./c:fileTxt/c:fileCitation"/>
                <xsl:copy-of select="./c:fileTxt/c:dimensns"/>
                <!-- Check if the required element is missing and in case it is, assign the default values-->
                <!-- Check if it would be possible to assign the default from study description related to the https://ddialliance.org/controlled-vocabularies-->          
                <xsl:copy-of select="./c:fileTxt/c:fileType"/> 
                    <xsl:if test="not(./c:fileTxt/c:fileType)">
                       <fileType>
                        <xsl:attribute name="xml:lang">
                            <xsl:value-of select="./c:fileTxt/c:fileName/@xml:lang"/>
                        </xsl:attribute>*.txt - TEXT</fileType>
                    </xsl:if>
                <xsl:copy-of select="./c:fileTxt/c:filePlac"/>
                <xsl:copy-of select="./c:fileTxt/c:verStmt"/>        
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
                <xsl:attribute name="xml:lang">
                    <xsl:value-of select="$lang_dataDscr"/>
                </xsl:attribute>
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
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$lang_dataDscr"/></xsl:attribute>
                    <xsl:value-of select="current-group()/c:labl"/>
                </labl>
                <!-- The bellow notation any labl in a group match / not appropriate as labl repeats on lower level elswhere in the node
                            <xsl:copy-of select="current-group()//c:labl"/>
                -->

                <!--  <xsl:copy-of select="current-group()//c:qstn"/>
                      <xsl:if test="not(current-group()//c:qstn)">

                        !!!!!!!!!!!!!!!! overwrite: question attributes and values
                -->          
                <qstn>
                    <xsl:attribute name="xml:lang"><xsl:value-of select="$lang_dataDscr"/></xsl:attribute>
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
                        <qstnLit>
                            <xsl:attribute name="xml:lang"><xsl:value-of select="$lang_dataDscr"/></xsl:attribute>
                            <xsl:value-of select="current-group()/c:labl"/>
                        </qstnLit>
                    </xsl:if>
                </qstn>
                <xsl:copy-of select="current-group()/c:valrng"/>
                <xsl:copy-of select="current-group()/c:sumStat"/>
                <!-- CHANGE systematic arror in xml:lang produced by NESSTAR Publisher: from 'en-GB' to 'sl-SI' +
                add labl if not present 
                -->    
                <xsl:for-each-group select="c:catgry" group-by="c:catValu">
                    <xsl:for-each select="current-group()">
                        <catgry>
                        <!-- current existent attributes copied:   --> 
                            <xsl:copy-of select="@*"/>
                            <xsl:copy-of select="current-group()/c:catValu"/>
                            <labl>
                                <xsl:attribute name="xml:lang"><xsl:value-of select="$lang_dataDscr"/></xsl:attribute>
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
<!--  literature / examples solutions:
Test examples: 
https://www.adp.fdv.uni-lj.si/media/raziskave/opisi/pocp21-en.xml 

Instructions:
Run: cd c:\Users\stebej\Documents\ddi-xslt\dev\ 
docker-compose up 

see  readme
ddi-xslt
========

This is a collection of xslt-stylesheets for DDI for transformation the metadata to other formats.

# development

Create a new file `docker-compose.override.yml`

Set the enviroment parameters for the XSLT and XML to use in development

```yml
version: "3"
services:
  ddi-xslt-dev:
    environment:
      XSLT: /transformations/dcterms/from-ddi-3.2/ddi_3_2-dcterms.xslt
      XML: /examples/ddi-3.2/ZA4586_ddi-I_StudyDescription_3_2.xml
```

Note: In case of compilation error, change End Of Line sequence from CRLF to LF in `run.sh` script.

GNU Lesser General Public License
=========================

[![GNU LGPL v3.0](https://www.gnu.org/graphics/lgplv3-147x51.png)](https://www.gnu.org/licenses/lgpl-3.0.html)


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!$default
Docker-copmpose.override.yml
version: "3"
services:
  ddi-xslt-dev:
    environment:
      XSLT: /transformations/cessda-eqb/from-ddi-2.5/ddi_2_5-cessda_eqb.xslt
      XML: /examples/ddi-2.5/mpstr18_eqb_test_valid.xml
    build: 
      context: .
      dockerfile: dev/Dockerfile-dev
    volumes:
      - ./transformations:/transformations:cached
      - ./examples:/examples:cached

local setting
PS C:\Users\stebej\documents> cd ddi-xslt
PS C:\Users\stebej\documents\ddi-xslt> cd dev
PS C:\Users\stebej\documents\ddi-xslt\dev> docker-compose up
Recreating ddi-xslt_ddi-xslt-dev_1 ... done  
--> 
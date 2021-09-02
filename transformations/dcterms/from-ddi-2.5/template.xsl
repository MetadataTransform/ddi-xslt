    <?xml version="1.0" encoding="utf-8"?> 
    <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 
    <xsl:template match="/"> 
    	<xsl:element name="xsl:stylesheet"> 
    			<xsl:attribute name="version"><xsl:text>1.0</xsl:text> 
    			</xsl:attribute> 
    			<xsl:text>&#xa;</xsl:text> 
    			<xsl:apply-templates/> 
    			<xsl:text>&#xa;</xsl:text> 
    		</xsl:element> 
    	</xsl:template> 
    	<xsl:template match="*"> 
    		<xsl:variable name="name"><xsl:value-of select="local-name()"/></xsl:variable> 
    		<xsl:variable name="first" select="(//*[local-name()=$name])[1]" /> 
    		<xsl:if test="generate-id()=generate-id($first)"> 
    			<xsl:text>&#xa;</xsl:text> 
    			<xsl:element name="xsl:template"> 
    				<xsl:attribute name="match"> 
    					<xsl:value-of select="local-name()"/>		 
    				</xsl:attribute> 
    				<xsl:comment>To Do: Implement logic for this element</xsl:comment> 
    			</xsl:element> 
    		</xsl:if> 
    		<xsl:apply-templates/> 
    	</xsl:template> 
    	<xsl:template match="text()"></xsl:template>  
    </xsl:stylesheet> 
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="body">
		<body>
			<!-- <xsl:call-template name="grid-paper-pattern" /> -->
			<xsl:call-template name="internal-navigation"/>
			<xsl:call-template name="main-content"/>
			<xsl:call-template name="wiki-viewer"/>
			<xsl:call-template name="svg-elements"/>
			<xsl:call-template name="scripts"/>	
		</body>
	</xsl:template>
</xsl:stylesheet>



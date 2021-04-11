<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="internal-navigation">
		<xsl:call-template name="body-css">
			<xsl:with-param name="content">
				<link rel="stylesheet" href="assets/css/components/c-internal_nav.css"/>
			</xsl:with-param>
		</xsl:call-template>
		<nav>
			<xsl:apply-templates mode="internal-navigation" />
		</nav>
	</xsl:template>

	<xsl:template match="section" mode="internal-navigation">
		<a href="#{@id}">
			<xsl:value-of select="header/*[name() = 'h1' or name() = 'h2' or name() = 'h3']" />
		</a>
	</xsl:template>
</xsl:stylesheet>

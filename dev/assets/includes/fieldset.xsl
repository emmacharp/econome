<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="fieldset[not(preceding::fieldset)]" mode="include-once">
		<xsl:call-template name="body-css">
			<xsl:with-param name="content">
				<link rel="stylesheet" href="/assets/css/components/fieldset.css"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="fieldset">
		<xsl:apply-templates select="." mode="include-once"/>
		<xsl:element name="fieldset">
			<xsl:apply-templates select="@*|node()" />
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>

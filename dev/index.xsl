<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="assets/includes/diagram.xsl" />
	<xsl:include href="assets/includes/symbol.xsl" />
	<xsl:include href="assets/includes/goods.xsl" />
	<xsl:include href="assets/includes/wiki-viewer.xsl" />
	<xsl:include href="assets/includes/assets.xsl"/>
	<xsl:include href="assets/includes/head.xsl"/>
	<xsl:include href="assets/includes/internal-navigation.xsl"/>
	<xsl:include href="assets/includes/main-content.xsl"/>
	<xsl:include href="assets/includes/fieldset.xsl"/>
	<xsl:include href="assets/includes/customizer-menu.xsl"/>
	<xsl:include href="assets/includes/body.xsl"/>

	<xsl:output method="html" doctype-system="about:legacy-compat" />

	<!-- Identity transform -->
	<!-- Primordial. Permet à la machine de fonctionner. -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:include href="assets/includes/text.xsl"/>

	<!-- On démarre la machine -->
	<xsl:template match="/">
		<html lang="fr">
			<xsl:call-template name="head"/>
			<xsl:apply-templates mode="body"/>
		</html>
	</xsl:template>

</xsl:stylesheet>

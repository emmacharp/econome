<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="head-css">
		<link rel="stylesheet" href="assets/css/utilities/u-superdiv.css"/>

		<link rel="stylesheet" href="assets/css/theme/t-library.css"/>
		<link rel="stylesheet" href="assets/css/theme/t-config.css"/>
		<link rel="stylesheet" href="assets/css/theme/t-setup.css"/>
		<link rel="stylesheet" href="assets/css/theme/t-typography.css"/>
		<link rel="stylesheet" href="assets/css/theme/t-general.css"/>
		<link rel="stylesheet" href="assets/css/theme/t-special.css"/>
		<link rel="stylesheet" href="assets/css/theme/t-controls.css"/>

		<!-- <link rel="stylesheet" href="assets/css/theme/t-dark_scheme.css" media="screen and (prefers-color-scheme: dark)" /> -->
		<!-- <link rel="stylesheet" href="assets/css/components/c-cartoon_characters.css" /> -->

		<link rel="stylesheet" href="assets/css/patterns/p-provenance.css"/>
		<link rel="stylesheet" href="assets/css/patterns/p-auto_line-height.css"/>
		<link rel="stylesheet" href="assets/css/patterns/p-section_visibility-transitions.css" />

		<link rel="stylesheet" href="assets/css/layout/l-master_composition.css"/>
		<!-- <link rel="stylesheet" href="assets/css/x-dev.css"/> -->
		</xsl:template>

		<xsl:template name="body-css">
			<xsl:param name="content"/>
			<xsl:copy-of select="$content"/>
		</xsl:template>

		<xsl:template name="scripts">
			<script src="assets/js/htmx.min.js"></script>
			<script src="assets/js/main.js" defer="defer"></script>
			<link rel="stylesheet" href="assets/css/x-quarantine.css"/>
		</xsl:template>

</xsl:stylesheet>

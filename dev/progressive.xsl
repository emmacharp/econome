<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="index.xsl"/>
	
	<xsl:template name="head-css">
		<link rel="stylesheet" href="assets/css/utilities.min.css"/>
		<link rel="stylesheet" href="assets/css/theme.min.css"/>
		<link rel="stylesheet" href="assets/css/patterns.min.css"/>
		<link rel="stylesheet" href="assets/css/theme/t-light_scheme.css" media="screen" />
		<link id="sheetLightScheme" rel="stylesheet" href="assets/css/theme/t-light_scheme.css" media="screen and (prefers-color-scheme: light)" />
		<link id="sheetDarkScheme" rel="stylesheet" href="assets/css/theme/t-dark_scheme.css" media="screen and (prefers-color-scheme: dark)" />
		<link id="sheetDarkHighContrast" rel="stylesheet" href="assets/css/theme/t-dark-high_contrast.css" media="screen and (prefers-contrast: high) and (prefers-color-scheme: dark)" />
		<link id="sheetLightHighContrast" rel="stylesheet" href="assets/css/theme/t-light-high_contrast.css" media="screen and (prefers-contrast: high) and (prefers-color-scheme:light)" />
		<link id="sheetAnimations" rel="stylesheet" href="assets/css/patterns/p-section_visibility-transitions.css" media="not(prefers-reduced-motion: reduced)" />
		<link rel="stylesheet" href="assets/css/layout/l-master_composition.css"/>
	</xsl:template>

</xsl:stylesheet>



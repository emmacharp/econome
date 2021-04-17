<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:ext="http://exslt.org/common"
	xmlns:math="http://exslt.org/math"
	exclude-result-prefixes="ext msxsl svg math">
	<xsl:import href="index.xsl"/>
	
	<xsl:template name="head-css">
		<link rel="stylesheet" href="assets/css/utilities/u-superdiv.css"/>

		<link rel="stylesheet" href="assets/css/theme.min.css"/>
		<link rel="stylesheet" href="assets/css/theme/t-dark_scheme.css" media="screen and (prefers-color-scheme: dark)" />
		<link rel="stylesheet" href="assets/css/components/c-arrows.css"/>
		<link rel="stylesheet" href="assets/css/patterns/p-provenance.css"/>
		<link rel="stylesheet" href="assets/css/patterns/p-auto_line-height.css"/>
		<link rel="stylesheet" href="assets/css/layout/l-master_composition.css"/>
		<link rel="stylesheet" href="assets/css/x-quarantine.css"/>
	</xsl:template>

</xsl:stylesheet>



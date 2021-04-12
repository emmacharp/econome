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
	
	<xsl:template name="body-css"></xsl:template>
	<xsl:template name="head-css">
		<link rel="stylesheet" href="assets/css/main.min.css"/>
	</xsl:template>
	<xsl:template name="scripts">
		<script src="assets/js/main.min.js" defer="defer"></script>
	</xsl:template>

</xsl:stylesheet>



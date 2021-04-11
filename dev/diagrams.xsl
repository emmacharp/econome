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
	<xsl:output method="html" doctype-system="about:legacy-compat" />

	<xsl:template match="/">
		<html>
			<head>
				<meta charset="UTF-8"/>
			</head>
			<body>
				<xsl:apply-templates select="//diagram" mode="ajax-diagrams" />
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>


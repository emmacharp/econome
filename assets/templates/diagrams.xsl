<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:import href="../../index.xsl"/>
	<xsl:output method="html" doctype-system="about:legacy-compat" />

	<xsl:template match="/">
		<html>
			<head>
				<meta charset="UTF-8"/>
			</head>
			<body>
				<section>
					<article class="buying chain diagram">
						<xsl:apply-templates select="//diagram" mode="ajax-diagrams" />
					</article>
				</section>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>


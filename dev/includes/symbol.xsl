<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:svg="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ext="http://exslt.org/common" xmlns:serif="http://www.serif.com/" exclude-result-prefixes="ext svg">

	<xsl:variable name="svg-symbols">
		<xsl:copy-of select="document('../symbols.svg')" />
	</xsl:variable>

	<xsl:key name="symbol-type" match="svg:symbol" use="substring-after(@id, 'svg-')"/>

	<xsl:template match="svg:symbol">
		<xsl:param name="attr" select="@*[not(name() = 'id')]" />
		<svg xmlns="http://www.w3.org/2000/svg" class="icon" viewBox="{@viewBox}">
			<xsl:apply-templates select="$attr" />
			<use xlink:href="symbols.svg#{@id}"></use>
		</svg>
	</xsl:template>

	<xsl:template match="symbol">
		<xsl:apply-templates select="ext:node-set($svg-symbols)//svg:symbol[generate-id() = generate-id(key('symbol-type', current()/@type)[1])]">
			<xsl:with-param name="attr" select="@*[not(name() = 'type')]" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template name="svg-elements">
		<svg xmlns="http://www.w3.org/2000/svg" class="svg" style="position:absolute; width:0; height:0; overflow: hidden;">
			<clipPath id="beer-clip-path" clipPathUnits="objectBoundingBox">
				<path d="M0.121,0.791 c-0.033,0,-0.06,-0.02,-0.06,-0.044 l0,-0.277 c0,-0.024,0.027,-0.044,0.06,-0.044 l0.152,0 l0,-0.05 l-0.241,0 c-0.018,0,-0.032,0.01,-0.032,0.023 l0,0.418 c0,0.013,0.014,0.023,0.032,0.023 l0.241,0 l0,-0.05 l-0.152,0 m0.203,-0.642 l0.662,0 c-0.022,-0.04,-0.061,-0.053,-0.119,-0.052 c-0.03,-0.061,-0.094,-0.098,-0.184,-0.098 c-0.091,0,-0.15,0.035,-0.183,0.095 c-0.075,-0.017,-0.15,-0.004,-0.176,0.054 m-0.005,0.089 l0.681,0 l0,-0.049 l-0.681,0 l0,0.049 m0,0.076 l0.681,0 l0,-0.042 l-0.681,0 l0,0.042 m0.573,0.034 l0,0.493 l0.108,0 l0,-0.493 l-0.108,0 m-0.119,0.493 l0.073,0 l0,-0.493 l-0.073,0 l0,0.493 m0.227,0.11 l-0.681,0 l0,0.049 l0.681,0 l0,-0.049 m0,-0.076 l-0.681,0 l0,0.042 l0.681,0 l0,-0.042 m-0.407,-0.527 l0,0.493 l0.134,0 l0,-0.493 l-0.134,0 m-0.119,0 l0,0.493 l0.073,0 l0,-0.493 l-0.073,0 m-0.154,0 l0,0.493 l0.108,0 l0,-0.493 l-0.108,0"/>
			</clipPath>
			<defs>
				<linearGradient id="gradient-local-foreign" x1="0" x2="0" y1="0" y2="1">
					<stop offset="0%" stop-color="var(--ColorLocal)"/>
					<stop offset="100%" stop-color="var(--ColorForeign)"/>
				</linearGradient>
			</defs>
		</svg>
	</xsl:template>
</xsl:stylesheet>

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
	<xsl:template match="code" mode="symbol-chooser">

		<xsl:choose>
			<xsl:when test="contains(., 'MIN')">
				<xsl:text>svg-minerals-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(., 'ALI')">
				<xsl:text>svg-food-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(., 'IMM')">
				<xsl:text>svg-building-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(., 'COT')">
				<xsl:text>svg-contribution-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(., 'CON')">
				<xsl:text>svg-construction-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(., 'REV')">
				<xsl:text>svg-moneybag-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(., 'SAL')">
				<xsl:text>svg-salary-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(., 'PRO')">
				<xsl:text>svg-professional-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(., 'FIN')">
				<xsl:text>svg-finance-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(., 'CUL')">
				<xsl:text>svg-culture-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(., 'ADM')">
				<xsl:text>svg-admin-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(., 'HEB')">
				<xsl:text>svg-restaurant-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(. ,'PRM800000')">
				<xsl:text>svg-money-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(. ,'PRM500000')">
				<xsl:text>svg-worker-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(. ,'IMS551002')">
				<xsl:text>svg-building-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(. ,'PRM600000')">
				<xsl:text>svg-contribution-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(., 'MPS533000')">
				<xsl:text>svg-copyright-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(., 'MPG322201')">
				<xsl:text>svg-cardboard-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(., 'MPG332401')">
				<xsl:text>svg-cap-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(., 'MPG311208')">
				<xsl:text>svg-cereal-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(., 'MPS541800')">
				<xsl:text>svg-advertising-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(., 'PRM400000')">
				<xsl:text>svg-tax-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(., 'MPS722001')">
				<xsl:text>svg-meal-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(., 'MPG327A02')">
				<xsl:text>svg-bottle-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(., 'MPG311301')">
				<xsl:text>svg-sugar-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(., 'MPS')">
				<xsl:text>svg-truck-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(., 'ENE')">
				<xsl:text>svg-electricity-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(., 'MPG')">
				<xsl:text>svg-goods-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains(., 'PRM')">
				<xsl:text>svg-contribution-symbol</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>svg-unknown-symbol</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>

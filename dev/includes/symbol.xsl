<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:svg="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ext="http://exslt.org/common" xmlns:serif="http://www.serif.com/" exclude-result-prefixes="ext svg">

	<xsl:variable name="svg-symbols">
		<xsl:copy-of select="document('../symbols.svg')" />
	</xsl:variable>

	<xsl:key name="symbol-type" match="svg:symbol" use="substring-after(@id, 'svg-')"/>

	<xsl:template match="svg:symbol">
		<xsl:param name="class" />
		<xsl:param name="attr" select="@*[not(name() = 'id')]" />
		<svg xmlns="http://www.w3.org/2000/svg" class="{$class}" viewBox="{@viewBox}">
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
	<xsl:template name="svg-elements">
		<svg xmlns="http://www.w3.org/2000/svg" class="svg" style="position:absolute; width:0; height:0; overflow: hidden;">
			<clipPath id="beer-clip-path" clipPathUnits="objectBoundingBox"><path d="M0.151,0.122 C0.273,0.115,0.396,0.111,0.518,0.112 C0.581,0.112,0.643,0.113,0.701,0.114 C0.771,0.116,0.841,0.121,0.909,0.128 C0.922,0.129,0.937,0.131,0.952,0.132 L1,0.137 C0.992,0.123,0.979,0.111,0.962,0.1 C0.959,0.097,0.955,0.095,0.951,0.093 C0.942,0.088,0.935,0.084,0.93,0.078 C0.925,0.073,0.922,0.067,0.922,0.061 C0.922,0.058,0.921,0.055,0.92,0.052 C0.92,0.051,0.92,0.05,0.92,0.049 C0.92,0.042,0.915,0.036,0.906,0.03 C0.897,0.025,0.884,0.022,0.871,0.022 L0.851,0.021 C0.797,0.018,0.652,0.011,0.49,0.011 C0.39,0.011,0.291,0.014,0.191,0.02 L0.167,0.022 C0.154,0.022,0.141,0.025,0.132,0.03 C0.123,0.035,0.117,0.042,0.117,0.049 C0.117,0.05,0.117,0.05,0.117,0.051 C0.116,0.054,0.116,0.057,0.115,0.06 C0.115,0.073,0.094,0.086,0.079,0.096 L0.075,0.099 C0.06,0.109,0.048,0.12,0.039,0.132 C0.076,0.128,0.114,0.124,0.151,0.122 M0.885,0.908 C0.763,0.915,0.641,0.919,0.518,0.919 C0.396,0.919,0.273,0.915,0.151,0.908 C0.107,0.906,0.062,0.902,0.019,0.896 C0.019,0.908,0.027,0.92,0.041,0.93 C0.055,0.94,0.076,0.947,0.098,0.95 C0.114,0.954,0.121,0.955,0.123,0.958 C0.123,0.959,0.123,0.959,0.123,0.96 C0.125,0.968,0.133,0.976,0.144,0.982 C0.155,0.988,0.17,0.992,0.186,0.993 C0.236,1,0.402,1,0.517,1 C0.632,1,0.798,1,0.848,0.993 C0.864,0.992,0.879,0.988,0.89,0.982 C0.901,0.976,0.909,0.968,0.911,0.96 C0.911,0.96,0.911,0.959,0.911,0.958 C0.914,0.955,0.92,0.954,0.936,0.95 C0.959,0.947,0.979,0.94,0.993,0.93 C1,0.92,1,0.908,1,0.896 C0.973,0.902,0.929,0.906,0.885,0.908 M0.518,0.637 C0.598,0.637,0.663,0.579,0.663,0.507 C0.663,0.435,0.598,0.377,0.518,0.377 C0.438,0.377,0.373,0.435,0.373,0.507 C0.373,0.579,0.438,0.637,0.518,0.637 M1,0.174 C0.997,0.171,0.963,0.168,0.94,0.166 C0.924,0.164,0.908,0.163,0.895,0.161 C0.83,0.155,0.764,0.151,0.697,0.15 C0.64,0.148,0.58,0.147,0.518,0.147 C0.268,0.147,0.068,0.161,0.021,0.171 C0.019,0.18,0.018,0.188,0.018,0.196 V0.859 C0.061,0.87,0.264,0.884,0.518,0.884 C0.773,0.884,0.976,0.87,1,0.859 V0.196 C1,0.189,1,0.181,1,0.174 M0.731,0.507 C0.731,0.6,0.638,0.672,0.518,0.672 C0.399,0.672,0.305,0.599,0.305,0.507 C0.305,0.414,0.399,0.342,0.518,0.342 C0.638,0.342,0.731,0.414,0.731,0.507"/></clipPath>
			<defs>
				<linearGradient id="gradient-local-foreign" x1="0" x2="0" y1="0" y2="1">
					<stop offset="0%" stop-color="var(--ColorForeign)"/>
					<stop offset="100%" stop-color="var(--ColorLocal)"/>
				</linearGradient>
			</defs>
		</svg>
	</xsl:template>
</xsl:stylesheet>

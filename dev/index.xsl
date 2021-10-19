<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:svg="http://www.w3.org/2000/svg"
xmlns:xlink="http://www.w3.org/1999/xlink"
xmlns:msxsl="urn:schemas-microsoft-com:xslt"
xmlns:ext="http://exslt.org/common"
xmlns:str="http://exslt.org/strings"
xmlns:math="http://exslt.org/math"
exclude-result-prefixes="ext msxsl svg math">

<xsl:include href="includes/diagram.xsl" />
<xsl:include href="includes/symbol.xsl" />
<xsl:include href="goods.xsl" />
<xsl:include href="includes/section-image.xsl" />
<xsl:include href="includes/grid-paper-pattern.xsl" />
<xsl:include href="includes/wiki-viewer.xsl" />
<xsl:include href="includes/assets.xsl"/>
<xsl:include href="includes/head.xsl"/>
<xsl:include href="includes/internal-navigation.xsl"/>
<xsl:include href="includes/main-content.xsl"/>
<xsl:include href="includes/fieldset.xsl"/>
<xsl:include href="includes/body.xsl"/>

<xsl:output method="html" doctype-system="about:legacy-compat" />

	<!-- Identity transform -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="text()">
			<xsl:for-each select="str:tokenize(., ' ')">
				<xsl:value-of select="."/> 
				<xsl:choose>
					<xsl:when test="position() = last() - 1"><xsl:text>&#160;</xsl:text></xsl:when>
					<xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
	</xsl:template>

	<xsl:template match="text()[contains(.,'Joey Joe Joe')]">
		<xsl:if test="substring-before(., 'Joey Joe Joe')">
			<xsl:copy-of select="substring-before(., 'Joey Joe Joe')"></xsl:copy-of>
		</xsl:if>
		<span class="username">Joey Joe Joe</span>
		<xsl:if test="substring-after(., 'Joey Joe Joe')">
			<xsl:copy-of select="substring-after(., 'Joey Joe Joe')"></xsl:copy-of>
		</xsl:if>

	</xsl:template>
	<xsl:template match="diagram/agent/@name">
		<span><xsl:value-of select="." /></span>
	</xsl:template>
	<xsl:template match="diagram/agent/@name[contains(.,'Joey Joe Joe')]">
		<xsl:if test="substring-before(., 'Joey Joe Joe')">
			<xsl:copy-of select="substring-before(., 'Joey Joe Joe')"></xsl:copy-of>
		</xsl:if>
			
		<span class="username">Joey Joe Joe</span>
		<xsl:if test="substring-after(., 'Joey Joe Joe')">
			<xsl:copy-of select="substring-after(., 'Joey Joe Joe')"></xsl:copy-of>
		</xsl:if>

	</xsl:template>

	<xsl:template match="text()[contains(.,'Econome')]">
		<xsl:if test="substring-before(., 'Econome')">
			<xsl:copy-of select="substring-before(., 'Econome')"></xsl:copy-of>
		</xsl:if>
		<span class="sitename">Econome</span>
		<xsl:if test="substring-after(., 'Econome')">
			<xsl:copy-of select="substring-after(., 'Econome')"></xsl:copy-of>
		</xsl:if>

	</xsl:template>
	<xsl:template match="/">
		<html lang="fr">
			<xsl:call-template name="head"/>
			<xsl:apply-templates mode="body"/>
		</html>
	</xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:svg="http://www.w3.org/2000/svg"
xmlns:str="http://exslt.org/strings"
exclude-result-prefixes="str">


<xsl:output method="html" doctype-system="about:legacy-compat" />

	<!-- Identity transform -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="text()">
		<xsl:variable name="text">
			<xsl:for-each select="str:tokenize(., ' ')">
				<xsl:value-of select="."/> 
				<xsl:choose>
					<xsl:when test="position() = last() - 1 and ancestor::*[1][not(h1)]"><xsl:text> </xsl:text></xsl:when>
					<xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="text-with-joey">
			<xsl:choose>
				<xsl:when test="contains($text, 'Joey Joe Joe')">
					<xsl:if test="substring-before($text, 'Joey Joe Joe')">
						<xsl:copy-of select="substring-before($text, 'Joey Joe Joe')"></xsl:copy-of>
					</xsl:if>
					<span class="username">Joey Joe Joe</span>
					<xsl:if test="substring-after($text, 'Joey Joe Joe')">
						<xsl:copy-of select="substring-after($text, 'Joey Joe Joe')"></xsl:copy-of>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$text" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="text-with-joey-econome">
			<xsl:choose>
				<xsl:when test="contains($text-with-joey, 'Econome')">
					<xsl:if test="substring-before($text-with-joey, 'Econome')">
						<xsl:copy-of select="substring-before($text-with-joey, 'Econome')"></xsl:copy-of>
					</xsl:if>
					<span class="sitename">Econome</span>
					<xsl:if test="substring-after($text-with-joey, 'Econome')">
						<xsl:copy-of select="substring-after($text-with-joey, 'Econome')"></xsl:copy-of>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$text-with-joey" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:copy-of select="$text-with-joey-econome" />

	</xsl:template>

	<xsl:template match="diagram/agent/@name">
		<span><xsl:value-of select="." /></span>
	</xsl:template>
	<xsl:template match="diagram/agent/@name[contains(.,'Joey Joe Joe')]">
		<xsl:if test="substring-before(., 'Joey Joe Joe')">
			<xsl:copy-of select="substring-before(., 'Joey Joe Joe')"></xsl:copy-of>
		</xsl:if>
			
		<span class="username">Joey Joe Joe</span>
		<xsl:if test="substring-after(., 'Joey Joe Joe')">
			<xsl:copy-of select="substring-after(., 'Joey Joe Joe')"></xsl:copy-of>
		</xsl:if>

	</xsl:template>

	<xsl:template match="/">
		<html lang="fr">
			<xsl:call-template name="head"/>
			<xsl:apply-templates mode="body"/>
		</html>
	</xsl:template>

</xsl:stylesheet>

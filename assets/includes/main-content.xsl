<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- Feuilles de styles à n'insérer qu'une seule fois -->
	<xsl:template match="*|@*" mode="include-once"></xsl:template>
	<xsl:template match="section[not(preceding::section)]" mode="include-once">
		<xsl:call-template name="body-css">
			<xsl:with-param name="content">
				<link rel="stylesheet" href="/assets/css/layout/l-section_composition.css"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="aside[@class='intervention'][not(preceding::aside[@class='intervention'])]" mode="include-once">
		<xsl:call-template name="body-css">
			<xsl:with-param name="content">
				<link rel="stylesheet" href="/assets/css/components/intervention.css"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="details[not(preceding::details)]" mode="include-once">
		<xsl:call-template name="body-css">
			<xsl:with-param name="content">
				<link rel="stylesheet" href="/assets/css/components/details.css"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- Construire les sections principales -->
	<xsl:template match="*" mode="main-content"/>
	<xsl:template match="section" mode="main-content">
		<xsl:apply-templates select="." mode="include-once"/>
		<xsl:variable name="id" select="concat('id-', count(preceding-sibling::*[.//h3 or .//h1]))" />
		<xsl:variable name="wordcount" select="string-length(normalize-space(.)) - string-length(translate(normalize-space(.),' ','')) +1"/>
		<xsl:variable name="needed-time" select="number($wordcount) div 1000 * 60000"/>
		<section data-wordcount="{$wordcount}" data-needed-time="{$needed-time}" style="--needed-time: {$needed-time};">
			<xsl:apply-templates select="@*" />
			<xsl:if test=".//h3 or .//h1">
				<xsl:attribute name="id">
					<xsl:value-of select="$id"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select=".//aside" mode="include-once"/>
			<xsl:apply-templates/>
		</section>
	</xsl:template>

	<!-- Marqueurs de partie -->
	<xsl:template match="h2" mode="main-content">
		<h2>
			<span>
				<xsl:apply-templates />
			</span>
		</h2>
	</xsl:template>

	<!-- Générer le contenu principal -->
	<xsl:template name="main-content">
		<main>
			<xsl:apply-templates mode="main-content" />
		</main>
	</xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:svg="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ext="http://exslt.org/common" xmlns:serif="http://www.serif.com/" exclude-result-prefixes="ext svg">
	<xsl:template name="internal-navigation">
		<input type="checkbox" class="toggle-internal-nav" />
		<xsl:call-template name="body-css">
			<xsl:with-param name="content">
				<link rel="stylesheet" href="assets/css/components/c-internal_nav.css"/>
			</xsl:with-param>
		</xsl:call-template>
		<nav>
			<header>
				<span><strong>Econome</strong> présente</span>
				<p><xsl:value-of select="//h1"></xsl:value-of></p>
				<details>
					<summary><span>En savoir plus sur Econome</span></summary>
					<p>Econome c'est une initiative de commnuication économique populaire. Comme d'autres <i data-wiki="Isotype_(pictogramme)">avant nous</i>, nous espérons informer le public dans ses prises de décision politiques grâce à l'exposition de faits économiques.</p>
				</details>
			</header>
			<ul>
				<xsl:apply-templates select="/root/section" mode="internal-navigation" />
			</ul>
		</nav>
	</xsl:template>
	<xsl:template match="section" mode="internal-navigation">
		<xsl:if test=".//h3">
			<xsl:variable name="id" select="concat('id-', count(preceding-sibling::*))"></xsl:variable>
			<li>
				<xsl:apply-templates select="@*"/>
				<a href="#{$id}">
					<xsl:apply-templates select="header//*[name() = 'h2' or name() = 'h3']//text()" />
				</a>
			</li>
		</xsl:if>
		<xsl:if test=".//h1">
			<xsl:variable name="id" select="concat('id-', count(preceding-sibling::*))"></xsl:variable>
			<li>
				<xsl:apply-templates select="@*"/>
				<a href="#{$id}">
					<xsl:text>Introduction</xsl:text>
				</a>
			</li>

		</xsl:if>
	</xsl:template>


</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="internal-navigation">
		<input aria-label="Ouvrir ou fermer la navigation" type="checkbox" class="toggle-internal-nav" />
		<xsl:call-template name="body-css">
			<xsl:with-param name="content">
				<link rel="stylesheet" href="/assets/css/components/c-internal_nav.css"/>
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
		<xsl:if test=".//h3 or .//h1">
			<xsl:variable name="id" select="concat('id-', count(preceding-sibling::*[.//h1 or .//h3]))" />
			<li>
				<xsl:apply-templates select="@*"/>
				<a href="#{$id}">
					<xsl:choose>
						<xsl:when test=".//h1">
							<xsl:text>Introduction</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="header//*[name() = 'h2' or name() = 'h3']//text()" />
						</xsl:otherwise>
					</xsl:choose>
				</a>
			</li>
		</xsl:if>
	</xsl:template>


</xsl:stylesheet>

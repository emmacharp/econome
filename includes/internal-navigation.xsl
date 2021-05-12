<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="internal-navigation">
		<input type="checkbox" class="trigger-internal-nav" />
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
					<p>Econome c'est une initiative de commnuication économique populaire. Comme d'autres <i data-wiki="Otto_Neurath">avant nous</i>, nous espérons informer le public dans ses prises de décision politiques grâce à l'exposition de faits économiques.</p>
					<p>Econome veut éclairer les enjeux économiques contemporains s'en pour autant prendre position. C'est au public que revient la décision.</p>
				</details>
			</header>
			<ul>
				<xsl:apply-templates select="/root/h2" mode="internal-navigation" />
			</ul>
		</nav>
	</xsl:template>
	<xsl:template match="section" mode="internal-navigation">
		<xsl:if test=".//h3">
			<xsl:variable name="id" select="concat('id-', count(preceding-sibling::*))"></xsl:variable>
			<li>
				<xsl:apply-templates select="@*"/>
				<a href="#{$id}">
					<xsl:apply-templates select="header/*[name() = 'h2' or name() = 'h3']/text()" />
				</a>
			</li>
		</xsl:if>
		<xsl:apply-templates select="following-sibling::*[1][name() = 'section']" mode="internal-navigation"/>
	</xsl:template>
	<xsl:template match="h2" mode="internal-navigation">
		<xsl:variable name="id" select="concat('id-', count(preceding-sibling::*))"></xsl:variable>
		<li>
			<xsl:apply-templates select="@*"/>
			<a href="#{$id}">
				<xsl:apply-templates select="text()" />
			</a>
			<ul>
				<xsl:apply-templates select="following-sibling::*[1][name() = 'section']" mode="internal-navigation"/>
			</ul>
		</li>
	</xsl:template>

</xsl:stylesheet>

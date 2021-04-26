<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:svg="http://www.w3.org/2000/svg" xmlns:ext="http://exslt.org/common" exclude-result-prefixes="ext svg">

<xsl:key name="agent-type" match="agent" use="@type"/>

<xsl:template match="agent/@local|agent/@foreign|agent/@value|agent/@paid">
	<span class="added amount {name()}">
		<xsl:choose>
			<xsl:when test="name() = 'paid'">
				<xsl:text>-</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>+</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="." />
		<span class="unit"> $</span>
	</span>
</xsl:template>

<xsl:template match="diagram/agent">
	<section class="link agent {@type} {@class}">
		<div>
			<xsl:apply-templates select="@local|@value|@paid" />
			<article>
				<xsl:apply-templates select="ext:node-set($svg-elements)//svg:symbol[generate-id() = generate-id(key('symbol-type', current()/@type)[1])]" />
				<h4><xsl:value-of select="@name" /></h4>
			</article>
			<xsl:apply-templates select="@foreign" />
		</div>
	</section>
</xsl:template>

<xsl:template match="diagram/product">
	<xsl:variable name="state">
		<xsl:choose>
			<xsl:when test="@complete">
				<xsl:text>complete</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>partial</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<div>
		<xsl:if test="@local|@value">
			<hr class="variable arrow from" />
		</xsl:if>
		<section class="{$state} product">
			<xsl:attribute name="style">
				<xsl:if test="@local">
					<xsl:value-of select="'--LocalAddedValue: '" />
					<xsl:value-of select="@local"></xsl:value-of>
					<xsl:value-of select="';'"></xsl:value-of>
				</xsl:if>
				<xsl:if test="@foreign">
					<xsl:value-of select="'--ForeignAddedValue:'" />
					<xsl:value-of select="@foreign"></xsl:value-of>
					<xsl:value-of select="';'"></xsl:value-of>
				</xsl:if>
				<xsl:if test="@value">
					<xsl:value-of select="'--NeutralAddedValue:'" />
					<xsl:value-of select="@value" />
					<xsl:value-of select="';'" />
				</xsl:if>
			</xsl:attribute>
			<hr>
				<xsl:attribute name="class">
					<xsl:text>good arrow </xsl:text>
					<xsl:choose>
						<xsl:when test="@complete">
							<xsl:text>from</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>to</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</hr>
			<div>
				<article>
					<i class="icon {@type}"></i>
					<h4><xsl:value-of select="@name" /></h4>
				</article>
			</div>
			<hr class="good arrow to" />
		</section>
		<xsl:if test="@foreign">
			<hr class="variable arrow from" />
		</xsl:if>
	</div>
</xsl:template>

<xsl:template match="diagram[not(preceding::diagram)]" mode="include-once">
	<xsl:call-template name="body-css">
		<xsl:with-param name="content">
			<link rel="stylesheet" href="assets/css/components/c-chain.css"/>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template match="diagram">
	<xsl:apply-templates select="." mode="include-once" />
	<xsl:variable name="id" select="concat('diagram-', count(preceding::diagram))"></xsl:variable>
	<article class="buying chain diagram">
		<xsl:apply-templates select="." mode="ajax-diagrams"></xsl:apply-templates>
	</article>
</xsl:template>

<!-- Pour intégrer les diagrammes au complet dans l'expérience, retirer le mode ci-dessous -->
<xsl:template match="diagram" priority="1" mode="ajax-diagrams">
	<xsl:variable name="total-chain-links" select="@links" />
	<xsl:variable name="actual-chain-links" select="count(agent)" />
	<xsl:variable name="missing-links" select="$total-chain-links - $actual-chain-links" />
	<xsl:variable name="id" select="concat('diagram-', count(preceding::diagram))"></xsl:variable>

	<div id="{$id}">
		<xsl:apply-templates />
		<xsl:call-template name="missing-chain-links">
			<xsl:with-param name="missing-links" select="$missing-links" />
		</xsl:call-template>
	</div>
</xsl:template>

<xsl:template name="missing-chain-links">
	<xsl:param name="missing-links" select="0" />
	<xsl:choose>
		<xsl:when test="$missing-links > 0">
			<div class="unknown-link">
				<hr class="good arrow to" />
				<span class="icon">?</span>
			</div>
			<xsl:call-template name="missing-chain-links">
				<xsl:with-param name="missing-links" select="$missing-links - 1"></xsl:with-param>
			</xsl:call-template>
		</xsl:when>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>


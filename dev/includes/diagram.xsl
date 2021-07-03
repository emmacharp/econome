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
		<section class="link agent {@type} {@class}" style="--link-position: {count(preceding-sibling::*) + 1};">


			<div>
				<xsl:apply-templates select="@local|@value|@paid" />
				<article>
					<xsl:if test="@goods">

						<xsl:apply-templates select="." mode="include-once" />
						<aside class="goods-list">
							<input type="checkbox" name="trigger-goods-list" class="trigger-goods-list" />
							<div hx-get="goods.html" hx-trigger="revealed" hx-select="#goods-list" hx-swap="outerHTML">
							</div>
						</aside>
					</xsl:if>
					<xsl:apply-templates select="ext:node-set($svg-elements)//svg:symbol[generate-id() = generate-id(key('symbol-type', current()/@type)[1])]" />
					<h4><xsl:apply-templates select="@name" /></h4>
				</article>
				<xsl:apply-templates select="@foreign" />
			</div>
		</section>
	</xsl:template>

	<xsl:template match="diagram/product" name="diagram-product">
		<xsl:param name="missing-links" select="0"/>
		<xsl:param name="total-chain-links" select="0"/>
		<xsl:param name="actual-chain-links" select="0"/>
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
			<xsl:attribute name="style">
				<xsl:choose>
					<xsl:when test="not($missing-links)">
						<xsl:value-of select="concat('--link-position:', count(preceding-sibling::*) + 1, ';')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat('--link-position: ', ($total-chain-links - $missing-links) * 2, ';')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
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
	<xsl:template match="agent[@goods and not(preceding::agent[@goods])]" mode="include-once">
		<xsl:call-template name="body-css">
			<xsl:with-param name="content">
				<link rel="stylesheet" href="assets/css/components/c-goods-list.css"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="diagram">
		<xsl:apply-templates select="." mode="include-once" />
		<xsl:variable name="id" select="concat('diagram-', count(preceding::diagram))"></xsl:variable>
		<article class="buying chain diagram" hx-get="diagrams.html" hx-select="#{$id}" hx-trigger="revealed" style="--total-chain-links: {@links};"></article>
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
				<xsl:with-param name="actual-chain-links" select="$actual-chain-links"/>
				<xsl:with-param name="total-chain-links" select="$total-chain-links"/>
			</xsl:call-template>
		</div>
	</xsl:template>

	<xsl:template name="missing-chain-links">
		<xsl:param name="missing-links" select="0" />
		<xsl:param name="actual-chain-links" select="0"/>
		<xsl:param name="total-chain-links" select="0"/>
		<xsl:choose>
			<xsl:when test="$missing-links > 0">
				<xsl:call-template name="diagram-product">
					<xsl:with-param name="actual-chain-links" select="$actual-chain-links"/>
					<xsl:with-param name="total-chain-links" select="$total-chain-links"/>
					<xsl:with-param name="missing-links" select="$missing-links"></xsl:with-param>
				</xsl:call-template>
				<div class="unknown-link" style="--link-position: {($total-chain-links - $missing-links) * 2 + 1}">
					<hr class="good arrow to" />
					<span class="icon">?</span>
				</div>
				<xsl:call-template name="missing-chain-links">
					<xsl:with-param name="actual-chain-links" select="$actual-chain-links"/>
					<xsl:with-param name="total-chain-links" select="$total-chain-links"/>
					<xsl:with-param name="missing-links" select="$missing-links - 1"></xsl:with-param>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>


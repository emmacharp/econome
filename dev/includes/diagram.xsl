<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:svg="http://www.w3.org/2000/svg" xmlns:ext="http://exslt.org/common" exclude-result-prefixes="ext svg">

	<xsl:key name="agent-type" match="agent" use="@type"/>

	<xsl:variable name="product-file" select="document('product.xml', /)" />
	<xsl:variable name="goods-file" select="document('goods.xml', /)" />
	<xsl:variable name="macro-file" select="document('macro.xml', /)" />

	<xsl:template match="@type" mode="data-translator">
		<xsl:choose>
			<xsl:when test=". = 'retailer'">
				<xsl:text>depanneur</xsl:text>
			</xsl:when>
			<xsl:when test=". = 'transportation'">
				<xsl:text>transport</xsl:text>
			</xsl:when>
			<xsl:when test=". = 'manufacturer'">
				<xsl:text>entrepot</xsl:text>
			</xsl:when>
			<xsl:when test=". = 'transformer'">
				<xsl:text>brasserie</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="@foreign" mode="data-translator">
		<xsl:text>etranger</xsl:text>
	</xsl:template>
	<xsl:template match="@value" mode="data-translator">
		<xsl:text>ajout</xsl:text>
	</xsl:template>
	<xsl:template match="@bought|@added" mode="data-translator">
		<xsl:text>depense</xsl:text>
	</xsl:template>
	<xsl:template match="@local" mode="data-translator">
		<xsl:text>local</xsl:text>
	</xsl:template>

	<xsl:template match="agent/@local|agent/@foreign|agent/@value|agent/@bought|agent/@paid|agent/@total|agent/@added">
		<xsl:param name="number" select="." />
		<xsl:param name="name" select="name()" />
		<span class="added amount">
			<span>
				<xsl:choose>
					<xsl:when test="$name = 'paid'">
						<xsl:text>-</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>+</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:value-of select="concat($number, ' $')" />
			</span>
			<small>
				<xsl:choose>
					<xsl:when test="$name = 'local' or $name = 'foreign' or $name = 'bought'">
						<xsl:text>Valeur achetée</xsl:text>
					</xsl:when>
					<xsl:when test="$name = 'value' and (ancestor::agent/@local or ancestor::agent/@foreign or ancestor::agent/@bought)">
						<xsl:text>Valeur créée</xsl:text>
					</xsl:when>	
					<xsl:when test="$name = 'value' or $name = 'added'">
						<xsl:text>Valeur ajoutée</xsl:text>
					</xsl:when>
				</xsl:choose>
			</small>
		</span>
	</xsl:template>

	<xsl:template match="@paid|@total" mode="class-generator">
		<section class="{local-name()}">
			<xsl:apply-templates select="." />
		</section>
	</xsl:template>

	<xsl:template match="@added|@value|@bought|@local|@foreign" mode="class-generator">
		<xsl:variable name="is-transformer" select="boolean(ancestor::agent[@type = 'transformer'])" />

		<xsl:variable name="nodes">
			<xsl:choose>
				<xsl:when test="$is-transformer">
					<xsl:apply-templates select="." mode="data-translator" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="ancestor::agent/@type" mode="data-translator" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="file">
			<xsl:choose>
				<xsl:when test="$is-transformer">
					<xsl:copy-of select="$goods-file" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$product-file" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="units" select="boolean(ancestor::agent/@goods)" />
		<xsl:variable name="subunits" select="boolean(ancestor::agent/@goods = 'subunits')" />
		<xsl:variable name="column-counter">
			<xsl:apply-templates select="." mode="goods-counter"></xsl:apply-templates>
		</xsl:variable>

		<!-- TODO : nettoyer les données du Choose au complet -->
		<section class="{local-name()}">
			<xsl:if test="$units">
				<xsl:attribute name="style">
					<xsl:text>--columns-counter: </xsl:text>
					<xsl:value-of select="$column-counter" />
					<xsl:text>;</xsl:text>
				</xsl:attribute>
				<input aria-label="Afficher ou masquer les unités" type="checkbox" checked="" name="show-units" class="toggle-units" />
				<xsl:if test="$subunits">
					<input aria-label="Afficher ou masquer les sous-unités" type="checkbox" name="show-subunits" class="toggle-subunits" />
				</xsl:if>
				<xsl:choose>
					<xsl:when test="local-name() = 'value'">
						<xsl:apply-templates select="ext:node-set($file)//produit[@type = 'ajout' or ajout][generate-id() = generate-id(key('class-aggregate', classe))]/*[local-name() = $nodes]" mode="product-creator">
							<xsl:with-param name="relative" select="not($is-transformer)" />
							<xsl:with-param name="subunits" select="$subunits" />
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="local-name() = 'added'">
						<xsl:apply-templates select="ext:node-set($file)//produit[generate-id() = generate-id(key('class-aggregate', classe))]/*[local-name() = $nodes or local-name() = 'depense' or local-name() = 'ajout']" mode="product-creator">
							<xsl:with-param name="relative" select="not($is-transformer)" />
							<xsl:with-param name="subunits" select="$subunits" />
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="local-name() = 'bought'">
						<xsl:apply-templates select="ext:node-set($file)//produit[not(@type = 'ajout')][generate-id() = generate-id(key('class-aggregate', classe))]/*[local-name() = $nodes or local-name() = 'depense']" mode="product-creator">
							<xsl:with-param name="relative" select="not($is-transformer)" />
							<xsl:with-param name="subunits" select="$subunits" />
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="ext:node-set($file)//produit[not(@type = 'ajout')][generate-id() = generate-id(key('class-aggregate', classe))]/*[local-name() = $nodes]" mode="product-creator">
							<xsl:with-param name="relative" select="not($is-transformer)" />
							<xsl:with-param name="subunits" select="$subunits" />
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<section class="amounts">
				<xsl:apply-templates select="." />
				<xsl:if test="ancestor::agent[@goods]">
					<xsl:choose>
						<xsl:when test="local-name() = 'value'">
							<xsl:apply-templates select="ext:node-set($file)//produit[@type = 'ajout' or ajout][generate-id() = generate-id(key('class-aggregate', classe))]" mode="class-item">
								<xsl:with-param name="node-name" select="$nodes" />
								<xsl:with-param name="relative" select="not($is-transformer)" />
								<xsl:with-param name="subunits" select="$subunits" />
								<xsl:with-param name="total-dollars" select="." />
							</xsl:apply-templates>
						</xsl:when>
						<xsl:when test="local-name() = 'added'">
							<xsl:apply-templates select="ext:node-set($file)//produit[generate-id() = generate-id(key('class-aggregate', classe))]" mode="class-item">
								<xsl:with-param name="node-name" select="$nodes" />
								<xsl:with-param name="relative" select="not($is-transformer)" />
								<xsl:with-param name="subunits" select="$subunits" />
								<xsl:with-param name="total-dollars" select="." />
							</xsl:apply-templates>
							<xsl:apply-templates select="ext:node-set($file)//produit[@type = 'ajout' or ajout][generate-id() = generate-id(key('class-aggregate', classe))]" mode="class-item">
								<xsl:with-param name="node-name" select="'ajout'" />
								<xsl:with-param name="relative" select="not($is-transformer)" />
								<xsl:with-param name="subunits" select="$subunits" />
								<xsl:with-param name="total-dollars" select="." />
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="ext:node-set($file)//produit[not(@type = 'ajout')][generate-id() = generate-id(key('class-aggregate', classe))]" mode="class-item">
								<xsl:with-param name="node-name" select="$nodes" />
								<xsl:with-param name="relative" select="not($is-transformer)" />
								<xsl:with-param name="subunits" select="$subunits" />
								<xsl:with-param name="total-dollars" select="." />
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</section>
		</section>
	</xsl:template>

	<xsl:template match="diagram/agent">
		<section class="link agent {@type} {@class}">	
			<xsl:if test="@goods|@paid|@value|@foreign|@local|@total|@bought|@added">
				<aside>
					<xsl:if test="@goods">
						<xsl:attribute name="class">
							<xsl:text disable-output-escaping="yes">goods-list</xsl:text>
						</xsl:attribute>
					</xsl:if>
					<section class="product {@type}">
						<xsl:apply-templates select="@added" mode="class-generator" />
						<xsl:apply-templates select="@foreign" mode="class-generator" />
						<xsl:apply-templates select="@value" mode="class-generator" />
						<xsl:apply-templates select="@bought" mode="class-generator" />
						<xsl:apply-templates select="@local" mode="class-generator" />
						<xsl:apply-templates select="@paid|@total" mode="class-generator" />
					</section>
				</aside>
			</xsl:if>
			<article>

				<xsl:apply-templates select="ext:node-set($svg-symbols)//svg:symbol[generate-id() = generate-id(key('symbol-type', current()/@type)[1])]">
					<xsl:with-param name="class" select="'icon'" />
				</xsl:apply-templates>
				<h4><xsl:apply-templates select="@name" /></h4>
			</article>
		</section>
	</xsl:template>

	<xsl:template match="diagram/product" name="diagram-product">
		<xsl:param name="missing-links" select="0"/>
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
			<article>
				<i class="icon {@type}"></i>
				<h4><xsl:value-of select="@name" /></h4>
			</article>
		</section>
	</xsl:template>

	<xsl:template match="diagram[@type = 'macro']" mode="ajax-diagrams">
		<xsl:variable name="id" select="concat('diagram-', count(preceding::diagram))" />

		<div id="{$id}" class="goods-list">
			<xsl:for-each select="ext:node-set($macro-file)//produit[disponible]">
				<xsl:variable name="column-counter" select="ceiling(disponible div 100000)"></xsl:variable>
				<section class="worker available" style="--column-counter: {ceiling($column-counter)}">
					<h4><span><xsl:value-of select="titre" /></span></h4>
					<div>
						<xsl:apply-templates select="disponible" mode="product-creator">
							<xsl:with-param name="multiplier" select="3" />
						</xsl:apply-templates>
					</div>
				</section>
			</xsl:for-each>
			<xsl:for-each select="ext:node-set($macro-file)//produit[local|etranger]">
				<xsl:variable name="prod-factor" select="ceiling((prod-local + prod-etranger) div 10000)" />
				<xsl:variable name="worker-factor" select="ceiling((local + etranger) div 100000)" />
				<xsl:variable name="available-factor" select="ceiling((local + etranger) div 100000)" />
				<xsl:variable name="column-counter">
					<xsl:choose>
						<xsl:when test="$prod-factor &gt; worker-factor">
							<xsl:value-of select="$prod-factor" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$worker-factor" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<section style="--column-counter: {ceiling($column-counter)}">
					<h4><span><xsl:value-of select="titre" /></span></h4>

					<div class="product">
						<div class="local">
							<xsl:apply-templates select="local" mode="product-creator">
								<xsl:with-param name="multiplier" select="10 div emploi-ratio" />
							</xsl:apply-templates>
						</div>
						<div class="foreign">
							<xsl:apply-templates select="etranger" mode="product-creator">
								<xsl:with-param name="multiplier" select="10 div emploi-ratio" />
							</xsl:apply-templates>
						</div>
					</div>
					<div class="worker">
						<div class="local">
							<xsl:apply-templates select="local" mode="product-creator">
								<xsl:with-param name="multiplier" select="3" />
								<xsl:with-param name="code" select="'WOR'" />
							</xsl:apply-templates>
						</div>
						<div class="foreign">
							<xsl:apply-templates select="etranger" mode="product-creator">
								<xsl:with-param name="multiplier" select="3" />
								<xsl:with-param name="code" select="'WOR'" />
							</xsl:apply-templates>
						</div>
					</div>

				</section>
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template match="diagram[not(preceding::diagram)]" mode="include-once">
		<xsl:call-template name="body-css">
			<xsl:with-param name="content">
				<link rel="stylesheet" href="assets/css/components/c-goods-list.css"/>
				<link rel="stylesheet" href="assets/css/components/c-figure.css"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="diagram[not(preceding::diagram[@type = 'chain'])]/@type[. = 'chain']" mode="include-once">
		<xsl:call-template name="body-css">
			<xsl:with-param name="content">
				<link rel="stylesheet" href="assets/css/components/c-chain.css"/>
			</xsl:with-param>
		</xsl:call-template>
		</xsl:template>

		<xsl:template match="diagram[not(preceding::diagram[@type = 'macro'])]/@type[. = 'macro']" mode="include-once">
		<xsl:call-template name="body-css">
			<xsl:with-param name="content">
				<link rel="stylesheet" href="assets/css/components/c-macro.css"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="diagram">
		<xsl:apply-templates select=".|@type" mode="include-once" />
		<xsl:variable name="id" select="concat('diagram-', count(preceding::diagram))"></xsl:variable>
		<article class="{@type} diagram" hx-get="diagrams.html" hx-select="#{$id}" hx-trigger="intersect once"></article>
	</xsl:template>

	<xsl:template match="diagram[@type = 'chain']" mode="ajax-diagrams">
		<xsl:variable name="total-chain-links" select="@links" />
		<xsl:variable name="actual-chain-links" select="count(agent)" />
		<xsl:variable name="missing-links" select="$total-chain-links - $actual-chain-links" />
		<xsl:variable name="id" select="concat('diagram-', count(preceding::diagram))" />

		<div id="{$id}">
			<xsl:apply-templates />
		</div>
	</xsl:template>
</xsl:stylesheet>


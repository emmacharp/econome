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

	<xsl:template name="head-css">
		<link rel="stylesheet" href="assets/css/utilities/u-superdiv.css"/>
		<link rel="stylesheet" href="assets/css/utilities/u-visually_hidden.css"/>

		<link rel="stylesheet" href="assets/css/theme/t-library.css"/>
		<link rel="stylesheet" href="assets/css/theme/t-config.css"/>
		<link rel="stylesheet" href="assets/css/theme/t-setup.css"/>
		<link rel="stylesheet" href="assets/css/theme/t-typography.css"/>
		<link rel="stylesheet" href="assets/css/theme/t-general.css"/>
		<link rel="stylesheet" href="assets/css/theme/t-special.css"/>
		<link rel="stylesheet" href="assets/css/theme/t-controls.css"/>

		<link rel="stylesheet" href="assets/css/theme/t-light_scheme.css" media="screen" />
		<link id="sheetLightScheme" rel="stylesheet" href="assets/css/theme/t-light_scheme.css" media="screen and (prefers-color-scheme: light)" />
		<link id="sheetDarkScheme" rel="stylesheet" href="assets/css/theme/t-dark_scheme.css" media="screen and (prefers-color-scheme: dark)" />
		<link id="sheetDarkHighContrast" rel="stylesheet" href="assets/css/theme/t-dark-high_contrast.css" media="screen and (prefers-contrast: high) and (prefers-color-scheme: dark)" />
		<link id="sheetLightHighContrast" rel="stylesheet" href="assets/css/theme/t-light-high_contrast.css" media="screen and (prefers-contrast: high) and (prefers-color-scheme:light)" />
		<link id="sheetAnimations" rel="stylesheet" href="assets/css/patterns/p-section_visibility-transitions.css" media="not screen and (prefers-reduced-motion: reduce)" />

		<link rel="stylesheet" href="assets/css/components/c-cartoon_characters.css" />

		<link rel="stylesheet" href="assets/css/patterns/p-provenance.css"/>
		<link rel="stylesheet" href="assets/css/patterns/p-type-emojis.css"/>
		<link rel="stylesheet" href="assets/css/patterns/p-auto_line-height.css"/>

		<link rel="stylesheet" href="assets/css/layout/l-master_composition.css"/>
		<link rel="stylesheet" href="assets/css/x-quarantine.css"/>
		</xsl:template>

		<xsl:template name="body-css">
			<xsl:param name="content"/>
			<xsl:copy-of select="$content"/>
		</xsl:template>

		<xsl:template name="scripts">
			<script src="assets/js/libraries.min.js"></script>
			<script src="assets/js/main.js"></script>
		</xsl:template>

	<xsl:template match="root" mode="body" name="body">
		<body>
			<xsl:apply-templates select=".//details" mode="include-once"/>
			<xsl:call-template name="internal-navigation"/>
			<xsl:call-template name="main-content"/>
			<link rel="stylesheet" href="assets/css/components/c-customizer_menu.css"/>
			<details id="customizerMenu">
				<summary><span>Préférences</span></summary>
				<menu>
					<li>
							<div>
								<small>Zoom</small>
								<input type="number" name="zoom" value="1" min="0.1" max="2.0" step="0.1" />
							</div>
					</li>
					<li>
							<div>
							<small>Thème</small>
								<label><input type="radio" name="theme" value="light"/><span>clair</span></label>
								<label><input type="radio" name="theme" value="auto" checked="" /><span>auto</span></label>
								<label><input type="radio" name="theme" value="dark"/><span>sombre</span></label>
							</div>
					</li>
					<li>
							<div>
								<small>Animations</small>
								<label><input type="radio" name="animations" value="on"/><span>oui</span></label>
								<label><input type="radio" name="animations" value="auto" checked=""/><span>auto</span></label>
								<label><input type="radio" name="animations" value="off"/><span>non</span></label>
							</div>
					</li>
					<li>
						<label><span>Activer le mode de contraste élevé</span><input type="checkbox" name="contrast"/></label>
					</li>
				</menu>
			</details>
			<xsl:apply-templates select="footer" />
			<xsl:call-template name="wiki-viewer"/>
			<xsl:call-template name="svg-elements"/>
			<xsl:call-template name="scripts"/>	
		</body>
	</xsl:template>



	<xsl:key name="agent-type" match="agent" use="@data-type"/>

	<xsl:variable name="product-file" select="document('product.xml', /)" />
	<xsl:variable name="goods-file" select="document('goods.xml', /)" />
	<xsl:variable name="macro-file" select="document('macro.xml', /)" />

	<xsl:template match="@data-type" mode="data-translator">
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
		<xsl:variable name="is-transformer" select="boolean(ancestor::agent[@data-type = 'transformer'])" />

		<xsl:variable name="nodes">
			<xsl:choose>
				<xsl:when test="$is-transformer">
					<xsl:apply-templates select="." mode="data-translator" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="ancestor::agent/@data-type" mode="data-translator" />
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
				<!-- <input aria-label="Afficher ou masquer les unités" type="checkbox" checked="" name="show-units" class="toggle-units" /> -->
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
		<div class="link agent {@data-type} {@class}">	
			<xsl:if test="@goods|@paid|@value|@foreign|@local|@total|@bought|@added">
				<aside>
					<xsl:if test="@goods">
						<xsl:attribute name="class">
							<xsl:text disable-output-escaping="yes">goods-list</xsl:text>
						</xsl:attribute>
					</xsl:if>
					<section class="product {@data-type}">
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

				<xsl:apply-templates select="ext:node-set($svg-symbols)//svg:symbol[generate-id() = generate-id(key('symbol-type', current()/@data-type)[1])]">
					<xsl:with-param name="class" select="'icon'" />
				</xsl:apply-templates>
				<h4><xsl:apply-templates select="@name" /></h4>
			</article>
		</div>
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
				<i class="icon {@data-type}"></i>
				<h4><xsl:value-of select="@name" /></h4>
			</article>
		</section>
	</xsl:template>

	<xsl:template match="diagram[@data-type = 'macro']" mode="ajax-diagrams">
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

	<xsl:template match="diagram[not(preceding::diagram[@data-type = 'chain'])]/@data-type[. = 'chain']" mode="include-once">
		<xsl:call-template name="body-css">
			<xsl:with-param name="content">
				<link rel="stylesheet" href="assets/css/components/c-chain.css"/>
			</xsl:with-param>
		</xsl:call-template>
		</xsl:template>

		<xsl:template match="diagram[not(preceding::diagram[@data-type = 'macro'])]/@data-type[. = 'macro']" mode="include-once">
		<xsl:call-template name="body-css">
			<xsl:with-param name="content">
				<link rel="stylesheet" href="assets/css/components/c-macro.css"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="diagram">
		<xsl:apply-templates select=".|@data-type" mode="include-once" />
		<xsl:variable name="id" select="concat('diagram-', count(preceding::diagram))"></xsl:variable>
		<article class="{@data-type} diagram" data-hx-get="diagrams.html" data-hx-swap="beforeend" data-hx-select="#{$id}" data-hx-trigger="intersect once">
			<h4 class="visually-hidden"><xsl:value-of select="@heading" /></h4>
		</article>
	</xsl:template>

	<xsl:template match="diagram[@data-type = 'chain']" mode="ajax-diagrams">
		<xsl:variable name="total-chain-links" select="@links" />
		<xsl:variable name="actual-chain-links" select="count(agent)" />
		<xsl:variable name="missing-links" select="$total-chain-links - $actual-chain-links" />
		<xsl:variable name="id" select="concat('diagram-', count(preceding::diagram))" />

		<div id="{$id}">
			<xsl:apply-templates />
		</div>
	</xsl:template>

<xsl:template match="fieldset[not(preceding::fieldset)]" mode="include-once">
	<xsl:call-template name="body-css">
		<xsl:with-param name="content">
			<link rel="stylesheet" href="assets/css/components/c-fieldset.css"/>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>
<xsl:template match="fieldset">
	<xsl:apply-templates select="." mode="include-once"/>
	<xsl:element name="fieldset">
		<xsl:apply-templates select="@*"></xsl:apply-templates>
		<xsl:apply-templates />
	</xsl:element>		
</xsl:template>
<xsl:template name="grid-paper-pattern">
		<script>
			const doc = document.documentElement;
			const body = document.querySelector('body');
			const html = document.querySelector('html');
			const main = document.querySelector('main');
			body.style.setProperty('overflow-y', 'scroll');
			// Snap to CSS Grid Paper Pattern Function
			const setPaperGrid = () => {
			let GridUnit = Math.ceil(parseFloat(window.getComputedStyle(html).getPropertyValue('line-height')) / 2);
			let FontSize = Math.floor(parseFloat(window.getComputedStyle(html).getPropertyValue('font-size')));
			let Row = GridUnit * 2;
			let ViewportWidth = doc.clientWidth;
			let ViewportHeight = window.innerHeight;
			let H_GridUnitRest = ViewportWidth - (Math.floor(ViewportWidth / GridUnit) * GridUnit);
			let V_GridUnitRest = ViewportHeight - (Math.floor(ViewportHeight / GridUnit) * GridUnit);
			html.style.cssText = `--GridValue: ${GridUnit};`;
			body.style.cssText = `--H_GridUnitRest: ${H_GridUnitRest}px; --V_GridUnitRest:${V_GridUnitRest}px; --GridUnit: ${GridUnit}px; --Row: ${Row}px;`;
			}
			setPaperGrid();
			window.addEventListener('resize', setPaperGrid);
		</script>
		<link rel="stylesheet" href="assets/css/patterns/p-grid_paper.css"/>
	</xsl:template>
	<xsl:template name="head">
		<head>
			<title>E : Pourquoi acheter local ? </title>

			<meta name="apple-mobile-web-app-capable" content="yes"/>
			<meta name="apple-mobile-web-app-status-bar-style" content="#ff0000"/>
			<meta name="description" content="Econome informe le public grâce à l'exposition de faits économiques."/>
			
			<link rel="icon" href="data:," />

			<meta name="viewport" content="width=device-width"/>

			<xsl:call-template name="head-css"></xsl:call-template>
		</head>
	</xsl:template>
	<xsl:template name="internal-navigation">
		<input aria-label="Ouvrir ou fermer la navigation" type="checkbox" class="toggle-internal-nav" />
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



	<xsl:template name="main-content">
		<main>
			<xsl:apply-templates mode="main-content" />
		</main>
	</xsl:template>

	<xsl:template match="*|@*" mode="include-once"></xsl:template>

	<xsl:template match="section[not(preceding::section)]" mode="include-once">
		<xsl:call-template name="body-css">
			<xsl:with-param name="content">
				<link rel="stylesheet" href="assets/css/layout/l-section_composition.css"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="aside[@class='intervention'][not(preceding::aside[@class='intervention'])]" mode="include-once">
		<xsl:call-template name="body-css">
			<xsl:with-param name="content">
				<link rel="stylesheet" href="assets/css/components/c-intervention.css"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="details[not(preceding::details)]" mode="include-once">
		<xsl:call-template name="body-css">
			<xsl:with-param name="content">
				<link rel="stylesheet" href="assets/css/components/c-details.css"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

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

	<xsl:template match="h2" mode="main-content">
		<h2>
			<span>
				<xsl:apply-templates />
			</span>
		</h2>
	</xsl:template>

	<xsl:template match="section/div[position() = last()][symbol[@data-parallax][not(preceding::symbol[@data-parallax])]]" mode="include-once">
		<xsl:call-template name="body-css">
			<xsl:with-param name="content">
				<script src="assets/js/parallax.js"></script>
				<script>setParallaxData();</script>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="section/div[position() = last()][symbol[@data-parallax]]">
	<!-- <xsl:if test="not(preceding::symbol[@data-parallax])"> -->
		<!-- 	<script src="assets/js/parallax.js"></script> -->
		<!-- </xsl:if> -->
	<xsl:element name="div">
		<xsl:apply-templates select="@*"/>
		<xsl:apply-templates/>
		<xsl:apply-templates select="." mode="include-once"/>
	</xsl:element>

</xsl:template>

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
		<xsl:apply-templates select="ext:node-set($svg-symbols)//svg:symbol[generate-id() = generate-id(key('symbol-type', current()/@data-type)[1])]">
			<xsl:with-param name="attr" select="@*[not(name() = 'type')]" />
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="h2" mode="symbol-chooser">
		<xsl:text>svg-bookmark-symbol</xsl:text>
	</xsl:template>
	<xsl:template match="section" mode="symbol-chooser">
		<xsl:choose>
			<xsl:when test="@data-type = 'observation'">
				<xsl:text>svg-lightbulb-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="@data-type ='question'">
				<xsl:text>svg-question-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="@data-type ='chaine'">
				<xsl:text>svg-chainlink-symbol</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>svg-book-symbol</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="code" mode="symbol-chooser" name="symbol-chooser">
		<xsl:param name="code" select="." />
		<xsl:choose>
			<xsl:when test="contains($code, 'MIN')">
				<xsl:text>svg-minerals-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'ALI')">
				<xsl:text>svg-food-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'IMM') or contains($code ,'IMS551002')">
				<xsl:text>svg-building-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'PRM') or contains($code, 'COT') or contains($code ,'PRM600000')">
				<xsl:text>svg-contribution-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'CON')">
				<xsl:text>svg-construction-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'REV')">
				<xsl:text>svg-moneybag-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'SAL')">
				<xsl:text>svg-salary-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'PRO')">
				<xsl:text>svg-professional-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'FIN')">
				<xsl:text>svg-finance-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'CUL')">
				<xsl:text>svg-culture-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'ADM')">
				<xsl:text>svg-admin-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'HEB')">
				<xsl:text>svg-restaurant-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code ,'PRM800000')">
				<xsl:text>svg-money-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'WOR') or contains(. ,'PRM500000')">
				<xsl:text>svg-worker-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'MPS533000')">
				<xsl:text>svg-copyright-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'FAB') or contains($code, 'MPG322201')">
				<xsl:text>svg-cardboard-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'MPG332401')">
				<xsl:text>svg-cap-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'AGRI') or contains($code, 'MPG311208') or contains($code, 'GRA')">
				<xsl:text>svg-cereal-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'AUT') or contains($code, 'MPS541800')">
				<xsl:text>svg-advertising-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'ETA') or contains($code, 'PRM400000')">
				<xsl:text>svg-tax-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'MPS722001')">
				<xsl:text>svg-meal-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'MPG327A02') or contains($code, 'PLA')">
				<xsl:text>svg-bottle-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'MPG311301')">
				<xsl:text>svg-sugar-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'TRA') or contains($code, 'MPS')">
				<xsl:text>svg-truck-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'ENE')">
				<xsl:text>svg-electricity-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'MPG')">
				<xsl:text>svg-goods-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'GRO')">
				<xsl:text>svg-warehouse-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'DET')">
				<xsl:text>svg-retail-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'SAN')">
				<xsl:text>svg-health-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'ART')">
				<xsl:text>svg-show-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'ENS')">
				<xsl:text>svg-school-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'MED')">
				<xsl:text>svg-antenna-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'ELE')">
				<xsl:text>svg-transistor-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'ORD')">
				<xsl:text>svg-computer-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'PET')">
				<xsl:text>svg-oil-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'WOO')">
				<xsl:text>svg-lumber-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'VET')">
				<xsl:text>svg-shirt-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'ALC')">
				<xsl:text>svg-alcohol-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'MED')">
				<xsl:text>svg-antenna-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'MAC')">
				<xsl:text>svg-machine-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'MET')">
				<xsl:text>svg-bolt-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'CHI')">
				<xsl:text>svg-chemistry-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'PAP')">
				<xsl:text>svg-paper-symbol</xsl:text>
			</xsl:when>
			<xsl:when test="contains($code, 'PRI')">
				<xsl:text>svg-printer-symbol</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>svg-unknown-symbol</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="svg-elements">
		<svg xmlns="http://www.w3.org/2000/svg" class="svg" style="position:absolute; width:0; height:0; overflow: hidden;">
      <clipPath id="clip-cheveux_emma">
        <path id="cheveux1"
        d="M130,87.499c0,0 33.816,12.746 57,11c23.184,-1.745 52.969,-18.442 59,-21c6.031,-2.557 27.496,6.044 32,11c4.504,4.956 29.934,35.023 33,55c3.066,19.978 -1.816,75.816 -2,76c-0.184,0.185 5.586,28.775 6,29c0.414,0.226 5,-13 5,-13c0,0 3.969,-76.108 3,-82c-0.969,-5.891 1.461,-55.202 -44,-79c-9.148,-4.329 -4.711,-11.901 -1,-16c3.711,-4.098 11.385,-8.614 16,-5c-10.359,-6.766 -22.393,4.447 -22,7c-3.564,-6.307 -54.285,-19.846 -43,-39c6.815,-11.565 12.42,-7.747 16,-7l3.58,0.747c-15.916,-7.359 -19.437,1.512 -24.58,8.253c-7.727,-14.723 -32.732,-33.317 -90,-17c-57.268,16.318 -43.414,23.072 -68,25c-24.586,1.929 -30.561,-4.719 -31,-5c-0.439,-0.28 14.17,32.052 38,38c-32.586,-1.975 -12.816,11.552 -27,6c-14.184,-5.551 -6.088,0.308 -7,-4c-5.189,8.589 12.961,5.384 18,12c5.039,6.617 19.205,2.968 19,3c-0.205,0.033 -13.295,12.455 -15,16c-1.705,3.546 -8.49,7.539 -12,4l-3.51,-3.538c4.688,8.424 11.637,9.153 15.51,8.538c-5.682,4.122 -10.719,10.058 -12,17c-1.281,6.943 5.947,29.996 7,41c1.053,11.005 1.51,33.767 1,38c-0.51,4.234 2.885,26.177 3,27c0.115,0.824 4.871,10.628 5,11c0.129,0.372 5,7 5,7c0,0 1.955,-19.907 3,-25c1.045,-5.092 -8.17,-58.594 4,-76c12.17,-17.405 27.934,-67.719 53,-59Z" />
      </clipPath>
		<defs>
			<linearGradient id="degrade-cheveux_emma" x1="0" y1="0" x2="1" y2="0"
			gradientUnits="userSpaceOnUse"
			gradientTransform="matrix(-2.04102,-145.654,145.654,-2.04102,189.389,256.934)">

			<stop offset="0%"
			style="stop-color:#d4d4d4;stop-opacity:1" />
			<stop offset="60%"
			style="stop-color:#d9d9d9;stop-opacity:0.827451" />
			<stop offset="81%"
			style="stop-color:#e6e6e6;stop-opacity:0.423529" />
			<stop offset="100%"
			style="stop-color:#f3f3f3;stop-opacity:0" />
			<stop offset="100%"
			style="stop-color:#f3f3f3;stop-opacity:0" />
		</linearGradient>
	</defs>
			<clipPath id="beer-clip-path" clipPathUnits="objectBoundingBox"><path d="M0.151,0.122 C0.273,0.115,0.396,0.111,0.518,0.112 C0.581,0.112,0.643,0.113,0.701,0.114 C0.771,0.116,0.841,0.121,0.909,0.128 C0.922,0.129,0.937,0.131,0.952,0.132 L1,0.137 C0.992,0.123,0.979,0.111,0.962,0.1 C0.959,0.097,0.955,0.095,0.951,0.093 C0.942,0.088,0.935,0.084,0.93,0.078 C0.925,0.073,0.922,0.067,0.922,0.061 C0.922,0.058,0.921,0.055,0.92,0.052 C0.92,0.051,0.92,0.05,0.92,0.049 C0.92,0.042,0.915,0.036,0.906,0.03 C0.897,0.025,0.884,0.022,0.871,0.022 L0.851,0.021 C0.797,0.018,0.652,0.011,0.49,0.011 C0.39,0.011,0.291,0.014,0.191,0.02 L0.167,0.022 C0.154,0.022,0.141,0.025,0.132,0.03 C0.123,0.035,0.117,0.042,0.117,0.049 C0.117,0.05,0.117,0.05,0.117,0.051 C0.116,0.054,0.116,0.057,0.115,0.06 C0.115,0.073,0.094,0.086,0.079,0.096 L0.075,0.099 C0.06,0.109,0.048,0.12,0.039,0.132 C0.076,0.128,0.114,0.124,0.151,0.122 M0.885,0.908 C0.763,0.915,0.641,0.919,0.518,0.919 C0.396,0.919,0.273,0.915,0.151,0.908 C0.107,0.906,0.062,0.902,0.019,0.896 C0.019,0.908,0.027,0.92,0.041,0.93 C0.055,0.94,0.076,0.947,0.098,0.95 C0.114,0.954,0.121,0.955,0.123,0.958 C0.123,0.959,0.123,0.959,0.123,0.96 C0.125,0.968,0.133,0.976,0.144,0.982 C0.155,0.988,0.17,0.992,0.186,0.993 C0.236,1,0.402,1,0.517,1 C0.632,1,0.798,1,0.848,0.993 C0.864,0.992,0.879,0.988,0.89,0.982 C0.901,0.976,0.909,0.968,0.911,0.96 C0.911,0.96,0.911,0.959,0.911,0.958 C0.914,0.955,0.92,0.954,0.936,0.95 C0.959,0.947,0.979,0.94,0.993,0.93 C1,0.92,1,0.908,1,0.896 C0.973,0.902,0.929,0.906,0.885,0.908 M0.518,0.637 C0.598,0.637,0.663,0.579,0.663,0.507 C0.663,0.435,0.598,0.377,0.518,0.377 C0.438,0.377,0.373,0.435,0.373,0.507 C0.373,0.579,0.438,0.637,0.518,0.637 M1,0.174 C0.997,0.171,0.963,0.168,0.94,0.166 C0.924,0.164,0.908,0.163,0.895,0.161 C0.83,0.155,0.764,0.151,0.697,0.15 C0.64,0.148,0.58,0.147,0.518,0.147 C0.268,0.147,0.068,0.161,0.021,0.171 C0.019,0.18,0.018,0.188,0.018,0.196 V0.859 C0.061,0.87,0.264,0.884,0.518,0.884 C0.773,0.884,0.976,0.87,1,0.859 V0.196 C1,0.189,1,0.181,1,0.174 M0.731,0.507 C0.731,0.6,0.638,0.672,0.518,0.672 C0.399,0.672,0.305,0.599,0.305,0.507 C0.305,0.414,0.399,0.342,0.518,0.342 C0.638,0.342,0.731,0.414,0.731,0.507"/></clipPath>
			<defs>
				<linearGradient id="gradient-local-foreign" x1="0" x2="0" y1="0" y2="1">
					<stop offset="0%" stop-color="var(--ColorForeign)"/>
					<stop offset="100%" stop-color="var(--ColorLocal)"/>
				</linearGradient>
			</defs>
		</svg>
	</xsl:template>
<xsl:template name="wiki-viewer">
	<xsl:call-template name="body-css">
		<xsl:with-param name="content">
			<link rel="stylesheet" href="assets/css/components/c-wiki_viewer.css"/>
		</xsl:with-param>
	</xsl:call-template>

	<aside id="wikiViewer">
		<div>
			<header>
				<h2>Connaissances complémentaires</h2>
				<button id="wikiViewerClose">Fermer</button>
			</header>
			<div id="wikiDump"></div>
			<footer>
				<span>Contenu de Wikipedia.</span>
				<a id="wikiCanonical" rel="canonical" target="_blank" href="#">Visiter la page</a
				></footer>
		</div>
	</aside>
</xsl:template>
</xsl:stylesheet>

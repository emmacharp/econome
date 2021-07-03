<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:svg="http://www.w3.org/2000/svg"
xmlns:xlink="http://www.w3.org/1999/xlink"
xmlns:msxsl="urn:schemas-microsoft-com:xslt"
xmlns:ext="http://exslt.org/common"
xmlns:math="http://exslt.org/math"
exclude-result-prefixes="ext msxsl svg math">


<xsl:output method="html" doctype-system="about:legacy-compat" />

	<!-- Identity transform -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
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

	<xsl:template name="head-css">
		<link rel="stylesheet" href="assets/css/utilities/u-superdiv.css"/>

		<link rel="stylesheet" href="assets/css/theme/t-dark_scheme.css" media="screen and (prefers-color-scheme: dark)" />
		<link rel="stylesheet" href="assets/css/theme/t-library.css"/>
		<link rel="stylesheet" href="assets/css/theme/t-config.css"/>
		<link rel="stylesheet" href="assets/css/theme/t-setup.css"/>
		<link rel="stylesheet" href="assets/css/theme/t-typography.css"/>
		<link rel="stylesheet" href="assets/css/theme/t-general.css"/>
		<link rel="stylesheet" href="assets/css/theme/t-special.css"/>
		<link rel="stylesheet" href="assets/css/theme/t-controls.css"/>

		<link rel="stylesheet" href="assets/css/components/c-arrows.css"/>
		<!-- <link rel="stylesheet" href="assets/css/components/c-cartoon_characters.css" /> -->

		<link rel="stylesheet" href="assets/css/patterns/p-provenance.css"/>
		<link rel="stylesheet" href="assets/css/patterns/p-auto_line-height.css"/>
		<!-- <link rel="stylesheet" href="assets/css/patterns/p-section_visibility-transitions.css" /> -->
		<!-- <link rel="stylesheet" href="assets/css/patterns/p-stacking_slides.css"/> -->

		<link rel="stylesheet" href="assets/css/layout/l-master_composition.css"/>
		<!-- <link rel="stylesheet" href="assets/css/x-dev.css"> -->
		</xsl:template>

		<xsl:template name="body-css">
			<xsl:param name="content"/>
			<xsl:copy-of select="$content"/>
		</xsl:template>

		<xsl:template name="scripts">
			<script src="assets/js/htmx.min.js"></script>
			<script src="assets/js/main.js" defer="defer"></script>
			<link rel="stylesheet" href="assets/css/x-quarantine.css"/>
		</xsl:template>

	<xsl:template match="root" mode="body" name="body">
		<body>
			<!-- <xsl:call-template name="grid-paper-pattern" /> -->
			<xsl:call-template name="internal-navigation"/>
			<xsl:call-template name="main-content"/>
			<xsl:apply-templates select="footer" />
			<xsl:call-template name="wiki-viewer"/>
			<xsl:call-template name="svg-elements"/>
			<xsl:call-template name="scripts"/>	
		</body>
	</xsl:template>



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
					<xsl:apply-templates select="ext:node-set($svg-symbols)//svg:symbol[generate-id() = generate-id(key('symbol-type', current()/@type)[1])]" />
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
			<script>document.documentElement.classList.add('has-js');</script>
			<title>ECONOME présente : l'achat local</title>
			<meta charset="UTF-8"/>
			<meta name="apple-mobile-web-app-capable" content="yes"/>
			<meta name="apple-mobile-web-app-status-bar-style" content="#ff0000"/>
			<link rel="icon" href="data:;base64,iVBORwOKGO=" />

			<meta name="viewport" content="width=device-width, user-scalable=no"/>

			<xsl:call-template name="head-css"></xsl:call-template>		
		</head>
	</xsl:template>
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


	<xsl:template name="main-content">
		<main>
			<xsl:apply-templates mode="main-content" />
		</main>
	</xsl:template>
	<xsl:template match="*" mode="include-once"></xsl:template>
	<xsl:template match="section[not(preceding::section)]" mode="include-once">
		<xsl:call-template name="body-css">
			<xsl:with-param name="content">
				<link rel="stylesheet" href="assets/css/layout/l-section_composition.css"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="*" mode="main-content"/>
	<xsl:template match="section" mode="main-content">
		<xsl:apply-templates select="." mode="include-once"/>
		<xsl:variable name="id" select="concat('id-', count(preceding-sibling::*))"></xsl:variable>
		<xsl:variable name="wordcount" select="string-length(normalize-space(.)) - string-length(translate(normalize-space(.),' ','')) +1"/>
		<xsl:variable name="needed-time" select="number($wordcount) div 1000 * 60000"/>
		<section data-wordcount="{$wordcount}" data-needed-time="{$needed-time}">
			<xsl:apply-templates select="@*" />
			<xsl:if test=".//h3">
				<xsl:attribute name="id">
					<xsl:value-of select="$id"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</section>
	</xsl:template>

	<xsl:template match="h2" mode="main-content">
		<xsl:variable name="id" select="concat('id-', count(preceding-sibling::*))"></xsl:variable>
		<h2 id="{$id}">
			<xsl:apply-templates />
		</h2>
	</xsl:template>

	<xsl:template match="title" mode="main-content">
		<small>
			<xsl:apply-templates />
		</small>
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
		<xsl:param name="attr" select="@*[not(name() = 'id')]" />
		<svg xmlns="http://www.w3.org/2000/svg" class="icon" viewBox="{@viewBox}">
			<xsl:apply-templates select="$attr" />
			<use xlink:href="symbols.svg#{@id}"></use>
		</svg>
	</xsl:template>

	<xsl:template match="symbol">
		<xsl:apply-templates select="ext:node-set($svg-symbols)//svg:symbol[generate-id() = generate-id(key('symbol-type', current()/@type)[1])]">
			<xsl:with-param name="attr" select="@*[not(name() = 'type')]" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template name="svg-elements">
		<svg xmlns="http://www.w3.org/2000/svg" class="svg" style="position:absolute; width:0; height:0; overflow: hidden;">
			<clipPath id="beer-clip-path" clipPathUnits="objectBoundingBox">
				<path d="M0.121,0.791 c-0.033,0,-0.06,-0.02,-0.06,-0.044 l0,-0.277 c0,-0.024,0.027,-0.044,0.06,-0.044 l0.152,0 l0,-0.05 l-0.241,0 c-0.018,0,-0.032,0.01,-0.032,0.023 l0,0.418 c0,0.013,0.014,0.023,0.032,0.023 l0.241,0 l0,-0.05 l-0.152,0 m0.203,-0.642 l0.662,0 c-0.022,-0.04,-0.061,-0.053,-0.119,-0.052 c-0.03,-0.061,-0.094,-0.098,-0.184,-0.098 c-0.091,0,-0.15,0.035,-0.183,0.095 c-0.075,-0.017,-0.15,-0.004,-0.176,0.054 m-0.005,0.089 l0.681,0 l0,-0.049 l-0.681,0 l0,0.049 m0,0.076 l0.681,0 l0,-0.042 l-0.681,0 l0,0.042 m0.573,0.034 l0,0.493 l0.108,0 l0,-0.493 l-0.108,0 m-0.119,0.493 l0.073,0 l0,-0.493 l-0.073,0 l0,0.493 m0.227,0.11 l-0.681,0 l0,0.049 l0.681,0 l0,-0.049 m0,-0.076 l-0.681,0 l0,0.042 l0.681,0 l0,-0.042 m-0.407,-0.527 l0,0.493 l0.134,0 l0,-0.493 l-0.134,0 m-0.119,0 l0,0.493 l0.073,0 l0,-0.493 l-0.073,0 m-0.154,0 l0,0.493 l0.108,0 l0,-0.493 l-0.108,0"/>
			</clipPath>
			<defs>
				<linearGradient id="gradient-local-foreign" x1="0" x2="0" y1="0" y2="1">
					<stop offset="0%" stop-color="var(--ColorLocal)"/>
					<stop offset="100%" stop-color="var(--ColorForeign)"/>
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
				<h2>Conaissances complémentaires</h2>
				<button id="wikiViewerClose">Fermer</button>
			</header>
			<div id="wikiDump"></div>
			<footer>
				<span>Contenu provenant de Wikipedia.</span>
				<a id="wikiCanonical" rel="canonical" target="_blank" href="#">Visiter la page officielle</a
				></footer>
		</div>
	</aside>
</xsl:template>
</xsl:stylesheet>

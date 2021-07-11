<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:svg="http://www.w3.org/2000/svg"
xmlns:xlink="http://www.w3.org/1999/xlink"
xmlns:msxsl="urn:schemas-microsoft-com:xslt"
xmlns:ext="http://exslt.org/common"
exclude-result-prefixes="ext msxsl">
<xsl:import href="index.xsl"/>
<xsl:output method="html" doctype-system="about:legacy-compat" />
<xsl:variable name="special-characters" select="'/ áàâäéèêëíìîïóòôöúùûüçÁÀÂÄÉÈÊËÍÌÎÏÓÒÔÖÚÙÛÜÇABCDEFGHIJKLMNOPQRSTUVWXYZ&amp;’?.()!:,'"/>
<xsl:variable name="normalized-special-characters" select="'--aaaaeeeeiiiioooouuuuçaaaaeeeeiiiioooouuuuçabcdefghijklmnopqrstuvwxyz_'"/>

<xsl:key name="class-aggregate" match="produit" use="classe"/>

<xsl:template match="/">
	<html>
		<head>
			<title>Liste de biens économiques</title>
			<link rel="stylesheet" href="assets/css/components/c-goods-list.css" />
			<xsl:call-template name="head-css" />
		</head>
		<body>
			<section>
				<div id="goods-list">
					<section class="foreign">
						<xsl:apply-templates select="//produit[depense]" mode="percentage-squares">
							<xsl:with-param name="source" select="'foreign'" />
							<xsl:sort select="depense" order="descending" data-type="number" />
						</xsl:apply-templates>
					</section>
					<section class="local">
						<xsl:apply-templates select="//produit[depense]" mode="percentage-squares">
							<xsl:with-param name="source" select="'local'" />
							<xsl:sort select="depense" order="descending" data-type="number" />
						</xsl:apply-templates>
					</section>
					<section class="value">
						<xsl:apply-templates select="//produit[ajout]" mode="percentage-squares">
							<xsl:with-param name="source" select="'ajout'" />
							<xsl:sort select="ajout" order="descending" data-type="number" />
						</xsl:apply-templates>
					</section>
				</div>
				<ul>
					<xsl:apply-templates select="//produit[depense|ajout]" mode="proportional-rows">
						<xsl:sort select="depense" order="descending" data-type="number" />
					</xsl:apply-templates>
				</ul>
			</section>
			<xsl:apply-templates select="//depanneur|//transport|//entrepot|//brasserie|//depense" mode="list-creator" />
			<xsl:call-template name="scripts" />
		</body>
		</html>
	</xsl:template>

	<xsl:template match="*" mode="list-creator">
		<xsl:variable name="node-name" select="local-name()"></xsl:variable>

		<xsl:variable name="id">
			<xsl:choose>
				<xsl:when test="$node-name = 'depanneur'">
					<xsl:text>retailer</xsl:text>
				</xsl:when>
				<xsl:when test="$node-name = 'transport'">
					<xsl:text>transportation</xsl:text>
				</xsl:when>
				<xsl:when test="$node-name = 'entrepot'">
					<xsl:text>manufacturer</xsl:text>
				</xsl:when>
				<xsl:when test="$node-name = 'brasserie' or $node-name = 'depense'">
					<xsl:text>transformer</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$node-name" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="not(preceding::*[local-name() = $node-name])">
			<section class="product {$id}">
				<!-- TODO : nettoyer les données du Choose au complet -->
				<xsl:choose>
					<xsl:when test="not($node-name = 'depense')">
						<section class="foreign"></section>
						<section class="local">
							<xsl:apply-templates select="//produit[not(@type = 'ajout')][generate-id() = generate-id(key('class-aggregate', classe)[1])]/*[local-name() = $node-name]" mode="product-creator">
								<xsl:with-param name="relative" select="true()" />
							</xsl:apply-templates>
						</section>
						<section class="value">
							<xsl:apply-templates select="//produit[@type = 'ajout'][generate-id() = generate-id(key('class-aggregate', classe)[1])]/*[local-name() = $node-name]" mode="product-creator">
								<xsl:with-param name="relative" select="true()" />
							</xsl:apply-templates>
						</section>

					</xsl:when>
					<xsl:otherwise>
						<section class="local">
							<xsl:apply-templates select="//produit[generate-id() = generate-id(key('class-aggregate', classe)[1])]/local" mode="product-creator" />
						</section>
						<section class="foreign">
							<xsl:apply-templates select="//produit[generate-id() = generate-id(key('class-aggregate', classe)[1])]/etranger" mode="product-creator" />
						</section>
						<section class="value">
							<xsl:apply-templates select="//produit[generate-id() = generate-id(key('class-aggregate', classe)[1])]/ajout" mode="product-creator" />
						</section>
					</xsl:otherwise>
				</xsl:choose>
		</section>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="product-creator" priority="-1"></xsl:template>
	<xsl:template match="depanneur|transport|entrepot|brasserie|depense|ajout|local|etranger" mode="product-creator">
		<xsl:param name="relative" select="false()"></xsl:param>
		<xsl:variable name="node-name" select="local-name()"></xsl:variable>
		<xsl:variable name="number">
			<xsl:choose>
				<xsl:when test="$relative = true()">
					<xsl:value-of select=". div /root/total/*[local-name() = $node-name] * /root/donnees/*[local-name() = $node-name]" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="." />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="percentage">
			<xsl:value-of select="format-number($number div //total/depense * 100, '#.###')"/>
		</xsl:variable>
		<xsl:variable name="rounded-per-cent">
			<xsl:value-of select="round($percentage * 1.5)"/>
		</xsl:variable>
		<xsl:variable name="rounded-per-mille">
			<xsl:value-of select="round($percentage * 5)"/>
		</xsl:variable>
		<xsl:variable name="square-total">
			<xsl:value-of select="$rounded-per-cent"/>
		</xsl:variable>
		<xsl:if test="$square-total &gt; 0">
			<xsl:apply-templates select="ancestor::produit[1]" mode="percentage-squares">
				<xsl:with-param name="square-total" select="$square-total" />
				<xsl:with-param name="percentage" select="$percentage" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="code" mode="class-name-chooser">
		<xsl:variable name="classcode" select="substring(., 1, 3)" />
		<xsl:choose>
			<xsl:when test="$classcode = 'MPG'">
				<xsl:text>Biens</xsl:text>
			</xsl:when>
			<xsl:when test="$classcode = 'MPS'">
				<xsl:text>Services</xsl:text>
			</xsl:when>
			<xsl:when test="$classcode = 'ENE'">
				<xsl:text>Énergie</xsl:text>
			</xsl:when>
			<xsl:when test="$classcode = 'PRM'">
				<xsl:text>Prestations</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Classe inconnue</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="code" mode="symbol-chooser">
		
		<xsl:choose>
			<xsl:when test="contains(., 'MIN')">
				<use xlink:href="symbols.svg#svg-minerals-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(., 'ALI')">
				<use xlink:href="symbols.svg#svg-food-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(., 'IMM')">
				<use xlink:href="symbols.svg#svg-building-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(., 'COT')">
				<use xlink:href="symbols.svg#svg-contribution-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(., 'CON')">
				<use xlink:href="symbols.svg#svg-construction-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(., 'REV')">
				<use xlink:href="symbols.svg#svg-moneybag-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(., 'SAL')">
				<use xlink:href="symbols.svg#svg-salary-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(., 'PRO')">
				<use xlink:href="symbols.svg#svg-professional-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(., 'FIN')">
				<use xlink:href="symbols.svg#svg-finance-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(., 'CUL')">
				<use xlink:href="symbols.svg#svg-culture-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(., 'ADM')">
				<use xlink:href="symbols.svg#svg-admin-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(., 'HEB')">
				<use xlink:href="symbols.svg#svg-restaurant-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(. ,'PRM800000')">
				<use xlink:href="symbols.svg#svg-money-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(. ,'PRM500000')">
				<use xlink:href="symbols.svg#svg-worker-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(. ,'IMS551002')">
				<use xlink:href="symbols.svg#svg-building-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(. ,'PRM600000')">
				<use xlink:href="symbols.svg#svg-contribution-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(., 'MPS533000')">
				<use xlink:href="symbols.svg#svg-copyright-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(., 'MPG322201')">
				<use xlink:href="symbols.svg#svg-cardboard-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(., 'MPG332401')">
				<use xlink:href="symbols.svg#svg-cap-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(., 'MPG311208')">
				<use xlink:href="symbols.svg#svg-cereal-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(., 'MPS541800')">
				<use xlink:href="symbols.svg#svg-advertising-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(., 'PRM400000')">
				<use xlink:href="symbols.svg#svg-tax-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(., 'MPS722001')">
				<use xlink:href="symbols.svg#svg-meal-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(., 'MPG327A02')">
				<use xlink:href="symbols.svg#svg-bottle-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(., 'MPG311301')">
				<use xlink:href="symbols.svg#svg-sugar-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(., 'MPS')">
				<use xlink:href="symbols.svg#svg-truck-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(., 'ENE')">
				<use xlink:href="symbols.svg#svg-electricity-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(., 'MPG')">
				<use xlink:href="symbols.svg#svg-goods-symbol"></use>
			</xsl:when>
			<xsl:when test="contains(., 'PRM')">
				<use xlink:href="symbols.svg#svg-contribution-symbol"></use>
			</xsl:when>
			<xsl:otherwise>
				<use xlink:href="symbols.svg#svg-unknown-symbol"></use>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="code" mode="emoji-chooser">
		<xsl:param name="index" select="''"/>
		<xsl:choose>
			<xsl:when test="contains(., 'ADM')">
				<xsl:choose>
					<xsl:when test="$index = 1">
						<span>📠</span>
					</xsl:when>
					<xsl:when test="$index = 2">
						<span>📞</span>
					</xsl:when>
					<xsl:when test="$index = 3">
						<span>🗄</span>
					</xsl:when>
					<xsl:otherwise>
						<span>📠</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains(., 'PRM')">
				<span>💵</span>
			</xsl:when>
			<xsl:when test="contains(., 'IMM')">
				<xsl:choose>
					<xsl:when test="$index = 1">
						<span>🏭</span>
					</xsl:when>
					<xsl:when test="$index = 2">
						<span>🏢</span>
					</xsl:when>
					<xsl:otherwise>
						<span>🏭</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains(., 'ALI')">
				<xsl:choose>
					<xsl:when test="$index = 1">
						<span>🍽</span>
					</xsl:when>
					<xsl:when test="$index = 2">
						<span>☕</span>
					</xsl:when>
					<xsl:otherwise>
						<span>🍽</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains(., 'PAP')">
				<xsl:choose>
					<xsl:when test="$index = 1">
						<span>📃</span>
					</xsl:when>
					<xsl:when test="$index = 2">
						<span>🏷</span>
					</xsl:when>
					<xsl:otherwise>
						<span>📃</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains(., 'MET')">

				<xsl:choose>
					<xsl:when test="$index = 1">
						<span>🔗</span>
					</xsl:when>
					<xsl:when test="$index = 2">
						<span>🖇</span>
					</xsl:when>
					<xsl:otherwise>
						<span>🔗</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains(., 'MPS')">
				<span>🚛</span>
			</xsl:when>
			<xsl:when test="contains(., 'HEB')">
				<span>🍔</span>
			</xsl:when>
			<xsl:when test="contains(., 'CUL')">
				<span>👩‍💻</span>
			</xsl:when>
			<xsl:otherwise>
				<span>🌫</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="svg-symbol-creator">
		<svg width="100%" height="100%">
			<xsl:apply-templates select="code" mode="symbol-chooser"/>
		</svg>
	</xsl:template>

	<xsl:template name="span-generator">
		<xsl:param name="index" select="1" />
		<xsl:param name="total" select="20" />
		<xsl:param name="label" />

		<span><!-- <xsl:value-of select="$total"/> -->
			<xsl:call-template name="svg-symbol-creator"/>
			<!-- <xsl:apply-templates select="code" mode="emoji-chooser"> -->
			<!-- 	<xsl:with-param name="index" select="$index" /> -->
			<!-- </xsl:apply-templates> -->
			<xsl:if test="$index = $total">
				<xsl:copy-of select="$label"/>
			</xsl:if>
		</span>

		<xsl:if test="not($index = $total)">
			<xsl:call-template name="span-generator">
				<xsl:with-param name="index" select="$index + 1"/>
				<xsl:with-param name="total" select="$total"/>
				<xsl:with-param name="label" select="$label"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="produit" mode="proportional-rows">
		<xsl:variable name="percentage">
			<xsl:value-of select="format-number(depense div //total/depense * 100, '#.##')"/>
		</xsl:variable>
		<li data-code="{code}" style="--percent:{$percentage}%; --hue:{$percentage * 3.6}">
			<span><xsl:value-of select="concat($percentage, ' %')"/></span>
			<span><xsl:value-of select="nom|classe"/></span>
			<!-- <span><xsl:value-of select="depense"/></span> -->
		</li>
	</xsl:template>

	<xsl:template match="produit" mode="class-item">
		<xsl:param name="total-preceding" select="count(key('class-aggregate', substring(code, 1, 3)))" />
		<xsl:variable name="percentage">
			<xsl:value-of select="format-number(depense div //total/depense * 100, '#.#####')"/>
		</xsl:variable>
		<li style="--i: {$total-preceding + position()}"><xsl:value-of select="$percentage"/> <xsl:value-of select="nom|classe"/></li>
	</xsl:template>

	<xsl:template match="produit" mode="class-aggregate">
		<xsl:variable name="total-elements">
			<xsl:value-of select="count(key('class-aggregate', classe))"/>
		</xsl:variable>
		<xsl:variable name="preceding-node-count">
			<xsl:for-each select="preceding-sibling::produit[depense|ajout][generate-id() = generate-id(key('class-aggregate', substring(code, 1, 3)))]">
				<count><xsl:value-of select="count(key('class-aggregate', substring(code, 1, 3)))"/></count>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="aggregate-total">
			<xsl:value-of select="sum(key('class-aggregate', substring(code, 1, 3))/depense)"/>
		</xsl:variable>
		<xsl:variable name="base-coefficient">
			<xsl:value-of select="$aggregate-total div //total/depense"/>
		</xsl:variable>
		<xsl:variable name="percentage">
			<xsl:value-of select="format-number($base-coefficient * 100, '#.#####')"/>
		</xsl:variable>
		<xsl:variable name="total-preceding">
			<xsl:value-of select="sum(ext:node-set($preceding-node-count)/count)"/>
		</xsl:variable>
	
			<section style="--i: {position()}; --hue: {$percentage * 3.6}; --c: {$base-coefficient};">
				<header>
					<div>
						<span>
							<xsl:apply-templates select="code" mode="class-name-chooser"/>
						</span>
						<xsl:call-template name="svg-symbol-creator"/>
					</div>
				</header>
				<ol style="--m: {$total-elements};">
					<xsl:apply-templates select="key('class-aggregate', classe)" mode="class-item">
						<xsl:sort select="depense" order="descending" data-type="number" />
						<!-- <xsl:with-param name="total-preceding" select="$total-preceding"/> -->
					</xsl:apply-templates>
				</ol>
			</section>
	</xsl:template>

	<xsl:template match="produit" mode="percentage-squares">
		<xsl:param name="square-total" select="0" />
		<xsl:param name="percentage" select="0" />
		<!-- <span><xsl:value-of select="$square-total"/></span> -->
		<xsl:if test="$square-total &gt; 0">
			<p data-code="{code}" style="--percent:{$percentage}%; --hue:{$percentage * 3.6}">
				<xsl:call-template name="span-generator">
					<xsl:with-param name="total" select="$square-total"/>
					<xsl:with-param name="label">
						<!-- TODO : nettoyer données -->
						<em><xsl:value-of select="nom|classe"/></em>
					</xsl:with-param>
				</xsl:call-template>
			</p>
		</xsl:if>
	</xsl:template>



	<xsl:template match="depense">
		<xsl:value-of select="sum(.)"/>
	</xsl:template>

</xsl:stylesheet>

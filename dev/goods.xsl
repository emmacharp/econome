<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:ext="http://exslt.org/common"
	exclude-result-prefixes="ext msxsl">
	<xsl:output indent="yes" media-type="text/html" method="html" encoding="UTF-8" />
	<xsl:variable name="special-characters" select="'/ áàâäéèêëíìîïóòôöúùûüçÁÀÂÄÉÈÊËÍÌÎÏÓÒÔÖÚÙÛÜÇABCDEFGHIJKLMNOPQRSTUVWXYZ&amp;’?.()!:,'"/>
	<xsl:variable name="normalized-special-characters" select="'--aaaaeeeeiiiioooouuuuçaaaaeeeeiiiioooouuuuçabcdefghijklmnopqrstuvwxyz_'"/>

	<xsl:key name="class-aggregate" match="produit[depense]" use="substring(code, 1, 3)"/>
	<xsl:key name="previous-class-aggregates" match="preceding-sibling::produit[depense][generate-id() = generate-id(key('class-aggregate', substring(code, 1, 3)))]" use="substring(code, 1, 3)"/>
	
	<xsl:template match="/industrie">
		<html>
			<head>
				<title>Liste de biens économiques</title>
			</head>
			<body>
				<main>
					<section>
						<div id="goods-list">
							<xsl:apply-templates select="produit[depense]" mode="percentage-squares">
								<xsl:sort select="depense" order="descending" data-type="number" />
							</xsl:apply-templates>
						</div>
						<ul>
							<xsl:apply-templates select="produit[depense]" mode="proportional-rows">
								<xsl:sort select="depense" order="descending" data-type="number" />
							</xsl:apply-templates>
						</ul>
					</section>
				</main>
			</body>
		</html>
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
			<xsl:when test="contains(., 'PRM')">
				<use xlink:href="symbols.svg#svg-contribution-symbol"></use>
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
			<xsl:otherwise>
				<use xlink:href="symbols.svg#svg-unknown-symbol"></use>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="code" mode="emoji-chooser">
		<xsl:choose>
			<xsl:when test="contains(., 'ADM')">
				<span>📠</span>
			</xsl:when>
			<xsl:when test="contains(., 'PRM')">
				<span>💵</span>
			</xsl:when>
			<xsl:when test="contains(., 'IMM')">
				<span>🏭</span>
			</xsl:when>
			<xsl:when test="contains(., 'ALI')">
				<span>🍽</span>
			</xsl:when>
			<xsl:when test="contains(., 'PAP')">
				<span>📃</span>
			</xsl:when>
			<xsl:when test="contains(., 'MET')">
				<span>🔗</span>
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

	<xsl:template match="produit[depense]" mode="proportional-rows">
		<xsl:variable name="percentage">
			<xsl:value-of select="format-number(depense div //total/depense * 100, '#.##')"/>
		</xsl:variable>
		<li data-code="{code}" style="--percent:{$percentage}%; --hue:{$percentage * 3.6}">
			<span><xsl:value-of select="concat($percentage, ' %')"/></span>
			<span><xsl:value-of select="nom"/></span>
			<!-- <span><xsl:value-of select="depense"/></span> -->
		</li>
	</xsl:template>

	<xsl:template match="produit[depense]" mode="class-item">
		<xsl:param name="total-preceding" select="count(key('class-aggregate', substring(code, 1, 3)))" />
		<xsl:variable name="percentage">
			<xsl:value-of select="format-number(depense div //total/depense * 100, '#.#####')"/>
		</xsl:variable>
		<li style="--i: {$total-preceding + position()}"><xsl:value-of select="$percentage"/> <xsl:value-of select="nom"/></li>
	</xsl:template>

	<xsl:template match="produit[depense]" mode="class-aggregate">
		<xsl:variable name="subcode" select="substring(code, 1, 3)" />
		<xsl:variable name="total-elements">
			<xsl:value-of select="count(key('class-aggregate', $subcode))"/>
		</xsl:variable>
		<xsl:variable name="preceding-node-count">
			<xsl:for-each select="preceding-sibling::produit[depense][generate-id() = generate-id(key('class-aggregate', substring(code, 1, 3)))]">
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
					<xsl:apply-templates select="key('class-aggregate', $subcode)" mode="class-item">
						<xsl:sort select="depense" order="descending" data-type="number" />
						<!-- <xsl:with-param name="total-preceding" select="$total-preceding"/> -->
					</xsl:apply-templates>
				</ol>
			</section>
	</xsl:template>

	<xsl:template match="produit[depense]" mode="percentage-squares">
		<xsl:variable name="percentage">
			<xsl:value-of select="format-number(depense div //total/depense * 100, '#.###')"/>
		</xsl:variable>
		<xsl:variable name="rounded-per-cent">
			<xsl:value-of select="round($percentage div 5)"/>
		</xsl:variable>
		<xsl:variable name="rounded-per-mille">
			<xsl:value-of select="round($percentage * 10)"/>
		</xsl:variable>
		<xsl:variable name="square-total">
			<!-- <xsl:choose>
				<xsl:when test="$rounded-per-mille &gt; 0">
					<xsl:value-of select="$rounded-per-mille"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="1"/>
				</xsl:otherwise>
			</xsl:choose> -->
			<xsl:value-of select="$rounded-per-cent"/>
		</xsl:variable>

		<!-- <span><xsl:value-of select="$square-total"/></span> -->
		<xsl:if test="$square-total &gt; 0">
			<p data-code="{code}" style="--percent:{$percentage}%; --hue:{$percentage * 3.6}">
				<xsl:call-template name="span-generator">
					<xsl:with-param name="total" select="$square-total"/>
					<xsl:with-param name="label">
						<em><xsl:value-of select="$percentage"/> % — <xsl:value-of select="nom"/></em>
					</xsl:with-param>
				</xsl:call-template>
			</p>
		</xsl:if>
	</xsl:template>



	<xsl:template match="depense">
		<xsl:value-of select="sum(.)"/>
	</xsl:template>

</xsl:stylesheet>

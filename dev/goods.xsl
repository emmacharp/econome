<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:svg="http://www.w3.org/2000/svg"
xmlns:xlink="http://www.w3.org/1999/xlink"
xmlns:msxsl="urn:schemas-microsoft-com:xslt"
xmlns:ext="http://exslt.org/common"
exclude-result-prefixes="ext msxsl">

	<xsl:key name="class-aggregate" match="produit" use="classe"/>

	<xsl:template match="*" mode="product-creator" priority="-1" />
	<xsl:template match="depanneur|transport|entrepot|brasserie|depense|ajout|local|etranger|disponible" mode="product-creator">
		<xsl:param name="relative" select="false()" />
		<xsl:param name="multiplier" select="1" />
		<xsl:param name="subunits" select="false()" />
		<xsl:param name="code" select="ancestor::produit/code" />
		<xsl:variable name="node-name" select="local-name()" />
		<xsl:variable name="number">
			<xsl:choose>
				<xsl:when test="$relative = true()">
					<xsl:value-of select=". div /root/total/*[local-name() = $node-name] * /root/donnees/*[local-name() = $node-name] * $multiplier" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select=". * $multiplier" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="total">
			<xsl:value-of select="/root/total/depense" />
		</xsl:variable>
		<xsl:variable name="coefficient">
			<xsl:value-of select="format-number($number div $total, '#.#####')"/>
		</xsl:variable>
		<xsl:variable name="percentage">
			<xsl:value-of select="$coefficient * 100" />
		</xsl:variable>
		<xsl:variable name="rounded-per-cent">
			<xsl:choose>
				<xsl:when test="$subunits = true()">
					<xsl:value-of select="ceiling($percentage)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="round($percentage)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="square-total">
			<xsl:value-of select="$rounded-per-cent"/>
		</xsl:variable>
		<xsl:apply-templates select="ancestor::produit[1]" mode="percentage-squares">
			<xsl:with-param name="square-total" select="$square-total" />
			<xsl:with-param name="percentage" select="$percentage" />
			<xsl:with-param name="code" select="$code" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template name="span-generator">
		<xsl:param name="index" select="1" />
		<xsl:param name="total" select="20" />
		<xsl:param name="label" />
		<xsl:param name="code" select="code" />

		<xsl:variable name="chosen-symbol">
			<xsl:call-template name="symbol-chooser">
				<xsl:with-param name="code" select="$code" />
				</xsl:call-template>
		</xsl:variable>
		<span>
			<xsl:apply-templates select="ext:node-set($svg-symbols)//svg:symbol[@id = $chosen-symbol]" />
			<xsl:if test="$index = $total">
				<xsl:copy-of select="$label"/>
			</xsl:if>
		</span>

		<xsl:if test="not($index = $total)">
			<xsl:call-template name="span-generator">
				<xsl:with-param name="index" select="$index + 1"/>
				<xsl:with-param name="total" select="$total"/>
				<xsl:with-param name="label" select="$label"/>
				<xsl:with-param name="code" select="$code" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="produit" mode="class-item">
		<xsl:param name="node-name" select="'depense'" />
		<xsl:param name="relative" select="false()" />
		<xsl:param name="total-dollars" />

		<xsl:variable name="number">
			<xsl:choose>
				<xsl:when test="$relative = true()">
					<xsl:value-of select="*[local-name() = $node-name] div /root/total/*[local-name() = $node-name] * /root/donnees/*[local-name() = $node-name]" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="*[local-name() = $node-name]" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="total">
			<xsl:value-of select="/root/total/depense" />
		</xsl:variable>
		<xsl:variable name="coefficient">
			<xsl:value-of select="format-number($number div $total, '#.#####')"/>
		</xsl:variable>
		<xsl:variable name="percentage">
			<xsl:value-of select="$coefficient * 100" />
		</xsl:variable>
		<xsl:variable name="rounded-percent">
			<xsl:value-of select="ceiling($percentage)" />
		</xsl:variable>
		<xsl:variable name="dollar-amount">
			<xsl:value-of select="$coefficient * 10" />
		</xsl:variable>
		<xsl:variable name="final-amount">
			<xsl:choose>
				<xsl:when test="$dollar-amount &lt; 0.01">
					<xsl:value-of select="concat('+', format-number($dollar-amount * 100, '0.00#'), ' ¢')" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('+', format-number($dollar-amount, '0.00'), ' $')" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$rounded-percent &gt; 0">
			<span class="added amount">
				<span>
					<xsl:value-of select="$final-amount" />
				</span>
				<small>
					<xsl:value-of select="nom|classe"/>
				</small>
			</span>
		</xsl:if>
	</xsl:template>

	<xsl:template match="produit" mode="percentage-squares">
		<xsl:param name="square-total" select="0" />
		<xsl:param name="percentage" select="0" />
		<xsl:param name="code" select="code" />
		<xsl:if test="$square-total &gt; 0">
			<p data-code="{$code}" debug="{$percentage}">
				<xsl:if test="$percentage &lt; 0.1">
					<xsl:attribute name="class">
						<xsl:text>subunit</xsl:text>
					</xsl:attribute>
				</xsl:if>
				<xsl:call-template name="span-generator">
					<xsl:with-param name="total" select="$square-total"/>	
					<xsl:with-param name="code" select="$code" />
				</xsl:call-template>
			</p>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
</xsl:stylesheet>

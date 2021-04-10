<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="head">
		<head>
			<script>document.documentElement.classList.add('has-js');</script>
			<title>Economia présente : l'achat local</title>
			<meta charset="UTF-8"/>
			<meta name="apple-mobile-web-app-capable" content="yes"/>
			<meta name="apple-mobile-web-app-status-bar-style" content="#ff0000"/>
			<link rel="icon" href="data:;base64,iVBORwOKGO=" />

			<meta name="viewport" content="width=device-width, initial-scale=1.0"/>

			<xsl:call-template name="head-css"></xsl:call-template>		
		</head>
	</xsl:template>
</xsl:stylesheet>

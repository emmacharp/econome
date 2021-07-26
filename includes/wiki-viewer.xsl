<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
				<span>Contenu provenant de Wikipedia.</span>
				<a id="wikiCanonical" rel="canonical" target="_blank" href="#">Visiter la page officielle</a
				></footer>
		</div>
	</aside>
</xsl:template>
</xsl:stylesheet>

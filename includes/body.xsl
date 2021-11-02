<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
</xsl:stylesheet>



<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="customizer-menu">
		<link rel="stylesheet" href="/assets/css/components/customizerMenu.css"/>
		<details id="customizerMenu">
			<summary><span>Préférences</span></summary>
			<menu>
				<li>
					<div>
						<label>
							<small>Zoom</small>
							<input type="number" name="zoom" value="1" min="0.1" max="2.0" step="0.1" />
						</label>
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
	</xsl:template>
</xsl:stylesheet>

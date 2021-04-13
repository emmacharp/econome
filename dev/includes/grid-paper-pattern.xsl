<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
</xsl:stylesheet>

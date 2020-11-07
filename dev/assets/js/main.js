(function () {
	'use strict';

	// Snap to CSS Backgorund Grid

	const html = document.getElementsByTagName('html')[0];
	const doc = document.documentElement;

	const ComputeRowRest = () => {
		let Row = parseFloat(window.getComputedStyle(html).getPropertyValue('line-height'));
		let ViewportWidth = doc.clientWidth;
		let ViewportHeight = doc.clientHeight;
		let H_RowRest = ViewportWidth - (Math.floor(ViewportWidth / Row) * Row);
		let V_RowRest = ViewportHeight - (Math.floor(ViewportHeight / Row) * Row);
		document.body.style.cssText = '--H_RowRest: '+H_RowRest+'px; --V_RowRest:'+V_RowRest+'px;';
	}
	
	window.addEventListener('DOMContentLoaded', ComputeRowRest);
	window.addEventListener('resize', ComputeRowRest);




	const onAnchorClick = (e) => {
		const index = [...anchors].indexOf(e.target);

		document.querySelector("main").scrollTo({
			left: index * window.innerWidth,
			top: index * window.innerHeight
		});
	}

	// Set Elements
	const sections = document.querySelectorAll("main>section");
	const anchors = document.querySelectorAll("nav>a");

	// Init Observer
	const threshold = 0.5;
	const observer = new IntersectionObserver((entries, observer) => {
		entries.forEach((entry) => {
			const { intersectionRatio, target } = entry;
			const sectionIndex = [...sections].indexOf(target);

			if (intersectionRatio >= threshold) {
				target.classList.add("is-visible");
				if (anchors.length) anchors[sectionIndex].classList.add("is-visible");
			} else {
				target.classList.remove("is-visible");
				if (anchors.length) anchors[sectionIndex].classList.remove("is-visible");
			}
		});
	}, {
		threshold
	});
	sections.forEach((el, index) => {
		observer.observe(el);
	});

	// Nav Events
	anchors.forEach((el) => {
		el.addEventListener("click", onAnchorClick);
	});

})();
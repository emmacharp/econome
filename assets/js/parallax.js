const parallaxItems = document.querySelectorAll('[data-parallax]');
const setParallaxData = () => {
	[...parallaxItems].forEach((el) => {
		const e = el.closest('div');
		const eH = e.offsetHeight || e.getBBox().height;
		const wH = window.innerHeight;
		const curScroll = (e.getBoundingClientRect().top - wH) * -1;
		const toScroll = eH + wH;
		let progress = Math.min(Math.max(curScroll, 0) / toScroll, 1);
		const factor = parseFloat(el.getAttribute('data-factor')) || 0.2;
		const fit = el.getAttribute('data-fit') || 'contain';
		
		
		if (fit === 'contain') {
			progress = (progress < 0.5 ? 1 - progress * 2 : progress * -2 + 1) * -1;
		} else {
			progress = 1 - progress;
		}

		console.log(e.getBoundingClientRect().top, progress);
		el.style.cssText += `--scrollParallax: ${progress * (eH * factor)}; --scrollFactor: ${progress};`;
	});
}

(function () {
	'use strict';

	// CSS Shapes Parallax Functions

	const onParallaxObserved = (items) => {
		items.forEach((item) => {
			const i = item;

			if (i.isIntersecting) {
				i.target.classList.add('is-visible');
				setParallaxData();
			} else {
				i.target.classList.remove('is-visible');
			}
		});
	}


	window.addEventListener('DOMContentLoaded', function() {
		// Parallax Observer
		// const parallaxObserver = new IntersectionObserver(onParallaxObserved);
		// parallaxItems.forEach((el) => {
		// 	parallaxObserver.observe(el);
		// });
		const parallaxItems = document.querySelectorAll('[data-parallax]');
		// Parallax Event Handler
		const parallaxEventHandler = () => requestAnimationFrame(setParallaxData);
		setParallaxData();
		window.addEventListener('resize', parallaxEventHandler);
		window.addEventListener('scroll', parallaxEventHandler);
		// const scrollInterval = setInterval(parallaxEventHandler, 10);

	});
})();

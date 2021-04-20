(function () {
	'use strict';

// Necessary DOM Elements

	const sections = document.querySelectorAll('main>section');
	const anchors = document.querySelectorAll('nav>a');
	const wikiLinks = document.querySelectorAll('[data-wiki]');
	const wikiViewer = document.querySelector('#wikiViewer');
	const wikiDump = document.querySelector('#wikiDump');
	const wikiCanonical = document.querySelector('#wikiCanonical');
	const wiki = document.createElement('section');

	wikiDump.appendChild(wiki);


// Internal Navigation Behavior Function

	const onAnchorClick = (e) => {
		const index = [...anchors].indexOf(e.target);
		document.querySelector('main').scrollTo({
			left: index * window.innerWidth,
			top: index * window.innerHeight
		});
	}


// Sections Observer with Binding to Internal Navigation Anchors Function

	const onSectionObserved = (items, observer) => {
		items.forEach((entry) => {
			const { isIntersecting , target } = entry;
			const sectionIndex = [...sections].indexOf(target);
			if (isIntersecting) {
				target.classList.remove('is-invisible');
				sections.forEach((item)=> {
					if (item.classList.contains('is-active')) item.classList.remove('is-active');
				});
				target.classList.add('is-visible', 'is-active');
				if (anchors.length) {
					anchors.forEach((item)=> {
						if (item.classList.contains('is-active')) item.classList.remove('is-active');
						anchors[sectionIndex].classList.add('is-active');
					});
				}
			} else {
				target.classList.remove('is-visible');
				target.classList.add('is-invisible');
			}
		});
	}



 // Fetching content from Wikipedia API

 	const fetchWikiContent = (event) => {
 		const el = event.target.closest('[data-wiki]') || event.target.closest('a');
 		const wikiPage = el.getAttribute('data-wiki') || el.getAttribute('href').split('/wiki/')[1];
 		let wikiUrl = '';
 		let wikiContent = '';
 		let wikiSectionIds = (el.getAttribute('data-sections')) ? el.getAttribute('data-sections').split(',') : null;

 		if (wikiSectionIds !== null) {
			wikiUrl = `https://fr.wikipedia.org/api/rest_v1/page/mobile-sections/${wikiPage}`;
 		} else {
 			wikiUrl = `https://fr.wikipedia.org/w/api.php?origin=*&format=json&action=parse&page=${wikiPage}&prop=text`;
 		}

 		fetch(wikiUrl)
 			.then(response => {
 				return response.json();
 			})
 			.then(data => {
				let wikiContent = '';

		 		if (wikiSectionIds !== null) {
	 				wikiSectionIds.forEach((id) => {
	 					if (id === '0') {
	 						wikiContent += data.lead.sections[id].text;
	 					} else {
	 						wikiContent += data.remaining.sections[id - 1].text;
	 					}
	 				});
	 			} else {
	 				wikiContent = data.parse.text['*'];
	 			}

	 			wikiContent = wikiContent.replace(/(style=".+?")/gm, '');
	 			wikiCanonical.setAttribute('href', `https://fr.wikipedia.org/wiki/${wikiPage}`);
	 			wiki.innerHTML = wikiContent;
	 			
	 			if(!wikiViewer.classList.contains('is-visible')){
	 				wikiViewer.classList.add('is-visible');
	 			}

 			})
 			.catch(error => console.log(error));
 	}


// Init All

	window.addEventListener('DOMContentLoaded', function() {

		// Sections Observer
		const sectionObserver = new IntersectionObserver(onSectionObserved, {
			rootMargin: "-45% 0% -55% 0%"
		});
		sections.forEach((item, index) => {
			sectionObserver.observe(item);
		});


		// Activate wiki integration
		wikiLinks.forEach((item) => {
			item.addEventListener('click', fetchWikiContent);
		});

		wikiDump.addEventListener('click', function(event) {
			let wikiLink = event.target.closest('a[href^="/wiki"]');

			if (!wikiLink) return;
			fetchWikiContent(event);
			event.preventDefault();
		});

		document.querySelector('#wikiViewerClose').addEventListener('click', function(event) {
			wikiViewer.classList.remove('is-visible');
		});


		// Nav Events
		anchors.forEach((item) => {
			item.addEventListener('click', onAnchorClick);
		});

		
	});

})();

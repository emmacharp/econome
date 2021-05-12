(function () {
	'use strict';

// Necessary DOM Elements

	const sections = document.querySelectorAll('main>section');
	const anchors = document.querySelectorAll('nav a');
	const wikiLinks = document.querySelectorAll('[data-wiki]');
	const wikiViewer = document.querySelector('#wikiViewer');
	const wikiDump = document.querySelector('#wikiDump');
	const wikiCanonical = document.querySelector('#wikiCanonical');
	const wiki = document.createElement('section');

	wikiDump.appendChild(wiki);

// Get Parents helper function
	// https://gomakethings.com/how-to-get-all-parent-elements-with-vanilla-javascript/
var getParents = function (elem, selector) {
	// Set up a parent array
	var parents = [];

	// Push each parent element to the array
	for ( ; elem && elem !== document; elem = elem.parentNode ) {
		if (selector) {
			if (elem.matches(selector)) {
				parents.push(elem);
			}
			continue;
		}
		parents.push(elem);
	}

	// Return our parent array
	return parents;

};



	}


// Sections Observer with Binding to Internal Navigation Anchors Function

	const onSectionObserved = (items, observer) => {
		items.forEach((entry) => {
			const { isIntersecting , target } = entry;
			const sectionIndex = [...sections].indexOf(target);
			let elapsed;
			let start;
			let time = target.getAttribute('data-needed-time');
			console.log('Je joue encore');
			
			if (isIntersecting) {
				target.classList.remove('is-invisible');
				time = target.getAttribute('data-needed-time');
				if (time > 0) {
					start = new Date().getTime();
					target.setAttribute('data-start-time', start);
				}
				sections.forEach((item)=> {
					if (item.classList.contains('is-active')) item.classList.remove('is-active');
				});
				target.classList.add('is-visible', 'is-active');
				if (anchors.length) {
					anchors.forEach((item)=> {
						let parentItems = getParents(item, 'li');
						parentItems.forEach((parent)=> {
							if (parent.classList.contains('has-active')) parent.classList.remove('has-active');
						});

						if (item.closest('li').classList.contains('is-active')) item.closest('li').classList.remove('is-active');
						anchors[sectionIndex].closest('li').classList.add('is-active');
						let activeParents = getParents(anchors[sectionIndex].closest('li').parentElement, 'li');
						[...activeParents].forEach((parent)=> {
							parent.classList.add('has-active');
						});
					});
				}
			} else {
				target.classList.remove('is-visible');
				target.classList.add('is-invisible');
				if (time > 0) {
					start = target.getAttribute('data-start-time') || new Date().getTime();
					let now = new Date().getTime();
					elapsed = now - start;
					time = time - elapsed;
					target.setAttribute('data-needed-time', time);
					if (time < 0) {
						target.classList.add('is-read');
						console.log(anchors[sectionIndex]);
						anchors[sectionIndex].closest('li').classList.add('is-read');
					}
				}
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


		});

		
	});

})();

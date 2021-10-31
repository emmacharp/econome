(function () {
	'use strict';

	// Necessary DOM Elements

	const sections = document.querySelectorAll('main>section[id]');
	const anchors = document.querySelectorAll('nav a');
	const complementaryLinks = document.querySelectorAll('[data-wiki]');
	const username = document.querySelector('#nom');

	const wikiViewer = document.querySelector('#wikiViewer');
	const wikiDump = document.querySelector('#wikiDump');
	const wikiCanonical = document.querySelector('#wikiCanonical');
	const wiki = document.createElement('div');
	const sessionUID = (Math.random() + 1).toString(36).substring(2);
	const formFields = document.querySelectorAll('select, input, textarea');
	console.log(formFields);

	if (wikiDump) wikiDump.appendChild(wiki);

	// Sections Observer with Binding to Internal Navigation Anchors Function
	const onSectionObserved = (items, observer) => {
		items.forEach((entry) => {
			const { isIntersecting , target } = entry;
			const itemId = target.getAttribute('id');
			const invalidForms = target.querySelectorAll('form :invalid');
			const anchor = [...anchors].filter(anchor => anchor.hash === '#'+itemId)[0];
			const forms = target.querySelectorAll('form');
			let elapsed;
			let start;
			let time = target.getAttribute('data-needed-time');

			if (isIntersecting) {
				// Activate Section and Anchor
				target.classList.remove('is-invisible');
				target.classList.add('is-active', 'is-visible');

				anchor?.closest('li').classList.add('is-active');
				anchor?.scrollIntoView({block: "nearest", inline: "nearest"});

				// Time
				if (time > 0) {
					start = new Date().getTime();
					target.setAttribute('data-start-time', start);
				}

			} else if (target.classList.contains('is-visible')) {
				// Deactivate Section
				target.classList.remove('is-active', 'is-visible');
				target.classList.add('is-invisible');

				if(!target.matches('.is-complete')) {
					if (time > 0) {
						start = target.getAttribute('data-start-time') || new Date().getTime();
						let now = new Date().getTime();
						elapsed = now - start;
						time = time - elapsed;
						target.setAttribute('data-needed-time', time);
						if (time < 0) {
							target.classList.add('is-read');
						} else {
							target.classList.add('is-incomplete');
						}
					}

					if (forms.length > 0 && invalidForms.length == 0) {
						target.classList.add('is-answered');
					} else {
						target.classList.add('is-incomplete');
					}

					if (target.matches('.is-incomplete.is-read') && 
						(forms.length == 0 || (forms.length > 0 && invalidForms.length == 0))) {
						target.classList.remove('is-incomplete', 'is-read', 'is-answered');
						target.classList.add('is-complete');
					}
				}

				if (anchor !== undefined) {
					const activeSectionClassList = target.classList;
					anchor.closest('li').className = activeSectionClassList;
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

				// Sanitize HTML (snyk vulnerability)
				const sanitizedWikiContent = DOMPurify.sanitize(wikiContent);
				wiki.innerHTML = sanitizedWikiContent;

				wikiCanonical.setAttribute('href', `https://fr.wikipedia.org/wiki/${wikiPage}`);
				if(!wikiViewer.classList.contains('is-visible')){
					wikiViewer.classList.add('is-visible');
				}

				wikiDump.scrollTop = 0;

			})
			.catch(error => console.log(error));
	}

	const pushToWorker = (uid, key, value) => {
		fetch('https://econome.io/worker/add', {
			method: 'POST',
			headers: {
				'content-type': 'application/json',
				'accept': 'application/json',
			},
			mode: 'no-cors',
			body: JSON.stringify({
				uid: uid, // The previously generated random user id
				key: key,
				value: value
			})
		}).then((response) => {
			if (response.ok) {
				console.log('data was saved')
			} else {
				console.error('error while saving data');
			}
		});
	}

	// Init All
	window.addEventListener('DOMContentLoaded', function() {

		// Sections Observer
		const sectionObserver = new IntersectionObserver(onSectionObserved, {
			rootMargin: "-45% -55% -55% -45%"
		});
		sections.forEach((item, index) => {
			sectionObserver.observe(item);
		});


		// Activate wiki integration
		document.body.addEventListener('click', function(event) {
			const clickTarget = event.target;

			if (clickTarget.matches('[data-wiki]')) event.target.classList.add('is-read');
			if (event.target.matches('[data-wiki]')) fetchWikiContent(event);
		});

		// Let users navigate through wiki links.
		if (wikiDump) {
			wikiDump.addEventListener('click', function(event) {
				let wikiLink = event.target.closest('a[href^="/wiki"]');

				if (!wikiLink) return;
				fetchWikiContent(event);
				event.preventDefault();
			});

			document.querySelector('#wikiViewerClose').addEventListener('click', function(event) {
				wikiViewer.classList.remove('is-visible');
			});
		}

		// Customizing username
		if (username) {
			// Change all existing usernames
			document.querySelector('#nom').addEventListener('change', function(event) {
				const	usernameInstances = document.querySelectorAll('.username');
				const customUsername = event.target.value || event.target.getAttribute('placeholder');
				usernameInstances.forEach((item) => {
					item.innerHTML = customUsername;
				});
			});

			// Custom username for ajax diagrams (htmx)
			document.body.addEventListener('htmx:afterProcessNode', function(event) {
				if(document.querySelector('#nom').value.length > 0) {
					const customUsername = document.querySelector('#nom').value;
					event.target.querySelectorAll('.username').forEach((item) => {
						item.innerHTML = customUsername;
					});
				}
			});
		}
		formFields.forEach((item) => {

			item.addEventListener('change', function(event) {
				const fieldName = event.target.getAttribute('name');
				const fieldValue = event.target.getAttribute('value');
				pushToWorker(sessionUID, fieldName, fieldValue);
			});
		});

	});

})();

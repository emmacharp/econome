(function () {
	'use strict';

	// Necessary DOM Elements

	const html = document.documentElement;
	const sections = document.querySelectorAll('main>section[id]');
	const anchors = document.querySelectorAll('nav a');
	const complementaryLinks = document.querySelectorAll('[data-wiki]');
	const username = document.querySelector('#nom');

	const totalSections = document.querySelectorAll('nav li').length;
	const completionProgress = document.querySelector('.completion-progress');
	const questionCompletion = document.querySelector('.question-completion');
	const readingCompletion = document.querySelector('.reading-completion');

	const wikiViewer = document.querySelector('#wikiViewer');
	const wikiDump = document.querySelector('#wikiDump');
	const wikiCanonical = document.querySelector('#wikiCanonical');
	const wiki = document.createElement('div');
	const sessionUID = (Math.random() + 1).toString(36).substring(2);
	const formFields = document.querySelectorAll('main select, main input, main textarea');

	const sheetDarkTheme = document.querySelector('#sheetDarkTheme');
	const sheetLightTheme = document.querySelector('#sheetLightTheme');
	const sheetAnimations = document.querySelector('#sheetAnimations');
	const sheetDarkHighContrast = document.querySelector('#sheetDarkHighContrast');
	const sheetLightHighContrast = document.querySelector('#sheetLightHighContrast');
	
	const darkThemeMedia = sheetDarkScheme.getAttribute('media');
	const lightThemeMedia = sheetLightScheme.getAttribute('media');
	const animationMedia = sheetAnimations.getAttribute('media');
	const darkHighContrastMedia = sheetDarkHighContrast.getAttribute('media');
	const lightHighContrastMedia = sheetLightHighContrast.getAttribute('media');

	const controlsTheme = document.querySelectorAll('input[name="theme"]');
	const controlsAnimations = document.querySelectorAll('input[name="animations"]');
	const controlsZoom = document.querySelectorAll('input[name="zoom"]');
	const controlsContrast = document.querySelectorAll('input[name="contrast"]');

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

				if (target.querySelector('.completion-progress')) {
					const totalFields = document.querySelectorAll('main fieldset').length;
					const totalComplete = document.querySelectorAll('nav li.is-complete').length;
					const totalRead = document.querySelectorAll('nav li.is-incomplete.is-read').length + totalComplete;
					const totalAnswered = document.querySelectorAll('main fieldset:valid').length;

					const readPercentage = Math.round(totalRead / totalSections * 100);
					const answeredPercentage = Math.round(totalAnswered / totalFields * 100);


					questionCompletion.innerHTML = answeredPercentage;
					readingCompletion.innerHTML = readPercentage;

					if(totalComplete === totalSections) {
						completionProgress.classList.add('.is-complete');
					}
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
		fetch('/worker/add', {
			method: 'POST',
			headers: {
				'content-type': 'application/json',
				'accept': 'application/json',
			},
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

		controlsTheme.forEach((item) => {
			item.addEventListener('change', function(event) {
				const themeValue = event.target.value;
				const contrastValue = html.getAttribute('data-contrast');

				if (themeValue === 'light') {
					sheetLightScheme.setAttribute('media', 'all');
					sheetDarkScheme.disabled = true;
					sheetLightScheme.disabled = false;
					html.setAttribute('data-theme', 'light');
					if (contrastValue) {
						sheetLightHighContrast.setAttribute('media', 'all');
						sheetDarkHighContrast.disabled = true;
						sheetLightHighContrast.disabled = false;
					}
				} else if (themeValue === 'dark') {
					sheetDarkScheme.setAttribute('media', 'all');
					sheetDarkScheme.disabled = false;
					sheetLightScheme.disabled = true;
					html.setAttribute('data-theme', 'dark');
					if (contrastValue) {
						sheetDarkHighContrast.disabled = false;
						sheetDarkHighContrast.setAttribute('media', 'all');
						sheetLightHighContrast.disabled = true;
					}
				} else {
					sheetDarkScheme.setAttribute('media', darkThemeMedia);
					sheetLightScheme.setAttribute('media', lightThemeMedia);
					sheetDarkScheme.disabled = false;
					sheetLightScheme.disabled = false;
					html.removeAttribute('data-theme');
					if (contrastValue) {
						sheetLightHighContrast.disabled = false;
						sheetDarkHighContrast.disabled = false;
						sheetDarkHighContrast.setAttribute('media', '(prefers-color-scheme:dark)');
						sheetLightHighContrast.setAttribute('media', '(prefers-color-scheme:light)');
					}

				}
			});
		})

		controlsZoom.forEach(item => {
			item.addEventListener('change', function(event) {
				const zoomValue = event.target.value;
				document.documentElement.style.setProperty('--Zoom', zoomValue);
			});
		});

		controlsAnimations.forEach(item => {
			item.addEventListener('change', function(event) {
				let animationValue = event.target.value;
				console.log(animationValue);
				if (animationValue === 'on') {
					sheetAnimations.disabled = false;
					sheetAnimations.setAttribute('media', 'all');
				} else if (animationValue === 'off') {
					sheetAnimations.disabled = true;
				} else {
					sheetAnimations.disabled = false;
					sheetAnimations.setAttribute('media', animationMedia);
				}
			});
		});

		controlsContrast.forEach(item => {
			item.addEventListener('change', function(event) {
				const contrastValue = event.target.checked;
				const currentTheme = html.getAttribute('data-theme');

				if (contrastValue === true) {
					html.setAttribute('data-contrast', 'true');
				} else {
					html.removeAttribute('data-contrast');
				}

				if (contrastValue === true && currentTheme === 'light') {
					sheetLightHighContrast.disabled = false;
					sheetLightHighContrast.setAttribute('media', 'all');
				} else if (contrastValue === true && currentTheme === 'dark') {
					sheetDarkHighContrast.disabled = false;
					sheetDarkHighContrast.setAttribute('media', 'all');
				} else if (contrastValue === true) {
					sheetDarkHighContrast.setAttribute('media', '(prefers-color-scheme:dark)');
					sheetLightHighContrast.setAttribute('media', '(prefers-color-scheme:light)');
				} else {
					sheetDarkHighContrast.setAttribute('media', darkHighContrastMedia);
					sheetLightHighContrast.setAttribute('media', lightHighContrastMedia);
				}
			});
		});


		formFields.forEach((item) => {

			item.addEventListener('change', function(event) {
				const fieldName = event.target.name;
				const fieldValue = event.target.value;

				pushToWorker(sessionUID, fieldName, fieldValue);
			});
		});

	});

})();

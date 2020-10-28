// let tan = Math.tan(Math.PI/5);

var ready = (callback) => {
  if (document.readyState != "loading") callback();
  else document.addEventListener("DOMContentLoaded", callback);
}

ready(() => {

	// document.getElementsByTagName('aside')[0].setAttribute('style', '--m:5; --tan:'+tan.toFixed(2))+';'
});
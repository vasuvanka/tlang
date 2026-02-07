(function() {
  function getLang() {
    var params = new URLSearchParams(window.location.search);
    return params.get('lang') || 'te';
  }
  function buildUrl(lang) {
    var path = window.location.pathname;
    var page = path.split('/').pop() || 'index.html';
    var params = new URLSearchParams(window.location.search);
    if (lang === 'te') params.delete('lang');
    else params.set('lang', lang);
    var q = params.toString();
    return page + (q ? '?' + q : '');
  }
  var lang = getLang();
  var enLink = document.querySelector('.lang-en');
  var teLink = document.querySelector('.lang-te');
  if (enLink) {
    enLink.href = buildUrl('en');
    if (lang === 'en') enLink.classList.add('lang-active');
  }
  if (teLink) {
    teLink.href = buildUrl('te');
    if (lang === 'te') teLink.classList.add('lang-active');
  }
})();

(function () {
  var editor = document.getElementById('editor');
  var highlightCode = document.getElementById('highlight-code');
  var highlightPre = highlightCode && highlightCode.parentElement;
  var completionList = document.getElementById('completion-list');
  var runBtn = document.getElementById('run-btn');
  var clearBtn = document.getElementById('clear-btn');
  var runOutput = document.getElementById('run-output');

  var COMPLETIONS = [
    { label: '@', detail: 'variable (immutable)', insert: '@' },
    { label: '@!', detail: 'mutable variable', insert: '@!' },
    { label: '#', detail: 'function', insert: '#' },
    { label: '#prarambham()', detail: 'entry point', insert: '#prarambham() {\n    \n}' },
    { label: '#dhimpu', detail: 'import', insert: '#dhimpu("")' },
    { label: 'okavela', detail: 'if', insert: 'okavela  {\n    \n}' },
    { label: 'lekapothe', detail: 'else', insert: 'lekapothe {\n    \n}' },
    { label: 'lekapothe okavela', detail: 'else if', insert: 'lekapothe okavela  {\n    \n}' },
    { label: 'malli', detail: 'for loop', insert: 'malli () {\n    \n}' },
    { label: 'mallinchu', detail: 'return', insert: 'mallinchu ' },
    { label: 'agu', detail: 'break', insert: 'agu' },
    { label: 'konasagu', detail: 'continue', insert: 'konasagu' },
    { label: 'nirmanam', detail: 'struct', insert: 'nirmanam  {\n    \n}' },
    { label: 'jatha', detail: 'map type', insert: 'jatha[]' },
    { label: 'varasa', detail: 'for map iteration', insert: 'varasa ' },
    { label: 'sunyam', detail: 'nil', insert: 'sunyam' },
    { label: 'int', detail: 'type', insert: 'int' },
    { label: 'float', detail: 'type', insert: 'float' },
    { label: 'string', detail: 'type', insert: 'string' },
    { label: 'bool', detail: 'type', insert: 'bool' },
    { label: 'fmt.Printf', detail: 'print formatted', insert: 'fmt.Printf("")' },
    { label: 'fmt.Sprintf', detail: 'format string', insert: 'fmt.Sprintf("")' },
    { label: 'strings.Contains', detail: 'substring check', insert: 'strings.Contains(, "")' },
    { label: 'strings.HasPrefix', detail: 'prefix check', insert: 'strings.HasPrefix(, "")' },
    { label: 'len', detail: 'length', insert: 'len()' },
    { label: 'append', detail: 'append to slice', insert: 'append(, )' }
  ];

  function escapeHtml(s) {
    var div = document.createElement('div');
    div.textContent = s;
    return div.innerHTML;
  }

  function updateHighlight() {
    if (!highlightCode || !editor) return;
    var text = editor.value || '\n';
    highlightCode.textContent = text;
    if (typeof Prism !== 'undefined' && Prism.languages.tlang) {
      Prism.highlightElement(highlightCode);
    }
  }

  function syncScroll() {
    if (highlightPre && editor) {
      highlightPre.scrollTop = editor.scrollTop;
      highlightPre.scrollLeft = editor.scrollLeft;
    }
  }

  editor.addEventListener('input', updateHighlight);
  editor.addEventListener('scroll', syncScroll);
  editor.addEventListener('input', syncScroll);

  updateHighlight();

  function getCaretCoordinates(el) {
    var div = document.createElement('div');
    var style = div.style;
    var computed = window.getComputedStyle(el);
    ['fontFamily', 'fontSize', 'fontWeight', 'lineHeight', 'padding', 'border', 'boxSizing'].forEach(function (k) {
      style[k] = computed[k];
    });
    style.position = 'absolute';
    style.visibility = 'hidden';
    style.whiteSpace = 'pre-wrap';
    style.wordWrap = 'break-word';
    style.width = el.offsetWidth + 'px';
    document.body.appendChild(div);
    var text = el.value.substring(0, el.selectionStart);
    div.textContent = text || '.';
    var span = document.createElement('span');
    span.textContent = '|';
    div.appendChild(span);
    var y = span.offsetTop;
    var x = span.offsetLeft;
    document.body.removeChild(div);
    return { x: x, y: y };
  }

  function getWordBeforeCaret() {
    var text = editor.value;
    var pos = editor.selectionStart;
    var start = pos;
    while (start > 0 && /[\w@#.]/.test(text[start - 1])) start--;
    return { word: text.slice(start, pos), start: start, end: pos };
  }

  var selectedIndex = 0;
  var currentWord = { word: '', start: 0, end: 0 };

  function showCompletions(prefix) {
    prefix = (prefix || '').toLowerCase();
    var filtered = COMPLETIONS.filter(function (c) {
      return c.label.toLowerCase().indexOf(prefix) === 0;
    });
    if (filtered.length === 0) {
      completionList.hidden = true;
      return;
    }
    selectedIndex = 0;
    completionList.innerHTML = '';
    filtered.forEach(function (c, i) {
      var item = document.createElement('div');
      item.className = 'completion-item' + (i === 0 ? ' selected' : '');
      item.setAttribute('role', 'option');
      item.innerHTML = '<span class="completion-label">' + escapeHtml(c.label) + '</span>' +
        (c.detail ? '<span class="completion-detail">' + escapeHtml(c.detail) + '</span>' : '');
      item.dataset.index = String(i);
      item.dataset.insert = c.insert || c.label;
      completionList.appendChild(item);
    });
    completionList.hidden = false;
    completionList.style.maxHeight = '200px';
  }

  function hideCompletions() {
    completionList.hidden = true;
  }

  function selectNext(down) {
    var items = completionList.querySelectorAll('.completion-item');
    if (items.length === 0) return;
    items[selectedIndex].classList.remove('selected');
    selectedIndex = down ? (selectedIndex + 1) % items.length : (selectedIndex - 1 + items.length) % items.length;
    items[selectedIndex].classList.add('selected');
    items[selectedIndex].scrollIntoView({ block: 'nearest' });
  }

  function insertCompletion(insertText) {
    var start = currentWord.start;
    var end = currentWord.end;
    var before = editor.value.substring(0, start);
    var after = editor.value.substring(end);
    editor.value = before + insertText + after;
    editor.selectionStart = editor.selectionEnd = start + insertText.length;
    editor.focus();
    updateHighlight();
    hideCompletions();
  }

  function acceptSelection() {
    var items = completionList.querySelectorAll('.completion-item');
    if (completionList.hidden || items.length === 0) return false;
    var item = items[selectedIndex];
    if (item && item.dataset.insert) insertCompletion(item.dataset.insert);
    return true;
  }

  editor.addEventListener('keydown', function (e) {
    if (!completionList.hidden) {
      if (e.key === 'ArrowDown') { e.preventDefault(); selectNext(true); return; }
      if (e.key === 'ArrowUp') { e.preventDefault(); selectNext(false); return; }
      if (e.key === 'Tab' || e.key === 'Enter') { e.preventDefault(); acceptSelection(); return; }
      if (e.key === 'Escape') { e.preventDefault(); hideCompletions(); return; }
    }
    if (e.key === ' ' && e.ctrlKey) {
      e.preventDefault();
      currentWord = getWordBeforeCaret();
      showCompletions(currentWord.word);
      return;
    }
  });

  editor.addEventListener('input', function () {
    currentWord = getWordBeforeCaret();
    if (currentWord.word.length >= 1) {
      showCompletions(currentWord.word);
    } else {
      hideCompletions();
    }
  });

  editor.addEventListener('click', hideCompletions);

  completionList.addEventListener('click', function (e) {
    var item = e.target.closest('.completion-item');
    if (item && item.dataset.insert) {
      selectedIndex = parseInt(item.dataset.index, 10);
      insertCompletion(item.dataset.insert);
    }
  });

  if (runBtn) {
    runBtn.addEventListener('click', function () {
      runOutput.hidden = false;
      runOutput.innerHTML = '<p>To run Tlang code, save the content as a <code>.tl</code> file and use:</p><pre><code>tlang run yourfile.tl</code></pre><p>Or compile to an executable: <code>tlang compile yourfile.tl output</code></p>';
    });
  }
  if (clearBtn) {
    clearBtn.addEventListener('click', function () {
      editor.value = '';
      updateHighlight();
      hideCompletions();
      if (runOutput) runOutput.hidden = true;
    });
  }
})();

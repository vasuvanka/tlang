/**
 * Prism.js language definition for Tlang
 */
(function () {
  if (typeof Prism === 'undefined') return;

  var keywords = /\b(okavela|lekapothe|malli|mallinchu|agu|konasagu|nirmanam|jatha|varasa|sunyam|emaina)\b/;

  Prism.languages.tlang = {
    comment: [
      { pattern: /\/\/.*/, alias: 'single' },
      { pattern: /\/\*[\s\S]*?\*\//, alias: 'multi' }
    ],
    string: [
      { pattern: /"(?:[^"\\]|\\.)*"/, greedy: true },
      { pattern: /'(?:[^'\\]|\\.)*'/, greedy: true },
      { pattern: /`[^`]*`/, greedy: true }
    ],
    number: /\b0x[\da-fA-F_]+\b|\b0[oO][0-7_]+\b|\b0[bB][01_]+\b|\b\d[\d_]*(?:\.\d[\d_]*)?(?:[eE][+-]?\d[\d_]*)?\b|\.\d[\d_]*(?:[eE][+-]?\d[\d_]*)?\b/,
    keyword: keywords,
    'hash-identifier': {
      pattern: /#(?:prarambham|dhimpu|[a-zA-Z_]\w*)/,
      alias: 'function'
    },
    'at-identifier': {
      pattern: /@!?[a-zA-Z_]\w*/,
      alias: 'variable'
    },
    type: /\b(?:int|float|string|bool|void|byte|rune|error)\b/,
    operator: /<-|:=|\?\||&&|\|\||[=!<>]=?|[+\-*\/%^]|\.\.\.?/,
    punctuation: /[{}[\];(),.:]/
  };
})();

// Generated by CoffeeScript 1.9.2
(function() {
  window.requestAnimationFrame = (function() {
    var candidate, i, len, ref, vendor;
    if (window.requestAnimationFrame) {
      return window.requestAnimationFrame;
    }
    ref = ['webkit', 'moz'];
    for (i = 0, len = ref.length; i < len; i++) {
      vendor = ref[i];
      candidate = window[vendor + "RequestAnimationFrame"];
      if (candidate != null) {
        return candidate;
      }
    }
  })();

  window.cancelAnimationFrame = (function() {
    var candidate, i, len, ref, vendor;
    if (window.cancelAnimationFrame) {
      return window.cancelAnimationFrame;
    }
    ref = ['webkit', 'moz'];
    for (i = 0, len = ref.length; i < len; i++) {
      vendor = ref[i];
      candidate = window[vendor + "CancelAnimationFrame"] || window[vendor + "CancelRequestAnimationFrame"];
      if (candidate != null) {
        return candidate;
      }
    }
  })();

  window.AudioContext = (function() {
    var candidateClass, i, len, ref, vendor;
    if (window.AudioContext) {
      return window.AudioContext;
    }
    ref = ['webkit', 'moz', 'o', 'ms'];
    for (i = 0, len = ref.length; i < len; i++) {
      vendor = ref[i];
      candidateClass = window[vendor + "AudioContext"];
      if (candidateClass != null) {
        return candidateClass;
      }
    }
    return console.log('The Web Audio API could not be initialized.');
  })();

}).call(this);

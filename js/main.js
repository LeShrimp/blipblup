// Generated by CoffeeScript 1.9.2
(function() {
  require.config({
    baseUrl: 'js/libs',
    paths: {
      jquery: 'jquery-2.1.3'
    }
  });

  requirejs(['jquery', 'underscore', 'sampler'], function($, _, Sampler) {
    Sampler.startRecording();
    return setTimeout((function() {
      Sampler.stopRecording();
      return Sampler.playSample(0);
    }), 5000);
  });

}).call(this);
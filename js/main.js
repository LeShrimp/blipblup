// Generated by CoffeeScript 1.9.2
(function() {
  require.config({
    baseUrl: 'js/libs',
    paths: {
      jquery: 'jquery-2.1.3'
    }
  });

  requirejs(['jquery', 'underscore', 'recorder', 'sequencer'], function($, _, Recorder, Sequencer) {
    var KEYCODE_SPACE, addControlsForBuffer, init, updateScheduleForSample;
    KEYCODE_SPACE = 32;
    init = function() {
      var $body;
      $body = $('body');
      $body.keydown(function(event) {
        switch (event.keyCode) {
          case KEYCODE_SPACE:
            return Recorder.startRecording();
        }
      });
      $body.keyup(function(event) {
        var buffer;
        switch (event.keyCode) {
          case KEYCODE_SPACE:
            buffer = Recorder.stopRecording();
            return addControlsForBuffer(buffer);
        }
      });
      if (!Sequencer.isRunning()) {
        return Sequencer.start();
      }
    };
    addControlsForBuffer = (function() {
      var counter;
      counter = 0;
      return function(buffer) {
        var $checkbox, $deleteSampleButton, $sampleNameInput, $sampleSequence, i, j, ref, sampleName;
        sampleName = "sample-" + (counter++);
        $sampleSequence = $("<div class=\"sample-sequence\" data-sample-name=\"" + sampleName + "\">");
        $sampleNameInput = $("<input type=\"text\" class=\"sample-name\" value=\"" + sampleName + "\"></input>");
        $sampleNameInput.change(function(event) {
          var newSampleName, oldSampleName;
          oldSampleName = $(event.target).parent().attr('data-sample-name');
          newSampleName = $(event.target).val();
          Sequencer.renameSample(oldSampleName, newSampleName);
          return $(event.target).parent().attr('data-sample-name', newSampleName);
        });
        $sampleSequence.append($sampleNameInput);
        for (i = j = 0, ref = Sequencer.CLOCKS_PER_MEASURE; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
          $checkbox = $("<input class=\"schedule-checkbox\" type=\"CHECKBOX\" data-clock-number=\"" + i + "\"></input>");
          $checkbox.change(function(event) {
            var name;
            name = $(event.target).parent().attr('data-sample-name');
            return updateScheduleForSample(name);
          });
          $sampleSequence.append($checkbox);
        }
        $deleteSampleButton = $("<i class=\"fa fa-trash-o delete-sample\"></i>");
        $deleteSampleButton.click(function(event) {
          return console.log("Yep");
        });
        $sampleSequence.append($deleteSampleButton);
        $('.samples-container').append($sampleSequence);
        return Sequencer.addSample(sampleName, buffer, (function() {
          var k, ref1, results;
          results = [];
          for (i = k = 0, ref1 = Sequencer.CLOCKS_PER_MEASURE; 0 <= ref1 ? k <= ref1 : k >= ref1; i = 0 <= ref1 ? ++k : --k) {
            results.push(0);
          }
          return results;
        })());
      };
    })();
    updateScheduleForSample = function(sampleName) {
      var $sequence, schedule;
      $sequence = $(".sample-sequence[data-sample-name='" + sampleName + "']");
      schedule = [];
      $sequence.children().each(function(i, element) {
        return schedule.push($(element).prop('checked') ? 1 : 0);
      });
      return Sequencer.setScheduleForSample(sampleName, schedule);
    };
    return Recorder.getUserPermission(function() {
      return init();
    });
  });

}).call(this);

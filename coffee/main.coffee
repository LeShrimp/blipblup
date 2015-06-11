require.config({
    baseUrl: 'js/libs',
    paths:
        jquery: 'jquery-2.1.3'
})

requirejs ['jquery', 'underscore', 'recorder', 'sequencer'], ($, _, Recorder, Sequencer) ->
    KEYCODE_SPACE = 32

    init = () ->
        $body = $('body')
        $body.keydown((event) ->
            switch event.keyCode
                when KEYCODE_SPACE 
                    Recorder.startRecording()
        )

        $body.keyup((event) ->
            switch event.keyCode
                when KEYCODE_SPACE
                    buffer = Recorder.stopRecording()
                    addControlsForBuffer(buffer)
        )

        Sequencer.setBeatListener((beatIndex) ->
            $checkboxWrapper = $('.schedule-checkbox-wrapper')
            #previousBeatIndex = (beatIndex + Sequencer.BEATS_PER_MEASURE - 1) % Sequencer.BEATS_PER_MEASURE

            while beatIndex < $checkboxWrapper.length
                $checkboxWrapper.eq(beatIndex-1).removeClass('is-playing')
                $checkboxWrapper.eq(beatIndex).addClass('is-playing')
                beatIndex += Sequencer.BEATS_PER_MEASURE
        )

        if not Sequencer.isRunning()
            Sequencer.start()

    addControlsForBuffer = do () ->
        counter = 0
        (buffer) ->
            sampleName = "sample-#{counter++}"
            $sampleSequence = $("<div class=\"sample-sequence\" data-sample-name=\"#{sampleName}\">")

            # Add textbox to name sample
            $sampleNameInput = $("<input type=\"text\" class=\"sample-name\" value=\"#{sampleName}\" tabindex=\"#{counter}\"></input>")
            $sampleNameInput.change((event) ->
                oldSampleName = $(event.target).parent().attr('data-sample-name')
                newSampleName = $(event.target).val()

                Sequencer.renameSample(oldSampleName, newSampleName)
                $(event.target).parent().attr('data-sample-name', newSampleName)
            )
            $sampleSequence.append($sampleNameInput)

            # Add checkbox for each beat
            for i in [0...Sequencer.BEATS_PER_MEASURE]
                $checkbox = $("<input class=\"schedule-checkbox\" type=\"CHECKBOX\" data-clock-number=\"#{i}\"></input>")
                $checkbox.change((event) ->
                    name = $(event.target).parents('.sample-sequence').attr('data-sample-name')
                    updateScheduleForSample(name)
                )
                $sampleSequence.append($checkbox.wrap('<span class="schedule-checkbox-wrapper"></span>').parent())

            # Add possibility to change volume
            $gainRange = $("<input type=\"range\"></input>")
            $gainRange.change((event) ->
                Sequencer.setGainForSample(sampleName, $(this).val()/100)
            )
            $sampleSequence.append($gainRange)

            # Add button for deletion of sample
            $deleteSampleButton = $("<i class=\"fa fa-trash-o delete-sample\"></i>")
            $deleteSampleButton.click((event) ->
                Sequencer.removeSample(sampleName)
                $(".sample-sequence[data-sample-name='#{sampleName}']").remove()
            )
            $sampleSequence.append($deleteSampleButton)

            $('.samples-container').append($sampleSequence)

            Sequencer.addSample(sampleName, buffer, (0 for i in [0...Sequencer.BEATS_PER_MEASURE]))

    updateScheduleForSample = (sampleName) ->
        $sequence = $(".sample-sequence[data-sample-name='#{sampleName}']")
        schedule = []

        $sequence.find('.schedule-checkbox').each((i, element) ->
            schedule.push(if $(element).prop('checked') then 1 else 0)
        )

        Sequencer.setScheduleForSample(sampleName, schedule)

    Recorder.getUserPermission(() ->
        init()
    )

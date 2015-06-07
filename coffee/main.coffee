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

        if not Sequencer.isRunning()
            Sequencer.start()

    addControlsForBuffer = do () ->
        counter = 0
        (buffer) ->
            sampleName = "sample-#{counter++}"
            $sampleSequence = $("<div class=\"sample-sequence #{sampleName}\">")

            for i in [0..Sequencer.CLOCKS_PER_MEASURE]
                $checkbox = $("<input type=\"CHECKBOX\" data-clock-number=\"#{i}\"></input>")
                $checkbox.change(() ->
                    updateScheduleForSample(sampleName)
                )
                $sampleSequence.append($checkbox)

            $('.samples-container').append($sampleSequence)

            Sequencer.addSample(sampleName, buffer, (0 for i in [0..Sequencer.CLOCKS_PER_MEASURE]))

    updateScheduleForSample = (sampleName) ->
        $sequence = $(".sample-sequence.#{sampleName}")
        schedule = []

        $sequence.children().each((i, element) ->
            schedule.push(if $(element).prop('checked') then 1 else 0)
        )

        Sequencer.setScheduleForSample(sampleName, schedule)

    Recorder.getUserPermission(() ->
        init()
    )

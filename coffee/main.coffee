require.config({
    baseUrl: 'js/libs',
    paths:
        jquery: 'jquery-2.1.3'
})

requirejs ['jquery', 'underscore', 'recorder', 'sequencer'], ($, _, Recorder, Sequencer) ->

    Recorder.getUserPermission(() ->
        Recorder.startRecording()
        console.log('Recording...')

        setTimeout(
            (() ->
                buffer = Recorder.stopRecording()
                console.log('Stopped Recording...')

                Sequencer.addSample('record1', buffer, [1,0,1,0,0,0,1,0])
                Sequencer.start()
            ),
            500
        )
    )

require.config({
    baseUrl: 'js/libs',
    paths:
        jquery: 'jquery-2.1.3'
})

requirejs ['jquery', 'underscore', 'recorder'], ($, _, Recorder) ->
    Recorder.getUserPermission(() ->
        Recorder.startRecording()
        console.log('Recording...')

        setTimeout(
            (() ->
                buffers = Recorder.stopRecording()
                console.log('Stopped Recording...')

                ctx = new window.AudioContext()
                source = ctx.createBufferSource()
                source.connect(ctx.destination)

                b = ctx.createBuffer(2, buffers[0].length, 44100)
                b.getChannelData(0).set(buffers[0], 0)

                source.buffer = b

                source.start(0)

            ),
            5000
        )
    )

require.config({
    baseUrl: 'js/libs',
    paths:
        jquery: 'jquery-2.1.3'
})

requirejs ['jquery', 'underscore', 'sampler'], ($, _, Sampler) ->
    Sampler.startRecording()

    setTimeout(
        (() ->
            Sampler.stopRecording()
            Sampler.playSample(0)
        ),
        5000
    )


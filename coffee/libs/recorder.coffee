define [], () ->
    BUFFER_LEN = 4096
    NUM_CHANNELS = 2

    isRecording = false
    isRecordingPossible = false

    recBuffers = null
    recLength = 0

    processorNode = null

    audioCtx = new window.AudioContext()

    initNewRecording = () ->
        recBuffers = ([] for i in [0...NUM_CHANNELS])
        recLength = 0

    initRecorderAudioGraph = (stream) ->
        input = audioCtx.createMediaStreamSource(stream)
        processorNode = audioCtx.createScriptProcessor(BUFFER_LEN, NUM_CHANNELS, NUM_CHANNELS)

        processorNode.onaudioprocess = (e) ->
            if (isRecording)
                buffer = []
                for channel in [0...NUM_CHANNELS]
                    recBuffers[channel].push(
                        new Float32Array(e.inputBuffer.getChannelData(channel))
                    )
                recLength += e.inputBuffer.getChannelData(0).length

        input.connect(processorNode)
        processorNode.connect(audioCtx.destination)

    flatten = (buffers, bufferLength) ->
        resBuffer = new Float32Array(bufferLength)
        offset = 0
        for b in buffers
            resBuffer.set(b, offset)
            offset += b.length

        return resBuffer

    getBuffers = () ->
        buffers = []
        for channel in [0...NUM_CHANNELS]
            buffers.push(flatten(recBuffers[channel], recLength))

        return buffers

    initNewRecording()

    Recorder =
        getUserPermission: (onSuccess) ->
            window.navigator.getUserMedia(
                {audio: true},
                ((stream) ->
                    isRecordingPossible = true
                    initRecorderAudioGraph(stream)
                    onSuccess()
                ),
                ((e) ->
                    console.log('Could not execute navigator.getUserMedia: ' + e)
                    isRecordingPossible = false
                )
            )

        startRecording: () ->
            if not isRecordingPossible
                return false

            isRecording = true
            return true

        stopRecording: () ->
            if not isRecordingPossible
                return false

            isRecording = false

            buffers = getBuffers()
            initNewRecording()

            return buffers

        isReady: () ->
            return isRecordingPossible

    return Recorder


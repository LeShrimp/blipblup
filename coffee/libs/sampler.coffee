define ['underscore'], (_) ->
    audioContext = new window.AudioContext()
    audioContext.createScriptProcessor = audioContext.createScriptProcessor || audioContext.webkitCreateScriptProcessor

    isRecording = false

    leftChannel = null
    rightChannel = null
    recordingLength = 0

    #Audio nodes
    micSource = null
    recorder = null

    samples = []

    do ->
        window.navigator.getUserMedia(
            {audio: true},
            ((stream) ->
                bufferSize = 2048
                micSource = audioContext.createMediaStreamSource(stream)
                recorder = audioContext.createScriptProcessor(bufferSize, 2, 2)
                recorder.onaudioprocess = (e) ->
                    if isRecording
                        left = e.inputBuffer.getChannelData(0)
                        right = e.inputBuffer.getChannelData(1)
                        leftChannel.push(new Float32Array(left))
                        rightChannel.push(new Float32Array(right))
                        recordingLength += bufferSize
            ),
            () ->
        )

    Sampler =
        startRecording: () ->
            leftChannel = []
            rightChannel = []
            recordingLength = 0
            isRecording = true

        stopRecording: () ->
            flatten = (channelData, bufferSize) ->
                result = new Float32Array(bufferSize)
                offset = 0
                for buffer in channelData
                    result.set(buffer, offset)
                    offset += buffer.length

                return result

            interleave = (left, right) ->
                result = new Float32Array(left.length + right.length)
                inputIndex = 0
                i = 0

                while i < result.length
                    result[i++] = left[inputIndex]
                    result[i++] = right[inputIndex]
                    inputIndex++

                return result

            isRecording = false

            #flatten buffers
            left = flatten(leftChannel, recordingLength)
            right = flatten(rightChannel, recordingLength)

            total = interleave(left, right)

            audioContext.decodeAudioData(
                left,
                ((buf) ->
                    samples.push(buf)
                ),
                () ->
            )

        playSample: (id) ->
            # Create nodes
            source = audioContext.createBufferSource()
            destination = audioContext.destination

            source.buffer = samples[id]

            source.connect(destination)

    return Sampler


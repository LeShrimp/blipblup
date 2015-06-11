define ['underscore'], (_) ->
    BEATS_PER_MEASURE = 16
    MEASURE_DURATION = 4             # in seconds
    BEAT_DURATION = MEASURE_DURATION / BEATS_PER_MEASURE

    audioContext = new window.AudioContext()

    isRunning = false
    samples = {}

    customBeatListener = null
    beatListener = (beatIndex, beatTime) ->
        # Schedule next beat
        nextBeatTime = beatTime + BEAT_DURATION
        nextBeatIndex = (beatIndex + 1) % BEATS_PER_MEASURE

        for own name, sample of samples
            if sample.schedule[nextBeatIndex] == 1
                node = audioContext.createBufferSource()
                node.buffer = sample.buffer

                node.connect(sample.destination)

                node.start(nextBeatTime)

        if customBeatListener?
            customBeatListener(beatIndex)


    doScheduling = do () ->
        nextMeasureStart = audioContext.currentTime + MEASURE_DURATION
        () ->
            currentTime = audioContext.currentTime

            if (currentTime + MEASURE_DURATION <= nextMeasureStart)
                return

            beatTimes = ((nextMeasureStart + i * BEAT_DURATION) for i in [0...BEATS_PER_MEASURE])

            for beatTime, beatIndex in beatTimes
                do (beatIndex, beatTime) ->
                    setTimeout(
                        () -> beatListener(beatIndex, beatTime)
                        (beatTime - currentTime) * 1000
                    )

            nextMeasureStart += MEASURE_DURATION



    Sequencer =
        addSample: (sampleName, buffer, schedule = null) ->
            if (schedule == null)
                schedule = (0 for _ in [0...BEATS_PER_MEASURE])

            # This is
            destination = audioContext.createGain()
            destination.gain.value = 0.5
            destination.connect(audioContext.destination)

            samples[sampleName] = {
                buffer: buffer
                schedule: schedule
                destination: destination
            }

        removeSample: (sampleName) ->
            delete samples[sampleName]

        renameSample: (oldSampleName, newSampleName) ->
            samples[newSampleName] = samples[oldSampleName]
            delete samples[oldSampleName]

        setScheduleForSample: (sampleName, schedule) ->
            samples[sampleName].schedule = schedule

        setGainForSample: (sampleName, gainValue) ->
            samples[sampleName].destination.gain.value = gainValue

        setBeatListener: (listener) ->
            customBeatListener = listener

        start: () ->
            setInterval(doScheduling, MEASURE_DURATION * 1000/2)
            isRunning = true

        isRunning: () ->
            return isRunning

        # Export constants
        BEAT_DURATION: BEAT_DURATION
        BEATS_PER_MEASURE: BEATS_PER_MEASURE

    return Sequencer


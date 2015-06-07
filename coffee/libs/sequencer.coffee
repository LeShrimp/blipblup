define ['underscore'], (_) ->
    CLOCKS_PER_MEASURE = 8
    MEASURE_LENGTH = 5             # in seconds
    CLOCK_LENGTH = MEASURE_LENGTH / CLOCKS_PER_MEASURE

    audioContext = new window.AudioContext()

    samples = {}

    doScheduling = do () ->
        nextMeasureStart = audioContext.currentTime + MEASURE_LENGTH
        () ->
            currentTime = audioContext.currentTime

            if (currentTime + MEASURE_LENGTH <= nextMeasureStart)
                return

            for own name, sample of samples
                for isNote, i in sample.schedule
                    if isNote == 1
                        node = audioContext.createBufferSource()
                        node.buffer = sample.buffer

                        node.connect(audioContext.destination)

                        node.start(nextMeasureStart + i * CLOCK_LENGTH)

            nextMeasureStart += MEASURE_LENGTH

    Sequencer =
        addSample: (sampleName, buffer, schedule = null) ->
            if (schedule == null)
                schedule = (0 for _ in [0..CLOCKS_PER_MEASURE])

            samples[sampleName] = {
                buffer: buffer
                schedule: schedule
            }

        setScheduleForSample: (sampleName, schedule) ->
            samples[sampleName].schedule = schedule

        start: () ->
            setInterval(doScheduling, MEASURE_LENGTH * 1000/4)

    return Sequencer


#Get the correct requestAnimationFrame-method
window.requestAnimationFrame = do ->
    if window.requestAnimationFrame
        return window.requestAnimationFrame

    for vendor in ['webkit', 'moz']
        candidate = window["#{vendor}RequestAnimationFrame"]
        return candidate if candidate?


window.cancelAnimationFrame = do ->
    if window.cancelAnimationFrame
        return window.cancelAnimationFrame

    for vendor in ['webkit', 'moz']
        candidate = window["#{vendor}CancelAnimationFrame"] || window["#{vendor}CancelRequestAnimationFrame"]
        return candidate if candidate?

window.AudioContext = do ->
    if window.AudioContext
        return window.AudioContext

    for vendor in ['webkit', 'moz', 'o', 'ms']
        candidateClass = window["#{vendor}AudioContext"]
        return candidateClass if candidateClass?

    console.log('The Web Audio API could not be initialized.')

window.navigator.getUserMedia = do ->
    if window.navigator.mediaDevices?.getUserMedia?
        return window.navigator.mediaDevices.getUserMedia

    for vendor in ['webkit', 'moz', 'o', 'ms']
        candidateClass = window.navigator["#{vendor}GetUserMedia"]
        return candidateClass if candidateClass?


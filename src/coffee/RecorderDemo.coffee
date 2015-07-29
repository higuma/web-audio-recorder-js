# navigator.getUserMedia shim
navigator.getUserMedia =
  navigator.getUserMedia ||
  navigator.webkitGetUserMedia ||
  navigator.mozGetUserMedia ||
  navigator.msGetUserMedia

# URL shim
URL = window.URL || window.webkitURL

# audio context + .createScriptProcessor shim
audioContext = new AudioContext
unless audioContext.createScriptProcessor?
  audioContext.createScriptProcessor = audioContext.createJavaScriptNode

# elements (jQuery objects)
$testToneLevel = $ '#test-tone-level'
$microphone = $ '#microphone'
$microphoneLevel = $ '#microphone-level'
$timeLimit = $ '#time-limit'
$encoding = $ 'input[name="encoding"]'
$encodingOption = $ '#encoding-option'
$encodingProcess = $ 'input[name="encoding-process"]'
$reportInterval = $ '#report-interval'
$bufferSize = $ '#buffer-size'
$recording = $ '#recording'
$timeDisplay = $ '#time-display'
$record = $ '#record'
$cancel = $ '#cancel'
$dateTime = $ '#date-time'
$recordingList = $ '#recording-list'
$modalLoading = $ '#modal-loading'
$modalProgress = $ '#modal-progress'
$modalError = $ '#modal-error'

# initialize input element states (required for reloading page on Firefox)
$testToneLevel.attr 'disabled', false
$testToneLevel[0].valueAsNumber = 0
$microphone.attr 'disabled', false
$microphone[0].checked = false
$microphoneLevel.attr 'disabled', false
$microphoneLevel[0].valueAsNumber = 0
$timeLimit.attr 'disabled', false
$timeLimit[0].valueAsNumber = 3
$encoding.attr 'disabled', false
$encoding[0].checked = true
$encodingProcess.attr 'disabled', false
$encodingProcess[0].checked = true
$reportInterval.attr 'disabled', false
$reportInterval[0].valueAsNumber = 1
$bufferSize.attr 'disabled', false
# ($bufferSize[0].valueAsNumber is initialized later)

# test tone (440Hz sine with 2Hz on/off beep)
testTone = do ->
  osc = audioContext.createOscillator()
  lfo = audioContext.createOscillator()
  lfo.type = 'square'
  lfo.frequency.value = 2
  oscMod = audioContext.createGain()
  osc.connect oscMod
  lfo.connect oscMod.gain
  output = audioContext.createGain()
  output.gain.value = 0.5
  oscMod.connect output
  osc.start()
  lfo.start()
  output

# source input mixer
testToneLevel = audioContext.createGain()
testToneLevel.gain.value = 0
testTone.connect testToneLevel
microphoneLevel = audioContext.createGain()
microphoneLevel.gain.value = 0
mixer = audioContext.createGain()
testToneLevel.connect mixer
microphone = undefined          # obtained by user click
microphoneLevel.connect mixer
mixer.connect audioContext.destination

# audio recorder object (+ encoding setting implementation)
audioRecorder = new WebAudioRecorder mixer,
  workerDir: 'js/'
  onEncoderLoading: (recorder, encoding) ->
    $modalLoading
      .find('.modal-title')
      .html "Loading #{encoding.toUpperCase()} encoder ..."
    $modalLoading.modal 'show'
    return

audioRecorder.onEncoderLoaded = ->
  $modalLoading.modal 'hide'
  return

# (other event handlers are defined later)

# mixer level
$testToneLevel.on 'input', ->
  level = $testToneLevel[0].valueAsNumber / 100
  testToneLevel.gain.value = level * level
  return

$microphoneLevel.on 'input', ->
  level = $microphoneLevel[0].valueAsNumber / 100
  microphoneLevel.gain.value = level * level
  return

# obtaining microphone input
$microphone.click ->
  unless microphone?
    navigator.getUserMedia(
      { audio: true },
      (stream) ->
        microphone = audioContext.createMediaStreamSource stream
        microphone.connect microphoneLevel
        $microphone.attr 'disabled', true
        $microphoneLevel.removeClass 'hidden'
      (error) ->
        $microphone[0].checked = false
        window.alert "Could not get audio input."
    )
  return

# recording time limit
plural = (n) -> if n > 1 then 's' else ''

$timeLimit.on 'input', ->
  min = $timeLimit[0].valueAsNumber
  $('#time-limit-text').html "#{min} minute#{plural min}"
  return

# encoding selector + encoding options
OGG_QUALITY = [-0.1, 0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
OGG_KBPS    = [  45,  64,  80,  96, 112, 128, 160, 192, 224, 256, 320, 500]

MP3_BIT_RATE = [64, 80, 96, 112, 128, 160, 192, 224, 256, 320]

ENCODING_OPTION =
  wav:
    label: ''
    hidden: true
    max: 1
    text: (val) -> ''
  ogg:
    label: 'Quality'
    hidden: false
    max: OGG_QUALITY.length - 1
    text: (val) -> "#{OGG_QUALITY[val].toFixed 1} (~#{OGG_KBPS[val]}kbps)"
  mp3:
    label: 'Bit rate'
    hidden: false
    max: MP3_BIT_RATE.length - 1
    text: (val) -> "#{MP3_BIT_RATE[val]}kbps"

optionValue =
  wav: null
  ogg: 6
  mp3: 5

$encoding.click (event) ->
  encoding = $(event.target).attr 'encoding'
  audioRecorder.setEncoding encoding
  option = ENCODING_OPTION[encoding]
  $('#encoding-option-label').html option.label
  $('#encoding-option-text').html option.text(optionValue[encoding])
  $encodingOption
    .toggleClass 'hidden', option.hidden
    .attr 'max', option.max
  $encodingOption[0].valueAsNumber = optionValue[encoding]
  return

$encodingOption.on 'input', ->
  encoding = audioRecorder.encoding
  option = ENCODING_OPTION[encoding]
  optionValue[encoding] = $encodingOption[0].valueAsNumber
  $('#encoding-option-text').html option.text(optionValue[encoding])
  return

# encoding process selector
encodingProcess = 'background'  # background | separate

$encodingProcess.click (event) ->
  encodingProcess = $(event.target).attr 'mode'
  hidden = encodingProcess == 'background'
  $('#report-interval-label').toggleClass 'hidden', hidden
  $reportInterval.toggleClass 'hidden', hidden
  $('#report-interval-text').toggleClass 'hidden', hidden
  return

$reportInterval.on 'input', ->
  sec = $reportInterval[0].valueAsNumber
  $('#report-interval-text').html "#{sec} second#{plural sec}"
  return

# detect browser default buffer size
defaultBufSz = do ->
  processor = audioContext.createScriptProcessor(undefined, 2, 2)
  processor.bufferSize

# processor buffer size
BUFFER_SIZE = [256, 512, 1024, 2048, 4096, 8192, 16384]

iDefBufSz = BUFFER_SIZE.indexOf defaultBufSz

updateBufferSizeText = ->
  iBufSz = $bufferSize[0].valueAsNumber
  text = "#{BUFFER_SIZE[iBufSz]}"
  text += ' (browser default)' if iBufSz == iDefBufSz
  $('#buffer-size-text').html text
  return

$bufferSize.on 'input', updateBufferSizeText

$bufferSize[0].valueAsNumber = iDefBufSz    # initialize with browser default
updateBufferSizeText()                      # initialize text

# save/delete recording
saveRecording = (blob, enc) ->
  time = new Date()
  url = URL.createObjectURL blob
  html = "<p recording='#{url}'>" +
    "<audio controls src='#{url}'></audio> " +
    "(#{enc}) #{time.toString()} " +
    "<a class='btn btn-default' href='#{url}' download='recording.#{enc}'>" +
    "Save..." +
    "</a> " +
    "<button class='btn btn-danger' recording='#{url}'>Delete</button>"
    "</p>"
  $recordingList.prepend $(html)
  return

$recordingList.on 'click', 'button', (event) ->
  url = $(event.target).attr 'recording'
  $("p[recording='#{url}']").remove()
  URL.revokeObjectURL url
  return

# time indicator
minSecStr = (n) -> (if n < 10 then "0" else "") + n

updateDateTime = ->
  $dateTime.html((new Date).toString())
  sec = audioRecorder.recordingTime() | 0
  $timeDisplay.html "#{minSecStr sec / 60 | 0}:#{minSecStr sec % 60}"
  return

window.setInterval updateDateTime, 200

# encoding progress report modal
progressComplete = false

setProgress = (progress) ->
  percent = "#{(progress * 100).toFixed 1}%"
  $modalProgress
    .find '.progress-bar'
    .attr 'style', "width: #{percent};"
  $modalProgress
    .find '.text-center'
    .html percent
  progressComplete = progress == 1
  return

$modalProgress.on "hide.bs.modal", ->
  audioRecorder.cancelEncoding() if !progressComplete
  return

# record | stop | cancel buttons
disableControlsOnRecord = (disabled) ->
  unless microphone?
    $microphone.attr 'disabled', disabled
  $timeLimit.attr 'disabled', disabled
  $encoding.attr 'disabled', disabled
  $encodingOption.attr 'disabled', disabled
  $encodingProcess.attr 'disabled', disabled
  $reportInterval.attr 'disabled', disabled
  $bufferSize.attr 'disabled', disabled
  return

startRecording = ->
  $recording.removeClass 'hidden'
  $record.html 'STOP'
  $cancel.removeClass 'hidden'
  disableControlsOnRecord true
  audioRecorder.setOptions
    timeLimit: $timeLimit[0].valueAsNumber * 60
    encodeAfterRecord: encodingProcess == 'separate'
    progressInterval: $reportInterval[0].valueAsNumber * 1000
    ogg:
      quality: OGG_QUALITY[optionValue.ogg]
    mp3:
      bitRate: MP3_BIT_RATE[optionValue.mp3]
  audioRecorder.startRecording()
  setProgress 0
  return

stopRecording = (finish) ->
  $recording.addClass 'hidden'
  $record.html 'RECORD'
  $cancel.addClass 'hidden'
  disableControlsOnRecord false
  if finish
    audioRecorder.finishRecording()
    if audioRecorder.options.encodeAfterRecord
      $modalProgress
        .find('.modal-title')
        .html "Encoding #{audioRecorder.encoding.toUpperCase()}"
      $modalProgress.modal 'show'
  else
    audioRecorder.cancelRecording()
  return

$record.click ->
  if audioRecorder.isRecording()
    stopRecording true
  else
    startRecording()
  return

$cancel.click ->
  stopRecording false
  return

# event handlers
audioRecorder.onTimeout = (recorder) ->
  stopRecording true
  return

audioRecorder.onEncodingProgress = (recorder, progress) ->
  setProgress progress
  return

audioRecorder.onComplete = (recorder, blob) ->
  $modalProgress.modal 'hide' if recorder.options.encodeAfterRecord
  saveRecording blob, recorder.encoding
  return

audioRecorder.onError = (recorder, message) ->
  $modalError.find('.alert').html message
  $modalError.modal 'show'
  return

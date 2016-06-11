# WebAudioRecorder.js

## What is it?

WebAudioRecorder.js is a JavaScript library that records audio input (Web Audio API AudioNode object) and encodes to audio file image (Blob object). It supports three encoding formats.

* Waveform Audio (.wav)
* Ogg Vorbis (.ogg)
* MP3 (MPEG-1 Audio Layer III) (.mp3)

> This library uses following encoder libraries as lower layer.
> 
> * WavAudioEncoder.js: <https://github.com/higuma/wav-audio-encoder-js>
> * OggVorbisEncoder.js: <https://github.com/higuma/ogg-vorbis-encoder-js>
> * Mp3LameEncoder.js: <https://github.com/higuma/mp3-lame-encoder-js>

## Demo

Microphone recorder demo.

<https://higuma.github.io/web-audio-recorder-js/>

## Library files

Library consists of one main script and several worker scripts.

`lib/` contains uncompressed library files.

* `WebAudioRecorder.js`: main script
* `WebAudioRecorderWav.js`: worker for Waveform Audio encoder
* `WebAudioRecorderOgg.js`: worker for Ogg Vorbis encoder
* `WebAudioRecorderMp3.js`: worker for MP3 encoder
* `WavAudioEncoder.min.js`: Waveform Audio encoder (from [WavAudioEncoder.js](https://github.com/higuma/wav-audio-encoder-js))
* `OggVorbisEncoder.min.js`: Ogg Vorbis encoder (from [OggVorbisEncoder.js](https://github.com/higuma/ogg-vorbis-encoder-js))
* `Mp3LameEncoder.min.js`: MP3 encoder (from [Mp3LameEncoder.js](https://github.com/higuma/mp3-lame-encoder-js))
* `OggVorbisEncoder.min.js.mem`: memory initializer for Ogg Vorbis encoder (must be located on the same directory)
* `Mp3LameEncoder.min.js.mem`: memory initializer for MP3 encoder (must be located on the same directory)

`lib-minified/` contains minified library files.

* `WebAudioRecorder.min.js`: main script (minified)
* `WebAudioRecorderWav.min.js`: worker for Waveform Audio (concatenated with encoder and recompressed)
* `WebAudioRecorderOgg.min.js`: worker for Ogg Vorbis (concatenated with encoder and recompressed)
* `WebAudioRecorderMp3.min.js`: worker for MP3 (concatenated with encoder and recompressed)
* `OggVorbisEncoder.min.js.mem`: memory initializer for Ogg Vorbis encoder (same file as above)
* `Mp3LameEncoder.min.js.mem`: memory initializer for MP3 encoder (same file as avove)

### Using library

Load main script from HTML first.

``` html
<script src="javascripts/WebAudioRecorder.js"></script>
```

Worker files are loaded on creating an audio recorder object (or changing encoding by `setEncoding()`). You must set worker directory on object constructor (see API reference for detail).

``` javascript
audioRecorder = new WebAudioRecorder(sourceNode, {
  workerDir: "javascripts/"     // must end with slash
});
```

## API

### Constructor

``` javascript
recorder = new WebAudioRecorder(sourceNode, configs)
```

Create an audio recorder object.

* Parameters
    * `sourceNode`: source input (AudioNode object)
    * `configs`: configuration object
        * `.workerDir`: worker files directory (default = `"/"`)
        * `.numChannels`: number of channels (default = `2` (stereo))
        * `.encoding`: encoding (default = `"wav"`, see `.setEncoding()` for detail)
        * `.options`: options (see `.setOptions()` for detail)
        * you can also set event handlers (see "Event handlers" for detail)
* Returns
    * audio recorder object

Every configuration property has a default value (typically you ought to set only `.workerDir` and `.encoding`). You can change encoding by `.setEncoding()` and options by `.setOptions()` after construction.

If you use MP3 encoding, you cannot change `.numChannels` from default (current MP3 encoder supports 2-channel stereo only).

> In fact, `configs` is just deep-copied into the recorder object itself.

### Methods

``` javascript
recorder.setEncoding(encoding)
```

Change encoding after construction.

* Parameters
    * `.encoding`: encoding
        * `"wav"`: Waveform Audio (default)
        * `"ogg"`: Ogg Vorbis
        * `"mp3"`: MP3
* Returns
    * (none)

You can change encoding when recording is not running. If the method is called during recording, `.onError()` event is fired.

``` javascript
recorder.setOptions(options)
```

Set options.

* Parameters
    * `options`: options object
        * `.timeLimit`: recording time limit (second) (default = `300`)
        * `.encodeAfterRecord`: encoding process mode
            * `false`: process encoding on recording background (default)
            * `true`: process encoding after recording is finished
        * `.progressInterval`: encoding progress report interval (millisecond) (default = `1000`)
            * (used only if `.encodeAfterRecord` is `true`)
        * `.bufferSize`: recording buffer size (default = `undefined` (use browser default))
        * `.wav.mimeType`: Waveform Audio MIME type (default = `"audio/wav"`)
        * `.ogg.mimeType`: Ogg Vorbis MIME type (default = `"audio/ogg"`)
        * `.ogg.quality`: Ogg Vorbis quality (-0.1 .. 1) (default = `0.5`)
        * `.mp3.mimeType`: MP3 MIME type (default = `"audio/mpeg"`)
        * `.mp3.bitRate`: MP3 bit rate (typically 64 .. 320 for 44100Hz) (default = `160`)
* Returns
    * (none)

You can set options when recording is not running. If the method is called during recording, `.onError()` event is fired.

``` javascript
recorder.startRecording()
```

Start recording.

* Parameters
    * (none)
* Returns
    * (none)

If `.encoderAfterRecord` options is `false` (default), encoding process is performed on recording background.

If `.encoderAfterRecord` is `true`, audio data is just stored to worker's buffer. Encoding process is performed after recording is finished.

``` javascript
recorder.isRecording()
```

Return if recording is running.

* Parameters
    * (none)
* Returns
    * `false`: recording is not running
    * `true`: recording is running

``` javascript
recordingTime = recorder.recordingTime()
```

Report recording time.

* Parameters
    * (none)
* Returns
    * recording time (second) or `null` (not recording)

``` javascript
recorder.cancelRecording()
```

Cancel current recording without saving.

* Parameters
    * (none)
* Returns
    * (none)

``` javascript
recorder.finishRecording()
```

Finish current recording.

* Parameters
    * (none)
* Returns
    * (none)

If `.encoderAfterRecord` options is `false` (default), it finishes encoding and make a Blob object immediately. You get a Blob with `.onComplete()` event.

If `.encoderAfterRecord` is `true`, it starts encoding process. Encoding process may take several seconds to a few minutes (depending on recording time).  You can get encoding progress with `onEncodingProgress()` event. Getting a Blob is same as above.

``` javascript
recorder.cancelEncoding()
```

Cancel encoding.

* Parameters
    * (none)
* Returns
    * (none)

This method is used when `.encoderAfterRecord` is `true` and worker is processing encoding after `.finishRecording()`. You can interrupt worker's encoding process and do cleanup.

> Internally, it calls `worker.terminate()` to kill worker process and makes another worker.

### Event handlers

Encoder worker's responses are processed by event handlers. Some other breakpoints are also provided as events. Events summary is as below (first parameter is always recorder object).

``` javascript
recorder.onEncoderLoading = function(recorder, encoding) { ... }
recorder.onEncoderLoaded = function(recorder, encoding) { ... }
recorder.onTimeout = function(recorder) { ... }
recorder.onEncodingProgress = function (recorder, progress) { ... }
recorder.onEncodingCanceled = function(recorder) { ... }
recorder.onComplete = function(recorder, blob) { ... }
recorder.onError = function(recorder, message) { ... }
```

You can set an event handler to object property.

``` javascript
recorder = new WebAudioRecorder(source, { workerDir: "javascripts/" });
recorder.onComplete = function(rec, blob) {
  // use Blob
};
```

You can also set event handlers from constructor parameter.

``` javascript
recorder = new WebAudioRecorder(source, {
  workerDir: "javascripts/",
  onEncoderLoading: function(recorder, encoding) {
    // show "loading encoder..." display
  },
  onEncoderLoaded: function(recorder, encoding) {
    // hide "loading encoder..." display
  }
});
```

### Event reference

``` javascript
recorder.onEncoderLoading = function(recorder, encoding) { ... }
```

* Fired on
    * recorder is going to load an encoder worker (on construction or changing encoding)
* Parameters
    * `recorder`: audio recorder object
    * `encoding`: encoding
* Default handler
    * empty function

It is the only event to be fired during construction process. To catch the first event correctly, it should be set from constructor parameter (see above example).

``` javascript
recorder.onEncoderLoaded = function(recorder, encoding) { ... }
```

* Fired on
    * encoder worker has finished loading
* Parameters
    * `recorder`: audio recorder object
    * `encoding`: encoding
* Default handler
    * empty function

``` javascript
recorder.onTimeout = function(recorder) { ... }
```

* Fired on
    * recording time exceeds timeout limit
* Parameters
    * `recorder`: audio recorder object
* Default handler
    * call `recorder.finishRecording()`.

``` javascript
recorder.onEncodingProgress = function (recorder, progress) { ... }
```

* Fired on
    * worker reports encoding progress (when `.encodeAfterRecord` is `true`)
* Parameters
    * `recorder`: audio recorder object
    * `progress`: progress (from `0` to `1`)
* Default handler
    * empty function

``` javascript
recorder.onEncodingCanceled = function(recorder) { ... }
```

* Fired on
    * `.cancelRecording()` is called
* Parameters
    * `recorder`: audio recorder object
* Default handler
    * empty function

``` javascript
recorder.onComplete = function(recorder, blob) { ... }
```

* Fired on
    * worker completes encoding to Blob
* Parameters
    * `recorder`: audio recorder object
    * `blob`: Blob object
* Default handler
    * warn `"You must override onComplete event"` by `recorder.onError()`

This is the most important event. You must override to get the result.

``` javascript
recorder.onError = function(recorder, message) { ... }
```

* Fired on
    * error
* Parameters
    * `recorder`: audio recorder object
    * `message`: error message
* Default handler
    * show message by `console.log(message)`

## License

Ogg Vorbis encoder part of the library uses JavaScript-converted code of [libogg](https://xiph.org/ogg/) and [libvorbis](https://xiph.org/vorbis/). They are released under Xiph's BSD-like license. Ogg Vorbis encoder part of this library follows the same license (see link below).

<http://www.xiph.org/licenses/bsd/>

MP3 encoder part of this library uses JavaScript-converted code of [LAME](http://lame.sourceforge.net/). LAME is licensed under the LGPL. MP3 encoder part of this library follows the same license (see link below). 

<http://lame.sourceforge.net/about.php>

All other parts are released under MIT license (see [LICENSE.txt](LICENSE.txt)).

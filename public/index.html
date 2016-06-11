<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>WebAudioRecorder.js demo</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
  </head>
  <body>
    <div class="container">
      <h1><a href="https://github.com/higuma/web-audio-recorder-js">WebAudioRecorder.js</a> demo</h1>
      <p>Audio recording to WAV / OGG / MP3 with Web Audio API</p>
      <hr>
      <div class="form-horizontal">
        <div class="form-group">
          <label class="col-sm-3 control-label">Audio input</label>
          <div class="col-sm-3">
            <select id="audio-in-select" class="form-control"></select>
          </div>
          <div class="col-sm-3">
            <input id="audio-in-level" type="range" min="0" max="100" value="0" class="hidden">
          </div>
        </div>
        <div class="form-group">
          <div class="col-sm-3"></div>
          <div class="col-sm-3">
            <input id="echo-cancellation" type="checkbox"> Enable echo cancellation
          </div>
          <div class="col-sm-6 text-warning"><strong>Experimental:</strong> cancellation on/off may work on Chrome only.</div>
        </div>
        <div class="form-group">
          <label class="col-sm-3 control-label">Test tone</label>
          <div class="col-sm-3"></div>
          <div class="col-sm-3">
            <input id="test-tone-level" type="range" min="0" max="100" value="0">
          </div>
        </div><br>
        <div class="form-group">
          <label class="col-sm-3 control-label">Recording time limit</label>
          <div class="col-sm-3">
            <input id="time-limit" type="range" min="1" max="10" value="3">
          </div>
          <div id="time-limit-text" class="col-sm-6">3 minutes</div>
        </div><br>
        <div class="form-group">
          <label class="col-sm-3 control-label">Encoding</label>
          <div class="col-sm-3">
            <input type="radio" name="encoding" encoding="wav" checked> .wav &nbsp; 
            <input type="radio" name="encoding" encoding="ogg"> .ogg &nbsp; 
            <input type="radio" name="encoding" encoding="mp3"> .mp3
          </div>
          <label id="encoding-option-label" class="col-sm-2 control-label"></label>
          <div class="col-sm-2">
            <input id="encoding-option" type="range" min="0" max="11" value="6" class="hidden">
          </div>
          <div id="encoding-option-text" class="col-sm-2"></div>
        </div><br>
        <div class="form-group">
          <label class="col-sm-3 control-label">Encoding process</label>
          <div class="col-sm-9">
            <input type="radio" name="encoding-process" mode="background" checked> Encode on recording background
          </div>
        </div>
        <div class="form-group">
          <div class="col-sm-3"></div>
          <div class="col-sm-3">
            <input type="radio" name="encoding-process" mode="separate"> Encode after recording (safer)
          </div>
          <label id="report-interval-label" class="col-sm-2 control-label hidden">Reports every</label>
          <div class="col-sm-2">
            <input id="report-interval" type="range" min="1" max="5" value="1" class="hidden">
          </div>
          <div id="report-interval-text" class="col-sm-2 hidden">1 second</div>
        </div><br>
        <div class="form-group">
          <label class="col-sm-3 control-label">Recording buffer size</label>
          <div class="col-sm-2">
            <input id="buffer-size" type="range" min="0" max="6">
          </div>
          <div id="buffer-size-text" class="col-sm-7"></div>
        </div>
        <div class="form-group">
          <div class="col-sm-3"></div>
          <div class="col-sm-9 text-warning"><strong>Notice: </strong> recording becomes unstable if buffer size is below browser default.</div>
        </div><br>
        <div class="form-group">
          <div class="col-sm-3 control-label"><span id="recording" class="text-danger hidden"><strong>RECORDING</strong></span>&nbsp; <span id="time-display">00:00</span></div>
          <div class="col-sm-3">
            <button id="record" class="btn btn-danger">RECORD</button>
            <button id="cancel" class="btn btn-default hidden">CANCEL</button>
          </div>
          <div class="col-sm-6"><span id="date-time" class="text-info"></span></div>
        </div>
      </div>
      <hr>
      <h3>Recordings</h3>
      <div id="recording-list"></div>
    </div>
    <div id="modal-loading" class="modal fade">
      <div class="modal-dialog modal-sm">
        <div class="modal-content">
          <div class="modal-header">
            <h4 class="modal-title"></h4>
          </div>
        </div>
      </div>
    </div>
    <div id="modal-progress" class="modal fade">
      <div class="modal-dialog modal-sm">
        <div class="modal-content">
          <div class="modal-header">
            <h4 class="modal-title"></h4>
          </div>
          <div class="modal-body">
            <div class="progress">
              <div style="width: 0%;" class="progress-bar"></div>
            </div>
            <div class="text-center">0%</div>
          </div>
          <div class="modal-footer">
            <button type="button" data-dismiss="modal" class="btn">Cancel</button>
          </div>
        </div>
      </div>
    </div>
    <div id="modal-error" class="modal fade">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" data-dismiss="modal" class="close">&times;</button>
            <h4 class="modal-title">Error</h4>
          </div>
          <div class="modal-body">
            <div class="alert alert-warning"></div>
          </div>
          <div class="modal-footer">
            <button type="button" data-dismiss="modal" class="btn btn-primary">Close</button>
          </div>
        </div>
      </div>
    </div>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
    <script src="js/WebAudioRecorder.min.js"></script>
    <script src="js/RecorderDemo.js"></script>
  </body>
</html>
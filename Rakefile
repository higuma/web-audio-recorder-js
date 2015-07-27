require 'fileutils'

TEMPFILE = '__TEMPFILE__'

def merge_encoder_worker(encoder, worker, output)
  sh "sed /importScripts/d #{worker} > #{TEMPFILE}"
  sh "uglifyjs -m sort #{encoder} #{TEMPFILE} > #{output}"
end

def modify_and_minify(source, output)
  sh "sed s/\.js'/.min.js'/ #{source} > #{TEMPFILE}"
  sh "uglifyjs -m sort #{TEMPFILE} > #{output}"
end

task :build_minified do
  FileUtils.makedirs 'lib-minified'
  merge_encoder_worker 'lib/WavAudioEncoder.min.js',
                       'lib/WebAudioRecorderWav.js',
                       'lib-minified/WebAudioRecorderWav.min.js'
  merge_encoder_worker 'lib/Mp3LameEncoder.min.js',
                       'lib/WebAudioRecorderMp3.js',
                       'lib-minified/WebAudioRecorderMp3.min.js'
  merge_encoder_worker 'lib/OggVorbisEncoder.min.js',
                       'lib/WebAudioRecorderOgg.js',
                       'lib-minified/WebAudioRecorderOgg.min.js'
  modify_and_minify 'lib/WebAudioRecorder.js',
                    'lib-minified/WebAudioRecorder.min.js'
  sh 'cp lib/*.mem lib-minified'
  sh "rm -f #{TEMPFILE}"
end

task :clean_minified do
  sh 'rm -rf lib-minified'
end

task default: :build_minified

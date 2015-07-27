# (disable beep on Windows)
_write = process.stdout.write
process.stdout.write = (msg) -> _write.call @, msg.replace('\x07', '')

module.exports = (grunt) ->
  'use strict'

  grunt.util.linefeed = '\n'

  grunt.initConfig
    clean:
      server: ['server.js']
      html: ['public/index.html']
      js: ['public/js/*']
    jade:
      options:
        pretty: true
      compile:
        files:
          'public/index.html': 'src/jade/index.jade'
    coffee:
      server:
        src: 'src/server.coffee'
        dest: 'server.js'
      compile:
        expand: true
        cwd: 'src/coffee'
        src: ['*.coffee']
        dest: 'public/js/'
        ext: '.js'
        extDot: 'last'
    copy:
      files:
        expand: true
        cwd: 'src/js'
        src: ['*']
        dest: 'public/js/'
    watch:
      options:
        reload: true
      jade:
        tasks: 'jade'
        files: ['src/jade/*.jade']
      coffee:
        tasks: 'coffee'
        files: ['src/coffee/*.coffee']
      copy:
        tasks: 'copy'
        files: ['src/js/*.js']

  npms = 'clean jade coffee copy watch'.split ' '
  grunt.loadNpmTasks "grunt-contrib-#{npm}" for npm in npms

  grunt.registerTask 'default', 'jade coffee copy'.split(' ')

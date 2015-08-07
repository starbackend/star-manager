# Load all required libraries.
gulp = require 'gulp'
gls = require 'gulp-live-server'
jade = require 'gulp-jade'
coffee = require 'gulp-coffee'
less = require 'gulp-less'
sourcemaps = require 'gulp-sourcemaps'
config = require './config'

exts = (ext) -> ['./public/**/*.' + ext, '!./public/libs/**/*']
  
paths = 
  jade: exts 'jade' 
  coffee: exts 'coffee' 
  less: exts 'less'

gulp.task 'jade', ()->
  gulp.src paths.jade
    .pipe jade 
      pretty: true
    .pipe gulp.dest config.generated
    
gulp.task 'coffee', ()->
  gulp.src paths.coffee
    #.pipe sourcemaps.init()
    .pipe coffee()
    #.pipe sourcemaps.write()
    .pipe gulp.dest config.generated  
  
  
gulp.task 'less', ()->
  gulp.src paths.less
    .pipe sourcemaps.init()
    .pipe less()
    .pipe sourcemaps.write()
    .pipe gulp.dest config.generated 
    
gulp.task 'watch', () ->
  gulp.watch paths.jade, ['jade']
  gulp.watch paths.coffee, ['coffee']
  gulp.watch paths.less, ['less']
  
gulp.task 'generate', ['jade', 'coffee', 'less'], ->

gulp.task 'serve', ['watch', 'generate'], ()->
  server = gls 'app.js', {}, false
  server.start()
  
gulp.task 'default', ['generate']
  
    
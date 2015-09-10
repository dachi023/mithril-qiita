gulp        = require 'gulp'
browserify  = require 'browserify'
coffee      = require 'gulp-coffee'
uglify      = require 'gulp-uglify'
sourcemaps  = require 'gulp-sourcemaps'
buffer      = require 'vinyl-buffer'
source      = require 'vinyl-source-stream'

gulp.task 'default', ['build']

gulp.task 'build', ['compile', 'compress'], ->
  gulp.src './src/**/*'
  .pipe coffee()
  .pipe gulp.dest './lib'

b = ->
  browserify
    entries: './src/index.coffee'
    extensions: ['.coffee', '.js']
    transform: ['coffeeify']
    debug: true

gulp.task 'compile', ->
  b()
  .bundle()
  .pipe source 'mithril-qiita.js'
  .pipe gulp.dest './dist'

gulp.task 'compress', ->
  b()
  .bundle()
  .pipe source 'mithril-qiita.min.js'
  .pipe buffer()
  .pipe sourcemaps.init {loadMaps: true}
    .pipe uglify {preserveComments: 'some'}
  .pipe sourcemaps.write './'
  .pipe gulp.dest './dist'

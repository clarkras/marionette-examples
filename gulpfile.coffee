gulp        = require 'gulp'
gutil       = require 'gulp-util'
coffee      = require 'gulp-coffee'
refresh     = require 'gulp-livereload'
clean       = require 'gulp-clean'
template    = require 'gulp-template-compile'
concat      = require 'gulp-concat'
lr_server   = require('tiny-lr')()

gulp.task 'coffee', ->
  gulp.src('./src/scripts/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./public/js/'))
    .pipe(refresh lr_server)
  return # without explicit return, watch task stops on coffeescript error

gulp.task 'spec', ->
  gulp.src('./spec/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./public/spec/'))
    .pipe(refresh lr_server)
  return

gulp.task 'template', ->
  gulp.src('./src/templates/**/*.html')
    .pipe(template())
    .pipe(concat('templates.js'))
    .pipe(gulp.dest('./public/js/'))
    .pipe(refresh lr_server)
  return

gulp.task 'html', ->
	gulp.src('./src/html/**/*.html')
		.pipe(refresh lr_server)

gulp.task 'livereload', ->
  lr_server.listen 35729, (err) ->
    console.log err if err?

gulp.task 'clean', ->
  gulp.src('public')
    .pipe(clean())

gulp.task 'watch', ->
  gulp.watch 'src/scripts/**/*.coffee', ['coffee']
  gulp.watch 'src/templates/**/*.html', ['template']
  gulp.watch 'src/html/*.html',         ['html']
  gulp.watch 'spec/**/*.coffee',        ['spec']

gulp.task 'default', ['livereload', 'clean', 'template', 'coffee', 'spec', 'watch']


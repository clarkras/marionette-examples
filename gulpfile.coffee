gulp = require 'gulp'
gutil = require 'gulp-util'
coffee = require 'gulp-coffee'
refresh = require 'gulp-livereload'
clean = require 'gulp-clean'
lr_server = require('tiny-lr')()

gulp.task 'coffee', ->
  stream = gulp.src('./scripts/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./public/'))
    .pipe(refresh lr_server)

gulp.task 'html', ->
	gulp.src('./html/*.html')
		.pipe(refresh lr_server)

gulp.task 'livereload', ->
  lr_server.listen 35729, (err) ->
    console.log err if err?

gulp.task 'clean', ->
  gulp.src('public')
  .pipe(clean())

gulp.task 'watch', ->
  gulp.watch 'scripts/**/*.coffee', ['coffee']
  gulp.watch 'html/*.html',         ['html']

gulp.task 'default', ['livereload', 'clean', 'coffee', 'watch']


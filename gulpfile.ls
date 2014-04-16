require! <[gulp gulp-concat gulp-livereload gulp-bower-files node-static tiny-lr]>
gutil             = require \gulp-util
livescript        = require \gulp-livescript
stylus            = require \gulp-stylus
jade              = require \gulp-jade
livereload-server = tiny-lr!
livereload        = -> gulp-livereload livereload-server

path =
  root:  './'
  build: './'

gulp.task \bower ->
  gulp-bower-files!
  .pipe gulp-concat 'vendor.js'
  .pipe gulp.dest "#{path.build}lib/"

gulp.task \js ->
  gulp.src 'src/ls/main.ls'
  .pipe gulp-concat 'main.ls'
  .pipe livescript!
  .pipe gulp.dest path.build
  .pipe livereload!

gulp.task \css ->
  gulp.src do
    * 'src/stylus/*.styl'
    ...
  .pipe gulp-concat 'style.styl'
  .pipe stylus use: <[nib]>
  .pipe gulp.dest path.build
  .pipe livereload!

gulp.task \html ->
  gulp.src 'src/*.jade'
  .pipe jade!
  .pipe gulp.dest path.build
  .pipe livereload!

gulp.task \build <[bower js css html]>

gulp.task \static (next) ->
  server = new node-static.Server path.root
  port = 8888
  require \http .createServer (req, res) !->
    req.addListener(\end -> server.serve req, res)resume!
  .listen port, !->
    gutil.log "Server listening on port: #{gutil.colors.magenta port}"
    next!

gulp.task \watch ->
  gulp.watch 'bower.json'         <[bower]>
  gulp.watch 'src/ls/*.ls'        <[js]>
  gulp.watch 'src/stylus/*.styl'  <[css]>
  gulp.watch 'src/*.jade'         <[html]>

gulp.task \livereload ->
  port = 35729
  livereload-server.listen port, ->
    return gulp.log it if it
    gutil.log "LiveReload listening on port: #{gutil.colors.magenta port}"

gulp.task \default <[build static watch livereload]>

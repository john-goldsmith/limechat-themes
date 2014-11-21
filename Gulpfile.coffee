gulp = require "gulp"
sass = require "gulp-ruby-sass"
watch = require "gulp-watch"
del = require "del"
minifycss = require "gulp-minify-css"
streamqueue = require "streamqueue"
flatten = require "gulp-flatten"

config =
  paths:
    styles: "src/**/*.sass"
    yamls: "src/**/*.yaml"
    images: "src/**/*.{png,jpg,gif}"

gulp.task "default", ->
  console.log "Default task not configured"

# Delete dist
gulp.task "clean", ->
  del "dist"

# Build dist
gulp.task "build", ["clean"], ->
  streamqueue(
    objectMode: true
  , gulp.src(config.paths.yamls), gulp.src(config.paths.styles).pipe(sass("sourcemap=none": true)) # See https://github.com/sindresorhus/gulp-ruby-sass/issues/156
  )
  .pipe gulp.dest "dist"

# Move to ~/Library/Application Support/LimeChat/Themes
gulp.task "install", ["clean", "build"], ->
  gulp.src "dist/**/*.{css,yaml}"
    .pipe flatten()
    .pipe gulp.dest "../../Library/Application Support/LimeChat/Themes"

# gulp.task "watch", ->
#   gulp.watch "src/**/*.{sass,yaml}", ["install"]
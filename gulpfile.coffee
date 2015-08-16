gulp = require "gulp"
plumber = require "gulp-plumber"
notify = require "gulp-notify"
runseq = require "run-sequence"
sass = require "gulp-sass"
autoprefixer = require "gulp-autoprefixer"
minify = require "gulp-minify-css"
rename = require "gulp-rename"
aigis = require "gulp-aigis"
bs = require "browser-sync"

src = [
  "src/**/*.scss"
]
dist = "./theme"
options = {}

AUTOPREFIXER_BROWSERS = [
    'ie >= 9',
    'ie_mob >= 10',
    'ff >= 30',
    'chrome >= 34',
    'safari >= 7',
    'opera >= 23',
    'ios >= 7',
    'android >= 4.0',
    'bb >= 10'
  ]

gulp.task "sass", ->
  gulp.src src
    .pipe do plumber
    .pipe sass(options)
    .pipe autoprefixer(AUTOPREFIXER_BROWSERS)
    .pipe gulp.dest(dist)

gulp.task "build", ->
  gulp.src src
    .pipe do plumber
    .pipe sass(options)
    .pipe autoprefixer(AUTOPREFIXER_BROWSERS)
    .pipe gulp.dest(dist)
    .pipe minify()
    .pipe rename (path) ->
      path.extname = ".min.css"
    .pipe gulp.dest(dist)

gulp.task "template", ->
  gulp.src "aigis_config.yml"
    .pipe(aigis())

gulp.task "serve", ["template"], ->
  bs.init(
    server:
      baseDir: ["./docs"]
      directory: true
    notify: false,
    host: "localhost"
  )

gulp.task "watch", ->
  gulp.watch src, ["sass"]

gulp.task "default", ["build"]

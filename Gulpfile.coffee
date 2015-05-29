gulp = require 'gulp'
concat = require 'gulp-concat'
rename = require 'gulp-rename'
replace = require 'gulp-replace'
clean = require 'gulp-clean'
runSequence = require 'gulp-run-sequence'
coffeelint = require 'gulp-coffeelint'
karma = require('karma').server
RewirePlugin = require 'rewire-webpack'
webpack = require 'gulp-webpack'
webpackSource = require 'webpack'
shell = require 'gulp-shell'
_ = require 'lodash'

karmaConf = require './karma.defaults'

config = require './package.json'

outFiles =
  scripts: 'bundle.js'

paths =
  scripts: ['./*.coffee', './src/*.coffee']
  tests: './tests/*/*.coffee'
  root: './www/exit.coffee'
  rootTests: './tests/index.coffee'
  dist: './dist'
  build:
    client: './www'
    tests: './build/tests'

gulp.task 'build', ['scripts']

gulp.task 'lint:scripts', ->
  gulp.src paths.scripts
    .pipe coffeelint()
    .pipe coffeelint.reporter()

gulp.task 'scripts', ->
  gulp.src paths.root
    .pipe webpack
      module:
        loaders: [
          { test: /\.coffee$/, loader: 'coffee' }
        ]
      plugins: [
        new webpackSource.optimize.UglifyJsPlugin()
      ]
      resolve:
        extensions: ['.coffee', '.js', '.json', '']
    .pipe rename outFiles.scripts
    .pipe gulp.dest paths.build.client


gulp.task 'scripts:test', ->
  gulp.src paths.rootTests
    .pipe webpack
      module:
        loaders: [
          { test: /\.coffee$/, loader: 'coffee' }
        ]
      plugins: [
        new RewirePlugin()
      ]
      resolve:
        extensions: ['.coffee', '.js', '.json', '']
        # browser-builtins is for modules requesting native node modules
        modulesDirectories: ['web_modules', 'node_modules', './src',
        './node_modules/browser-builtins/builtin']
    .pipe rename 'bundle.js'
    .pipe gulp.dest paths.build.tests


# run coffee-lint
gulp.task 'lint:tests', ->
  gulp.src paths.tests
    .pipe coffeelint()
    .pipe coffeelint.reporter()

gulp.task 'test', [
  'scripts:test'
  'lint:tests'
  'lint:scripts'
], (cb) ->
  karma.start _.defaults(singleRun: true, karmaConf), process.exit

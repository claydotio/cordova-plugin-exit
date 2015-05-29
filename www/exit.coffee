require './polyfill'

window.plugins ?= {}

exec = window.cordova.exec

class Exit
  exitWithoutAnimation: ->
    exec \
      null,
      null,
      'Exit',
      'exitWithoutAnimation',
      []

window.plugins.exit = new Exit()

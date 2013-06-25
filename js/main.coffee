require.config
  paths:
    jquery: 'lib/jquery-2.0.2'
    underscore: 'lib/underscore-1.4.4'
    backbone: 'lib/backbone-1.0.0'
    localstorage: "lib/backbone.localStorage"
    order: 'lib/order'
    text: 'lib/text'
    bootstrap: 'lib/bootstrap'

  shim:
    underscore:
      exports: "_"
    backbone:
      deps: ["underscore", "jquery"]
      exports: "Backbone"

require [
  'jquery'
  'backbone'
  'models/clockmodel'
  'views/clockview'
  'views/settingsview'
  'views/tasksview'
], ($, Backbone, ClockModel, ClockView, SettingsView, TasksView) ->

  class Router extends Backbone.Router
    constructor: (model, args) ->
      super args
      @model = model

    routes:
      '': 'home'
      'tagged/:tag': 'tag'

    home: ->
      console.log 'home'
      @model.set 'tag', null

    tag: (tag) ->
      console.log 'tag'
      @model.set 'tag', tag

  $(document).ready ->
    clockModel = new ClockModel id: 'clock'
    window.router = new Router(clockModel)
    Backbone.history.start()# pushState: true


    clockView = new ClockView
      el: $('#clock')
      model: clockModel
      scale: .8
      sync: true

    #subClockView = new ClockView(
    # el: '#clock .sub-clock'
    # model: clockModel
    # scale: .2
    # sync: false
    #)
    
    settingsView = new SettingsView
      el: '#settings'
      model: clockModel

    tasksView = new TasksView
      el: '#tasks'
      model: clockModel

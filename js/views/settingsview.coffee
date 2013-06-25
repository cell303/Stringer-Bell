define [
  'jquery'
  'underscore'
  'backbone'
  'text!templates/settings.html'
], ($, _, Backbone, settingsTemplate) ->

  # This view represents the settings and sets them on the model
  # Therefore, it is more of a controller than a view
  class SettingsView extends Backbone.View
    
    # Binds methods and renders the content.
    initialize: ->
      $(window).bind('resize', @resize)
      @render()

    # The pre-compiled underscore template for the settings.
    template: _.template(settingsTemplate)

    # Redraws the settings content,
    # initializes the jQuery Mobile widgets and 
    # adjusts the size.
    render: =>
      @$el.html(@template(@model.toJSON()))

    # Binds methods to events that occur within this view.
    events: ->
      'change #slider-0': @setWorkTime
      'change #slider-1': @setFreeTime
      'click #button-0': @allowNotifications
      'click #stop': @stopClock
      'click #prev': @prev
      'click #next': @next
      'change #flip-a': @toggleSound

    toggleSound: (event) =>
      @model.set('sound': !@model.get('sound'))

    # Passes the new value to the model.
    setWorkTime: =>
      val = parseInt($('#slider-0').val())
      @$el.find('.work-time').text(val)
      @model.setWorkTime(val)

    # Passes the new value to the model.
    setFreeTime: =>
      val = parseInt($('#slider-1').val())
      @$el.find('.free-time').text(val)
      @model.setFreeTime(val)

    # Asks the user to allow desktop notifications.
    allowNotifications: =>
      window.webkitNotifications.requestPermission()

    stopClock: =>
      @model.stopClock()

    prev: ->
      if @model.get("isBreak")
        @model.resetToFreetime()
      else
        @model.resetToWorktime()

    next: ->
      @model.newTask()

      if @model.get("isBreak")
        @model.resetToWorktime()
      else
        @model.resetToFreetime()

  return SettingsView

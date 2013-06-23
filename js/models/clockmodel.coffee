# @fileOverview A simple alarm clock (bell) that tells you when it's time to 
# take a break.
# @author <a href="https://www.twitter.com/cell303">@cell303</a>
# @version 1

define([
  'underscore'
  'backbone'
  'collections/taskscollection'
  'models/taskmodel'
  'libs/backbone.localstorage'
], (_, Backbone, TasksCollection, TaskModel, Store) ->

  # Implements the logic of a stop watch.
  class ClockModel extends Backbone.Model

    # These default values should match those in the template.
    defaults:
      syncSecond: 0
      syncMinute: 0
      syncHour: 0
      unsyncSecond: 0
      unsyncMinute: 0
      unsyncHour: 0
      internalSecond: 0
      internalMinute: 0
      internalHour: 0
      workTime: 18
      freeTime: 2
      isBreak: false
      sound: true

    # Sets initial values and starts the interval.
    initialize: =>
      @fetch()
      @startClock()
      @checkSupport()

      @startDate = new Date().getTime()

      @tasks = new TasksCollection
      @tasks.fetch()
      @tasks.sort()

    # Updates the values of the clock.
    # This function has to be called every 1 sec.
    # When the limit for the current period is reached it will notify the user.
    updateClock: =>
      syncSecond = @get('syncSecond')
      syncMinute = @get('syncMinute')
      syncHour = @get('syncHour')
      unsyncSecond = @get('unsyncSecond')
      unsyncMinute = @get('unsyncMinute')
      unsyncHour = @get('unsyncHour')
      
      syncSecond++
      if syncSecond >= 60
        syncMinute++
        if syncMinute >= 60
          syncHour++

      unsyncSecond++
      if unsyncSecond >= 60
        unsyncMinute++
        if unsyncMinute >= 60
          unsyncHour++

      @sec++
      if @sec >= 60
        @sec = 0
        @min++
        if @min >= 60
          @hour++

      @set(
        'syncSecond': syncSecond % 60
        'syncMinute': syncMinute % 60
        'syncHour': syncHour % 12
        'unsyncSecond': unsyncSecond % 60
        'unsyncMinute': unsyncMinute % 60
        'unsyncHour': unsyncHour % 12
        'internalSecond': @sec
        'internalMinute': @min
        'internalHour': @hour
      )
      
      limit = if @get('isBreak') then @get('freeTime') else @get('workTime')

      if @min >= limit
        @notifyUser()
        @set('isBreak': !@get('isBreak'))
        @min = 0

    # Notifies the user that a time slice has been completed.
    # Currently only chrome/html5 notifications are supproted.
    notifyUser: =>
      if @canShowNotifications
        if window.webkitNotifications.checkPermission() is 0
          if @get('isBreak')
            notification = window.webkitNotifications.createNotification '/images/icon128.png', 'Your break is over!', ''
          else
            notification = window.webkitNotifications.createNotification '/images/icon128.png', 'Time to take a break!', ''

            task = new TaskModel 
              isBreak: @get('isBreak') 
              startDate: @startDate
              date: new Date().getTime()
              edit: true

            task.save()
            @tasks.add task

          @startDate = new Date().getTime()

          notification.show()
          setTimeout ->
            notification.cancel()
          , 10000

      if not @get('isBreak') and @get('sound')
        if @canPlayMp3 or @canPlayOgg
          document.getElementById('bell').load()
          document.getElementById('bell').play()

    # Checks if the browser supports html5 stuff...
    checkSupport: ->
      myAudio = document.createElement('audio')
      if (myAudio.canPlayType)
        #Currently canPlayType(type) returns: "", "maybe" or "probably" 
        @canPlayMp3 = !!myAudio.canPlayType and myAudio.canPlayType('audio/mpeg') isnt ''
        @canPlayOgg = !!myAudio.canPlayType and myAudio.canPlayType('audio/ogg; codecs="vorbis"') isnt ''

      @canShowNotifications = (window.webkitNotifications)

    # Setter method.
    # Will reset the clock if the new value is smaller then 
    # the time that already passed in the current time slice.
    # @param {number} value The new value.
    setWorkTime: (value) ->
      if @get('isBreak') is false and @min > value
        @continue()
      @set('workTime': value)
      @save()

    # Setter method.
    # Will reset the clock if the new value is smaller then 
    # the time that already passed in the current time slice.
    # @param {number} value The new value.
    setFreeTime: (value) ->
      if @get('isBreak') is true and @min > value
        @continue()
      @set('freeTime': value)
      @save()

    # Resets the clock.
    # Also toggles the mode to cause a redraw of the slices.
    continue: () ->
      @min = @sec = @hour = 0
      @trigger('reset')

    # Resets the clock by clearing the interval and begins with a new 
    # work timeslice.
    resetToWorktime: () ->
      @stopClock()
      @startClock()
      @set('isBreak': false)
      @trigger('change:isBreak')

    # Resets the clock by clearing the interval and begins with a new 
    # break timeslice.
    resetToFreetime: =>
      @stopClock()
      @startClock()
      @set('isBreak': true)
      @trigger('change:isBreak')

    # Start the clock by assigning default values and then setting the interval.
    startClock: =>
      @sec = @min = @hour = 0
      currentDate = new Date()

      @set(
        'syncSecond': currentDate.getSeconds()
        'syncMinute': currentDate.getMinutes()
        'syncHour': currentDate.getHours() % 12
        'unsyncSecond': @sec
        'unsyncMinute': @min
        'unsyncHour': @hour
        'internalSecond': @sec
        'internalMinute': @min
        'internalHour': @hour
        'isBreak': false
      )

      @interval = setInterval(@updateClock, 1000)

    # Pauses the clock by clearing the interval.
    stopClock: =>
      if @interval? then clearInterval(@interval)

    tweet: (text) ->

    # Wrapper for the localStorage.
    localStorage: new Store('clock')

    # The function that Backbone calls every time it attempts to read or save a model 
    # to the server. Has been altered for this model to save to localStorage instead.
    # @param {string} method The CRUD method.
    # @param {Backbone.Model} model The model to be saved. Always this model.
    # @param {Object=} options jQuery.ajax request options
    sync: (method, model, options) ->

      store = @localStorage
      
      switch (method)
        when 'create'
          resp = store.create(model)
        when 'read'
          resp = if model.id? then store.find(model) else store.findAll()
        when 'update'
          resp = store.update(model)
        when 'delete'
          resp = store.destroy(model)

      if (resp)
        options.success(resp)
  
  return ClockModel
)

# @fileOverview A simple alarm clock (bell) that tells you when it's time to 
# take a break.
# @author <a href="https://www.twitter.com/cell303">@cell303</a>
# @version 1

define([
  'underscore'
  'backbone'
  'libs/backbone.localstorage'
], (_, Backbone, Store) ->

  class TaskModel extends Backbone.Model

    # These default values should match those in the template.
    defaults: ->
      isBreak: null
      date: null
      startDate: null
      text: ''
      edit: false

    # Sets initial values and starts the interval.
    #initialize: ->

    validate: (attrs, options) ->
      if attrs.text.length > 140
        return "can't end before it starts"

    localStorage: new Store('clock')

    sync: sync
  
  return TaskModel
)

define [
  'underscore'
  'backbone'
  'localstorage'
], (_, Backbone) ->

  class TaskModel extends Backbone.Model
    url: '/task'

    defaults: ->
      isBreak: null
      date: null
      startDate: null
      text: ''
      edit: false

    validate: (attrs, options) ->
      if attrs.text.length > 140
        return "can't end before it starts"

    localStorage: new Backbone.LocalStorage 'task'
  
  return TaskModel

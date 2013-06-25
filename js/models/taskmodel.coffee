define [
  'underscore'
  'backbone'
  'libs/backbone.localstorage'
], (_, Backbone, Store) ->

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

    localStorage: new Store 'task'

    sync: sync
  
  return TaskModel

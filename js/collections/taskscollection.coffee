# @fileOverview A simple alarm clock (bell) that tells you when it's time to 
# take a break.
# @author <a href="https://www.twitter.com/cell303">@cell303</a>
# @version 1

define [
  'underscore'
  'backbone'
  'models/taskmodel'
  'libs/backbone.localstorage'
], (_, Backbone, TaskModel, Store) ->

  # Implements the logic of a stop watch.
  class TasksCollection extends Backbone.Collection
    model: TaskModel

    url: '/tasks'

    comparator: (task) ->
      return -task.get('date')

    # Wrapper for the localStorage.
    localStorage: new Store('clock')

    # The function that Backbone calls every time it attempts to read or save a model 
    # to the server. Has been altered for this model to save to localStorage instead.
    # @param {string} method The CRUD method.
    # @param {Backbone.Model} model The model to be saved. Always this model.
    # @param {Object=} options jQuery.ajax request options
    sync: (method, model, options) ->
      console.log method, model, options

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

  return TasksCollection

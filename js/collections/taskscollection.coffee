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

    localStorage: new Store('clock')

    sync: sync

  return TasksCollection

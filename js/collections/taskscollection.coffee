define [
  'underscore'
  'backbone'
  'models/taskmodel'
  'libs/backbone.localstorage'
], (_, Backbone, TaskModel, Store) ->

  class TasksCollection extends Backbone.Collection
    url: '/task'

    model: TaskModel

    comparator: (task) ->
      return -task.get('date')

    localStorage: new Store 'task'

    sync: sync

  return TasksCollection

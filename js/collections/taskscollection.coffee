define [
  'underscore'
  'backbone'
  'models/taskmodel'
  'localstorage'
], (_, Backbone, TaskModel) ->

  class TasksCollection extends Backbone.Collection
    url: '/task'

    model: TaskModel

    comparator: (task) -> -task.get 'date'

    localStorage: new Backbone.LocalStorage 'task'

  return TasksCollection

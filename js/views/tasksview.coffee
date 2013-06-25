define [
  'jquery'
  'underscore'
  'backbone'
  'views/taskview'
  'text!templates/tasks.html'
], ($, _, Backbone, TaskView, tasksTemplate) ->

  class TasksView extends Backbone.View
    
    # Binds methods and renders the content.
    initialize: ->
      @render()
      #@model.bind 'change:workTime', @render
      #@model.bind 'change:isBreak', @render
      @model.tasks.bind 'add', @add

    # The pre-compiled underscore template for the settings.
    template: _.template(tasksTemplate)

    # Redraws the settings content,
    # initializes the jQuery Mobile widgets and 
    # adjusts the size.
    render: =>
      @$el.html(@template(@model.toJSON()))
      @model.tasks.each (task) =>
        view = new TaskView model: task
        @$el.find("#timeline").append(view.render().el)

    add: (task) =>
      view = new TaskView model: task
      @$el.find("#timeline").prepend(view.render().el)

  return TasksView

# @fileOverview A simple alarm clock (bell) that tells you when it's time to take a break.
# @author <a href="https://www.twitter.com/cell303">@cell303</a>
# @version 1

define([
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
      @model.bind('change:workTime', @render)
      @model.bind('change:isBreak', @render)
      @model.tasks.bind('add', @render)

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

  return TasksView
)

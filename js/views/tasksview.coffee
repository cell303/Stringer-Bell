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
      @model.on 'change:tag', @render
      @model.tasks.on 'add', @add

    # The pre-compiled underscore template for the settings.
    template: _.template(tasksTemplate)
    
    sum: 0

    #events: ->
    #  'click .tag': (e) => window.router.navigate "/tagged/" + $(e.currentTarget).data('tag'), true

    # Redraws the settings content,
    # initializes the jQuery Mobile widgets and 
    # adjusts the size.
    render: =>
      @$el.html(@template(@model.toJSON()))

      @sum = 0
      @model.tasks.each (task) =>
        if @model.get("tag")?
          tag = @model.get "tag"
          if task.attributes.tags? and _.contains(task.attributes.tags, tag)
            @sum += task.get "time"
            view = new TaskView model: task
            @$el.find("#timeline").append(view.render().el)
        else
            @sum += task.get "time"
            view = new TaskView model: task
            @$el.find("#timeline").append(view.render().el)

        @$el.find("#sum").text @sum

    add: (task) =>
      view = new TaskView model: task
      @$el.find("#timeline").prepend(view.render().el)
      @sum += task.get "time"
      @$el.find("#sum").text @sum

  return TasksView

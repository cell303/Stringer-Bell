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
    
    #tags: []
    sum: 0

    #events: ->
    #  'click .tag': (e) => window.router.navigate "/tagged/" + $(e.currentTarget).data('tag'), true

    # Redraws the settings content,
    # initializes the jQuery Mobile widgets and 
    # adjusts the size.
    render: =>
      newTask = (task) =>
        if !@prevTask or (new Date(@prevTask.get("date"))).getDate() isnt (new Date(task.get("date"))).getDate()
          @$el.find("#timeline").append '<p class="new-day">' + moment(task.get("date")).format("dddd, MMMM Do") + '</p>'

        @sum += task.get "time"
        @view = new TaskView model: task
        @$el.find("#timeline").append(@view.render().el)
        @prevTask = task

      @$el.html(@template(@model.toJSON()))

      @prevTask = null
      @tags = []
      @sum = 0
      @model.tasks.each (task) =>
        if @model.get("tag")?
          tag = @model.get "tag"
          if task.attributes.tags? and _.contains(task.attributes.tags, tag)
            newTask task
        else
            newTask task

        _.each task.get("tags"), (tag) => @tags.push(tag)

      @setSum()
      @setTags()

    add: (task) =>
      if @model.get("tag")? 
        task.set("text", "#"+@model.get("tag"))
        task.set("tags", [@model.get("tag")])

      @sum += task.get "time"
      if @$el.find("#timeline .new-day").length is 0 
        @$el.find("#timeline").append '<p class="new-day">' + moment(task.get("date")).format("dddd, MMMM Do") + '</p>'

      view = new TaskView model: task
      @$el.find("#timeline .new-day").first().after(view.render().el)

      if $(':focus').length is 0 then view.$el.find('textarea').focus()

      _.each task.get("tags"), (tag) => @tags.unshift(tag)

      @setSum()
      @setTags()

    setSum: ->
      if @sum > 60
        hours = Math.floor(@sum/60)
        minutes = @sum%60
        @$el.find("#sum").text hours+'h '+minutes
      else
        @$el.find("#sum").text @sum

    setTags: ->
      @tags = _.first _.unique(@tags), 10
      @$el.find("#tags").html('')
      _.each @tags, (tag) =>
        @$el.find("#tags").append '<a class="tag" href="#/tagged/'+tag+'" data-tag="'+tag+'">#'+tag+'</a> '


  return TasksView

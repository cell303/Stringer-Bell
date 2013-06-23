# @fileOverview A simple alarm clock (bell) that tells you when it's time to take a break.
# @author <a href="https://www.twitter.com/cell303">@cell303</a>
# @version 1

define [
  'jquery'
  'underscore'
  'backbone'
  'text!templates/task.html'
], ($, _, Backbone, template) ->

  class TaskView extends Backbone.View

    tagName: "li"

    className: "task"

    # The pre-compiled underscore template for the settings.
    template: _.template(template)
    
    # Binds methods and renders the content.
    initialize: ->
      @model.on 'change', @render
      @render()

    events: =>
      'click .save': @tweet
      'click .edit': => @model.save 'edit', true
      'click .cancel': => @model.save 'edit', false
      'keyup textarea': @update140

    render: =>
      diff = @model.get('date') - @model.get('startDate')
      diff = Math.round(diff / 60000)
      json = _.extend @model.toJSON(),
        time: diff
        #date: new Date(@model.get("date")).toString()

      @$el.html(@template(json))
      @$el.toggleClass 'break', @model.get('isBreak')
      @input = @$el.find('textarea')
      this

    tweet: ->
      @model.save 'text', @input.val()
      @model.save 'edit', false

    update140: ->
      @$el.find('.lead').text(140 - @input.val().length)

  return TaskView

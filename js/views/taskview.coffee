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
      'focus textarea': => @$el.addClass 'edit'
      'blur textarea': => @$el.removeClass 'edit'
      'keyup textarea': @update140

    render: =>
      diff = @model.get('date') - @model.get('startDate')
      diff = Math.round(diff / 60000)
      json = _.extend @model.toJSON(),
        time: diff
        date: moment(@model.get("date")).format("LLLL")

      @$el.html(@template(json))
      @$el.toggleClass 'break', @model.get('isBreak')
      @input = @$el.find('textarea')
      this

    tweet: ->
      @model.save 'text', @input.val()
      @model.save 'edit', false

    update140: (e) =>
      @$el.find('.chars').text(140 - @input.val().length)

      if e.keyCode is 13 and e.shiftKey isnt true
        @tweet()
        @$el.next().find('textarea').focus()

  return TaskView

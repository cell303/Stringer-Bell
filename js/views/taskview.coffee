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

    regexp: new RegExp("#([\\w]*)", "g")
    
    # Binds methods and renders the content.
    initialize: ->
      @model.on 'change', @render
      @render()

    events: =>
      'keypress textarea': @update140
      'dblclick *': => @model.set 'saved', false
      'focus textarea': => @$el.addClass 'edit'
      'blur textarea': => @$el.removeClass 'edit'

    render: =>
      text = @model.get "text"
      text = text.replace @regexp, '<a class="tag" href="#/tagged/$1" data-tag="$1">#$1</a>'

      json = _.extend @model.toJSON(),
        displayText: text
        date: moment(@model.get("date")).format("h:mm a")

      @$el.html(@template(json))
      @$el.toggleClass 'break', @model.get('isBreak')
      @input = @$el.find('textarea')
      @input.focus()
      this

    tweet: ->
      text = @input.val()
      tags = []

      while (myArray = @regexp.exec(text)) isnt null
        tags.push myArray[1]

      @model.save 
        text: text
        tags: tags
        saved: true

    update140: (e) =>
      @$el.find('.chars').text(140 - @input.val().length)

      if e.keyCode is 13 and e.shiftKey isnt true
        @tweet()
        @$el.next().find('textarea').focus()

  return TaskView

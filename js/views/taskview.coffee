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
      'focus textarea': => @$el.addClass 'edit'
      'blur textarea': => @$el.removeClass 'edit'
      'keyup textarea': @update140

    render: =>
      diff = @model.get('date') - @model.get('startDate')
      diff = Math.round(diff / 60000)

      text = @model.get "text"
      text = _.escape text
      text = text.replace @regexp, '<a class="tag" href="#/tagged/$1" data-tag="$1">#$1</a>'

      json = _.extend @model.toJSON(),
        text: text
        time: diff
        date: moment(@model.get("date")).format("LLLL")

      @$el.html(@template(json))
      @$el.toggleClass 'break', @model.get('isBreak')
      @input = @$el.find('textarea')
      this

    tweet: ->
      text = @input.val()
      tags = []

      while (myArray = @regexp.exec(text)) isnt null
        tags.push myArray[1]

      console.log tags

      @model.save 'text', text
      @model.save 'tags', tags

    update140: (e) =>
      @$el.find('.chars').text(140 - @input.val().length)

      if e.keyCode is 13 and e.shiftKey isnt true
        @tweet()
        @$el.next().find('textarea').focus()

  return TaskView

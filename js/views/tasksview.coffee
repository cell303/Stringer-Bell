# @fileOverview A simple alarm clock (bell) that tells you when it's time to take a break.
# @author <a href="https://www.twitter.com/cell303">@cell303</a>
# @version 1

define([
	'jquery'
	'underscore'
	'backbone'
	'text!templates/tasks.html'
], ($, _, Backbone, tasksTemplate) ->

	# This view represents the settings and sets them on the model
	# Therefore, it is more of a controller than a view
	class TasksView extends Backbone.View
		
		# Binds methods and renders the content.
		initialize: ->
			@render()

		# The pre-compiled underscore template for the settings.
		template: _.template(tasksTemplate)

		# Redraws the settings content,
		# initializes the jQuery Mobile widgets and 
		# adjusts the size.
		render: =>
			@$el.html(@template(@model.toJSON())).trigger('create')

	return TasksView
)

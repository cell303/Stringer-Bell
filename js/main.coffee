# @fileOverview A simple alarm clock (bell) that tells you when it's time to take a break.
# @author <a href="https://www.twitter.com/cell303">@cell303</a>
# @version 1

require.config(
	paths:
		jquery: 'http://code.jquery.com/jquery-1.7.1.min'
		jquerymobile: 'http://code.jquery.com/mobile/1.1.0-rc.1/jquery.mobile-1.1.0-rc.1.min'
		underscore: 'libs/underscore-min'
		backbone: 'libs/backbone-min'
		order: 'libs/order'
		text: 'libs/text'
)

require [
	'jquery'
	'models/clockmodel'
	'views/clockview'
	'views/settingsview'
	'views/tasksview'
], ($, ClockModel, ClockView, SettingsView, TasksView) ->

	clockModel = new ClockModel(id: 'clock')

	$('.ui-page').live('pageshow', (event, ui) ->
		clockView = new ClockView(
			el: $(event.target).find('#clock')
			model: clockModel
			scale: .8
			sync: true
		)

		#subClockView = new ClockView(
		#	el: '#clock .sub-clock'
		#	model: clockModel
		#	scale: .2
		#	sync: false
		#)
		
		settingsView = new SettingsView(
			el: '#settings'
			model: clockModel
		)

		#tasksView = new TasksView(
		#	el: '#tasks'
		#	model: clockModel
		#)
	)

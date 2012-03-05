(function() {

  require.config({
    paths: {
      jquery: 'http://code.jquery.com/jquery-1.7.1.min',
      jquerymobile: 'http://code.jquery.com/mobile/1.1.0-rc.1/jquery.mobile-1.1.0-rc.1.min',
      underscore: 'libs/underscore-min',
      backbone: 'libs/backbone-min',
      order: 'libs/order',
      text: 'libs/text'
    }
  });

  require(['jquery', 'models/clockmodel', 'views/clockview', 'views/settingsview', 'views/tasksview'], function($, ClockModel, ClockView, SettingsView, TasksView) {
    var clockModel;
    clockModel = new ClockModel({
      id: 'clock'
    });
    return $('.ui-page').live('pageshow', function(event, ui) {
      var clockView, settingsView;
      clockView = new ClockView({
        el: $(event.target).find('#clock'),
        model: clockModel,
        scale: .8,
        sync: true
      });
      return settingsView = new SettingsView({
        el: '#settings',
        model: clockModel
      });
    });
  });

}).call(this);

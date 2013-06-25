// Generated by CoffeeScript 1.6.3
(function() {
  this.sync = function(method, model, options) {
    var resp, store;
    console.log("central", method, model, options);
    store = model.localStorage;
    switch (method) {
      case 'create':
        resp = store.create(model);
        break;
      case 'read':
        resp = model.id != null ? store.find(model) : store.findAll();
        break;
      case 'update':
        resp = store.update(model);
        break;
      case 'delete':
        resp = store.destroy(model);
    }
    if (resp) {
      return options.success(resp);
    }
  };

  require.config({
    paths: {
      jquery: 'http://code.jquery.com/jquery-1.7.1.min',
      underscore: 'libs/underscore-min',
      backbone: 'libs/backbone-min',
      order: 'libs/order',
      text: 'libs/text',
      bootstrap: 'libs/bootstrap'
    }
  });

  require(['jquery', 'models/clockmodel', 'views/clockview', 'views/settingsview', 'views/tasksview'], function($, ClockModel, ClockView, SettingsView, TasksView) {
    return $(document).ready(function() {
      var clockModel, clockView, settingsView, tasksView;
      clockModel = new ClockModel({
        id: 'clock'
      });
      clockView = new ClockView({
        el: $('#clock'),
        model: clockModel,
        scale: .8,
        sync: true
      });
      settingsView = new SettingsView({
        el: '#settings',
        model: clockModel
      });
      return tasksView = new TasksView({
        el: '#tasks',
        model: clockModel
      });
    });
  });

}).call(this);

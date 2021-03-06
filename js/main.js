// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  require.config({
    paths: {
      jquery: 'vendor/jquery-2.0.2',
      underscore: 'vendor/underscore-1.4.4',
      backbone: 'vendor/backbone-1.0.0',
      localstorage: "vendor/backbone.localStorage",
      order: 'vendor/order',
      text: 'vendor/text',
      bootstrap: 'vendor/bootstrap',
      moment: 'vendor/moment'
    },
    shim: {
      underscore: {
        exports: "_"
      },
      backbone: {
        deps: ["underscore", "jquery"],
        exports: "Backbone"
      }
    }
  });

  require(['jquery', 'backbone', 'models/clockmodel', 'views/clockview', 'views/settingsview', 'views/tasksview'], function($, Backbone, ClockModel, ClockView, SettingsView, TasksView) {
    var Router;
    Router = (function(_super) {
      __extends(Router, _super);

      function Router(model, args) {
        Router.__super__.constructor.call(this, args);
        this.model = model;
      }

      Router.prototype.routes = {
        '': 'home',
        'tagged/:tag': 'tag'
      };

      Router.prototype.home = function() {
        return this.model.set('tag', null);
      };

      Router.prototype.tag = function(tag) {
        return this.model.set('tag', tag);
      };

      return Router;

    })(Backbone.Router);
    return $(document).ready(function() {
      var clockModel, clockView, settingsView, tasksView;
      clockModel = new ClockModel({
        id: 'clock'
      });
      window.router = new Router(clockModel);
      Backbone.history.start();
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

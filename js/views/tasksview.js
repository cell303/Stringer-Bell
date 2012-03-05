(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  define(['jquery', 'underscore', 'backbone', 'text!templates/tasks.html'], function($, _, Backbone, tasksTemplate) {
    var TasksView;
    TasksView = (function(_super) {

      __extends(TasksView, _super);

      function TasksView() {
        this.render = __bind(this.render, this);
        TasksView.__super__.constructor.apply(this, arguments);
      }

      TasksView.prototype.initialize = function() {
        return this.render();
      };

      TasksView.prototype.template = _.template(tasksTemplate);

      TasksView.prototype.render = function() {
        return this.$el.html(this.template(this.model.toJSON())).trigger('create');
      };

      return TasksView;

    })(Backbone.View);
    return TasksView;
  });

}).call(this);

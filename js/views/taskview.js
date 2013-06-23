// Generated by CoffeeScript 1.6.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'underscore', 'backbone', 'text!templates/task.html'], function($, _, Backbone, template) {
    var TaskView, _ref;
    TaskView = (function(_super) {
      __extends(TaskView, _super);

      function TaskView() {
        this.render = __bind(this.render, this);
        this.events = __bind(this.events, this);
        _ref = TaskView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      TaskView.prototype.tagName = "li";

      TaskView.prototype.className = "task";

      TaskView.prototype.template = _.template(template);

      TaskView.prototype.initialize = function() {
        this.model.on('change', this.render);
        return this.render();
      };

      TaskView.prototype.events = function() {
        var _this = this;
        return {
          'click .save': this.tweet,
          'click .edit': function() {
            return _this.model.save('edit', true);
          },
          'click .cancel': function() {
            return _this.model.save('edit', false);
          },
          'keyup textarea': this.update140
        };
      };

      TaskView.prototype.render = function() {
        var diff, json;
        diff = this.model.get('date') - this.model.get('startDate');
        diff = Math.round(diff / 60000);
        json = _.extend(this.model.toJSON(), {
          time: diff
        });
        this.$el.html(this.template(json));
        this.$el.toggleClass('break', this.model.get('isBreak'));
        this.input = this.$el.find('textarea');
        return this;
      };

      TaskView.prototype.tweet = function() {
        this.model.save('text', this.input.val());
        return this.model.save('edit', false);
      };

      TaskView.prototype.update140 = function() {
        return this.$el.find('.lead').text(140 - this.input.val().length);
      };

      return TaskView;

    })(Backbone.View);
    return TaskView;
  });

}).call(this);

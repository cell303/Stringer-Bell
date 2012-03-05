(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  define(['jquery', 'underscore', 'backbone', 'text!templates/settings.html'], function($, _, Backbone, settingsTemplate) {
    var SettingsView;
    SettingsView = (function(_super) {

      __extends(SettingsView, _super);

      function SettingsView() {
        this.resetToFreetime = __bind(this.resetToFreetime, this);
        this.resetToWorktime = __bind(this.resetToWorktime, this);
        this.stopClock = __bind(this.stopClock, this);
        this.allowNotifications = __bind(this.allowNotifications, this);
        this.setFreeTime = __bind(this.setFreeTime, this);
        this.setWorkTime = __bind(this.setWorkTime, this);
        this.toggleSound = __bind(this.toggleSound, this);
        this.render = __bind(this.render, this);
        SettingsView.__super__.constructor.apply(this, arguments);
      }

      SettingsView.prototype.initialize = function() {
        $(window).bind('resize', this.resize);
        return this.render();
      };

      SettingsView.prototype.template = _.template(settingsTemplate);

      SettingsView.prototype.render = function() {
        this.$el.html(this.template(this.model.toJSON())).trigger('create');
        return this.$('#slider-0, #slider-1').slider({
          theme: 'a',
          mini: true,
          highlight: true
        });
      };

      SettingsView.prototype.events = function() {
        return {
          'change #slider-0': this.setWorkTime,
          'change #slider-1': this.setFreeTime,
          'click #button-0': this.allowNotifications,
          'click #stop': this.stopClock,
          'click #prev': this.resetToWorktime,
          'click #next': this.resetToFreetime,
          'change #flip-a': this.toggleSound
        };
      };

      SettingsView.prototype.toggleSound = function(event) {
        return this.model.set({
          'sound': !this.model.get('sound')
        });
      };

      SettingsView.prototype.setWorkTime = function() {
        return this.model.setWorkTime(parseInt($('#slider-0').val()));
      };

      SettingsView.prototype.setFreeTime = function() {
        return this.model.setFreeTime(parseInt($('#slider-1').val()));
      };

      SettingsView.prototype.allowNotifications = function() {
        return window.webkitNotifications.requestPermission();
      };

      SettingsView.prototype.stopClock = function() {
        return this.model.stopClock();
      };

      SettingsView.prototype.resetToWorktime = function() {
        return this.model.resetToWorktime();
      };

      SettingsView.prototype.resetToFreetime = function() {
        return this.model.resetToFreetime();
      };

      return SettingsView;

    })(Backbone.View);
    return SettingsView;
  });

}).call(this);

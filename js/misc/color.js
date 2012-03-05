(function() {

  define([], function() {
    var Color;
    Color = (function() {

      function Color(r, g, b) {
        this.r = r;
        this.g = g;
        this.b = b;
      }

      Color.initHex = function(hexString) {
        var b, g, r, reg, res;
        reg = /^#(\w{2})(\w{2})(\w{2})$/;
        res = reg.exec(hexString);
        if (res) {
          r = parseInt(res[1], 16);
          g = parseInt(res[2], 16);
          b = parseInt(res[3], 16);
        } else {
          reg = /^#(\w{1})(\w{1})(\w{1})$/;
          res = reg.exec(hexString);
          if (res) {
            r = parseInt(res[1] + res[1], 16);
            g = parseInt(res[2] + res[2], 16);
            b = parseInt(res[3] + res[3], 16);
          }
        }
        return new Color(r, g, b);
      };

      Color.initRGB = function(rgbString) {
        var b, g, r, reg, res;
        reg = /^rgb\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3})\)$/;
        res = reg.exec(rgbString);
        if (res) {
          r = parseInt(res[1]);
          g = parseInt(res[2]);
          b = parseInt(res[3]);
        }
        return new Color(r, g, b);
      };

      Color.prototype.toHex = function() {
        var b, g, r;
        r = this.r.toString(16);
        g = this.g.toString(16);
        b = this.b.toString(16);
        if (r.length === 1) r = '0' + r;
        if (g.length === 1) g = '0' + g;
        if (b.length === 1) b = '0' + b;
        return "#" + this.r + this.g + this.b;
      };

      Color.prototype.toRGB = function() {
        return "rgb(" + this.r + "," + this.g + "," + this.b + ")";
      };

      return Color;

    })();
    return Color;
  });

}).call(this);

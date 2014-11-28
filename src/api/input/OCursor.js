(function() {
  angular.module('Services').service('CursorSvc', [
    '$rootScope', '$q', 'Particle', 'AssetsSvc', 'DeviceSvc', function($rootScope, $q, Particle, AssetsSvc, DeviceSvc) {
      var Cursor;
      Cursor = (function() {
        var x, y;

        function Cursor() {}

        x = 0;

        y = 0;

        Cursor.colorR = 255;

        Cursor.colorG = 255;

        Cursor.colorB = 0;

        Cursor.event = {};

        window.onmousemove = function(event) {
          return Cursor.event = event;
        };

        Cursor.prototype.update = function() {
          var rect;
          if (!Cursor.event.clientX) {
            return;
          }
          rect = DeviceSvc.canvas.getBoundingClientRect();
          x = Math.round(Cursor.event.clientX - rect.left / (rect.right - rect.left) * DeviceSvc.canvas.width) - 5;
          return y = Math.round(Cursor.event.clientY - rect.top / (rect.bottom - rect.top) * DeviceSvc.canvas.width) - 5;
        };

        Cursor.prototype.draw = function() {
          return DeviceSvc.ctx.drawImage(AssetsSvc.cursor, x, y);
        };

        return Cursor;

      })();
      return new Cursor();
    }
  ]);

}).call(this);

//# sourceMappingURL=OCursor.js.map

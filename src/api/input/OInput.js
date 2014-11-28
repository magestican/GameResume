(function() {
  angular.module('Services').service('InputSvc', [
    '$rootScope', '$q', 'Particle', function($rootScope, $q, Particle) {
      var Input;
      Input = (function() {
        function Input() {
          var self;
          this.keyState = [];
          this.keyCurrent = [];
          this.keyLast = [];
          this.Keys = {
            'BACKSPACE': 8,
            'COMMA': 188,
            'DELETE': 46,
            'DOWN': 40,
            'END': 35,
            'ENTER': 13,
            'ESCAPE': 27,
            'HOME': 36,
            'LEFT': 37,
            'NUMPAD_ADD': 107,
            'NUMPAD_DECIMAL': 110,
            'NUMPAD_DIVIDE': 111,
            'NUMPAD_ENTER': 108,
            'NUMPAD_MULTIPLY': 106,
            'NUMPAD_SUBTRACT': 109,
            'PAGE_DOWN': 34,
            'PAGE_UP': 33,
            'PERIOD': 190,
            'RIGHT': 39,
            'SPACE': 32,
            'TAB': 9,
            'UP': 38,
            'W': 87,
            'S': 83,
            'A': 65,
            'D': 68
          };
          self = this;
          window.addEventListener('keydown', function(ev) {
            self.keyCurrent[ev.which] = true;
            return self.keyState[ev.which] = true;
          });
          window.addEventListener('keyup', function(ev) {
            return self.keyState[ev.which] = false;
          });
        }

        Input.prototype.update = function() {
          this.keyLast = this.keyCurrent;
          this.keyCurrent = this.keyState;
          return void 0;
        };

        Input.prototype.isKeyDown = function(key) {
          return !!this.keyCurrent[key];
        };

        Input.prototype.isKeyTriggered = function(key) {
          return !!this.keyCurrent[key] && !this.keyLast[key];
        };

        Input.prototype.isKeyReleased = function(key) {
          return !this.keyCurrent[key] && !!this.keyLast[key];
        };

        return Input;

      })();
      return new Input();
    }
  ]);

}).call(this);

//# sourceMappingURL=OInput.js.map

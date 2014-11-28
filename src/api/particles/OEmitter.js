(function() {
  angular.module('Factories').factory('Emitter', [
    '$rootScope', '$q', 'Particle', function($rootScope, $q, Particle) {
      var Emitter;
      return Emitter = (function() {
        function Emitter(position, velocity, spread) {
          this.position = position;
          this.velocity = velocity;
          this.spread = spread != null ? spread : Math.PI / 32;
          this.drawColor = "#999";
        }

        Emitter.prototype.emitParticle = function() {
          var angle, magnitude, p, position, velocity;
          angle = this.velocity.getAngle() + this.spread - (Math.random() * this.spread * 2);
          magnitude = this.velocity.getMagnitude();
          position = new Vector(this.position.x, this.position.y);
          velocity = Vector.fromAngle(angle, magnitude);
          p = new Particle(position, velocity);
          return p;
        };

        return Emitter;

      })();
    }
  ]);

  angular.module('Services').service('EmitterSvc', [
    '$rootScope', '$q', 'Particle', function($rootScope, $q) {
      var emitters;
      return emitters = this.emitters = [];
    }
  ]);

}).call(this);

//# sourceMappingURL=OEmitter.js.map

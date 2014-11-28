(function() {
  angular.module('Factories').factory('Particle', [
    '$rootScope', '$q', function($rootScope, $q) {
      var Particle;
      Particle = function(point, velocity, acceleration) {
        this.position = point || new Vector(0, 0);
        this.velocity = velocity || new Vector(0, 0);
        this.acceleration = acceleration || new Vector(0, 0);
        return void 0;
      };
      Particle.prototype.move = function() {
        this.velocity.add(this.acceleration);
        return this.position.add(this.velocity);
      };
      Particle.prototype.submitToFields = function(fields) {
        var field, force, totalAccelerationX, totalAccelerationY, vectorX, vectorY, _i, _len, _results;
        totalAccelerationX = 0;
        totalAccelerationY = 0;
        _results = [];
        for (_i = 0, _len = fields.length; _i < _len; _i++) {
          field = fields[_i];
          vectorX = field.position.x - this.position.x;
          vectorY = field.position.y - this.position.y;
          force = field.mass / Math.pow(vectorX * vectorX + vectorY * vectorY, 1.5);
          totalAccelerationX += vectorX * force;
          totalAccelerationY += vectorY * force;
          _results.push(this.acceleration = new Vector(totalAccelerationX, totalAccelerationY));
        }
        return _results;
      };
      return Particle;
    }
  ]);

  angular.module('Services').service('ParticleSvc', [
    '$q', '$rootScope', '$location', 'EmitterSvc', 'DeviceSvc', function($q, $rootScope, $location, EmitterSvc, DeviceSvc) {
      var emissionRate, fields, maxParticles, particleSize, particles;
      particles = this.particles = [];
      fields = this.fields = [];
      particleSize = this.particleSize = 1;
      maxParticles = this.maxParticles = 4000;
      emissionRate = this.emissionRate = 4;
      this.DrawParticles = function() {
        var col1, col2, col3, particle, position, _i, _len, _results;
        col1 = Math.floor(Math.random() * 255) + 0;
        col2 = Math.floor(Math.random() * 255) + 0;
        col3 = Math.floor(Math.random() * 255) + 0;
        DeviceSvc.ctx.fillStyle = "rgb(" + col1.toString() + ',' + col2.toString() + ',' + col3.toString() + ')';
        _results = [];
        for (_i = 0, _len = particles.length; _i < _len; _i++) {
          particle = particles[_i];
          position = particle.position;
          _results.push(DeviceSvc.ctx.fillRect(position.x, position.y, this.particleSize, this.particleSize));
        }
        return _results;
      };
      this.PlotParticles = function(boundsX, boundsY) {
        var currentParticles, particle, pos, _i, _len;
        currentParticles = [];
        for (_i = 0, _len = particles.length; _i < _len; _i++) {
          particle = particles[_i];
          pos = particle.position;
          if (pos.x < 0 || pos.x > boundsX || pos.y < 0 || pos.y > boundsY) {
            continue;
          }
          particle.submitToFields(fields);
          particle.move();
          currentParticles.push(particle);
        }
        return particles = currentParticles;
      };
      this.AddNewParticles = function() {
        var emitter, error, j, _i, _len, _ref, _results;
        if (particles.length > maxParticles) {
          return;
        }
        _ref = EmitterSvc.emitters;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          emitter = _ref[_i];
          _results.push((function() {
            var _j, _results1;
            _results1 = [];
            for (j = _j = 0; 0 <= emissionRate ? _j <= emissionRate : _j >= emissionRate; j = 0 <= emissionRate ? ++_j : --_j) {
              try {
                _results1.push(particles.push(emitter.emitParticle()));
              } catch (_error) {
                error = _error;
                _results1.push((function() {
                  debugger;
                })());
              }
            }
            return _results1;
          })());
        }
        return _results;
      };
      return void 0;
    }
  ]);

}).call(this);

//# sourceMappingURL=OParticle.js.map

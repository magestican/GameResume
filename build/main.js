;(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){

require('./controllers.js');
require('./directives.js');
require('./factories.js');
require('./filters.js');


},{"./controllers.js":2,"./directives.js":4,"./factories.js":5,"./filters.js":6}],2:[function(require,module,exports){
angular.module('SlicControllers', []);

require('./controllers/main.js');
},{"./controllers/main.js":3}],3:[function(require,module,exports){
angular.module('SlicControllers')
    .controller('MainController', ['$scope', '$filter', function($scope, $filter) {

        //globals 
        var Game = {};
        Game.fps = 60;
        Game.maxFrameSkip = 10;
        Game.skipTicks = 1000 / Game.fps;

        var particles = [];
        var c = document.getElementById("myCanvas");
        var ctx = c.getContext("2d");
        var maxParticles = 7000;
        var emissionRate = 4; // how many particles are emitted each frame
        var particleSize = 1;
        var objectSize = 3; // drawSize of emitter/field
        //objects
        function Vector(x, y) {
            this.x = x || 0;
            this.y = y || 0;
        }
        Vector.prototype.add = function (vector) {
            this.x += vector.x;
            this.y += vector.y;
        }
        Vector.prototype.getMagnitude = function () {
            return Math.sqrt(this.x * this.x + this.y * this.y);
        };
        Vector.prototype.getAngle = function () {
            return Math.atan2(this.y, this.x);
        };
        Vector.fromAngle = function (angle, magnitude) {
            return new Vector(magnitude * Math.cos(angle), magnitude * Math.sin(angle));
        };
        function Particle(point, velocity, acceleration) {
            this.position = point || new Vector(0, 0);
            this.velocity = velocity || new Vector(0, 0);
            this.acceleration = acceleration || new Vector(0, 0);
        }
        Particle.prototype.move = function () {
            this.velocity.add(this.acceleration); // Vector
            this.position.add(this.velocity); // Vector
        };
        function Emitter(point, velocity, spread) {
            this.position = point; // Vector
            this.velocity = velocity; // Vector
            this.spread = spread || Math.PI / 32; // possible angles = velocity +/- spread
            this.drawColor = "#999"; // So we can tell them apart from Fields later
        }
        Emitter.prototype.emitParticle = function () {
            // Use an angle randomized over the spread so we have more of a "spray"
            var angle = this.velocity.getAngle() + this.spread - (Math.random() * this.spread * 2);
            var magnitude = this.velocity.getMagnitude();
            var position = new Vector(this.position.x, this.position.y);
            var velocity = Vector.fromAngle(angle, magnitude);
            // return our new Particle!
            return new Particle(position, velocity);
        };
        
        function addNewParticles() {
            // if we're at our max, stop emitting.
            if (particles.length > maxParticles) return;

            // for each emitter
            for (var i = 0; i < emitters.length; i++) {

                // for [emissionRate], emit a particle
                for (var j = 0; j < emissionRate; j++) {
                    particles.push(emitters[i].emitParticle());
                }
            }
        }
        function plotParticles(boundsX, boundsY) {
            // a new array to hold particles within our bounds
            var currentParticles = [];

            for (var i = 0; i < particles.length; i++) {
                var particle = particles[i];
                var pos = particle.position;

                // If we're out of bounds, drop this particle and move on to the next
                if (pos.x < 0 || pos.x > boundsX || pos.y < 0 || pos.y > boundsY) continue;

                // Move our particles
                particle.move();

                // Add this particle to the list of current particles
                currentParticles.push(particle);
            }

            // Update our global particles, clearing room for old particles to be collected
            particles = currentParticles;
        }
        function drawParticles() {
            // Set the color of our particles
            var col1 = Math.floor(Math.random() * 255) + 0;
            var col2 = Math.floor(Math.random() * 255) + 0;
            var col3 = Math.floor(Math.random() * 255) + 0;
            ctx.fillStyle = "rgb(".concat(col1.toString(), ",", col2.toString(), ",", col3.toString(), ")");

            // For each particle
            for (var i = 0; i < particles.length; i++) {
                var position = particles[i].position;

                // Draw a square at our position [particleSize] wide and tall
                ctx.fillRect(position.x, position.y, particleSize, particleSize);
            }
        }
        //emiter or repeller field
        function Field(point, mass) {
            this.position = point;
            this.setMass(mass);
        }
        //setter
        Field.prototype.setMass = function (mass) {
            this.mass = mass || 100;
            this.drawColor = mass < 0 ? "#f00" : "#0f0";
        }



        Particle.prototype.submitToFields = function (fields) {
            // our starting acceleration this frame
            var totalAccelerationX = 0;
            var totalAccelerationY = 0;

            // for each passed field
            for (var i = 0; i < fields.length; i++) {
                var field = fields[i];

                // find the distance between the particle and the field
                var vectorX = field.position.x - this.position.x;
                var vectorY = field.position.y - this.position.y;

                // calculate the force via MAGIC and HIGH SCHOOL SCIENCE!
                var force = field.mass / Math.pow(vectorX * vectorX + vectorY * vectorY, 1.5);

                // add to the total acceleration the force adjusted by distance
                totalAccelerationX += vectorX * force;
                totalAccelerationY += vectorY * force;
            }

            // update our particle's acceleration
            this.acceleration = new Vector(totalAccelerationX, totalAccelerationY);
        };

        Particle.prototype.submitToFields = function (fields) {
            // our starting acceleration this frame
            var totalAccelerationX = 0;
            var totalAccelerationY = 0;

            // for each passed field
            for (var i = 0; i < fields.length; i++) {
                var field = fields[i];

                // find the distance between the particle and the field
                var vectorX = field.position.x - this.position.x;
                var vectorY = field.position.y - this.position.y;

                // calculate the force via MAGIC and HIGH SCHOOL SCIENCE!
                var force = field.mass / Math.pow(vectorX * vectorX + vectorY * vectorY, 1.5);

                // add to the total acceleration the force adjusted by distance
                totalAccelerationX += vectorX * force;
                totalAccelerationY += vectorY * force;
            }

            // update our particle's acceleration
            this.acceleration = new Vector(totalAccelerationX, totalAccelerationY);
        };
        function plotParticles(boundsX, boundsY) {
            var currentParticles = [];
            for (var i = 0; i < particles.length; i++) {
                var particle = particles[i];
                var pos = particle.position;
                if (pos.x < 0 || pos.x > boundsX || pos.y < 0 || pos.y > boundsY) continue;

                // Update velocities and accelerations to account for the fields
                particle.submitToFields(fields);

                particle.move();
                currentParticles.push(particle);
            }
            particles = currentParticles;
        }

        // `object` is a field or emitter, something that has a drawColor and position
        function drawCircle(object) {
            ctx.fillStyle = object.drawColor;
            ctx.beginPath();
            ctx.arc(object.position.x, object.position.y, objectSize, 0, Math.PI * 2);
            ctx.closePath();
            ctx.fill();
        }


        var midX = c.width / 2;
        var midY = c.height / 2;


        var emitters = [
          new Emitter(new Vector(midX - 150, midY), Vector.fromAngle(6, 2))
        ];

        var fields = [
          new Field(new Vector(midX - 100, midY + 20), 150),
          new Field(new Vector(midX - 300, midY + 20), 100),
          new Field(new Vector(midX - 200, midY - 40), -20),
          new Field(new Vector(midX, midY + 20), -20),
        ];

        function drawMyName() {
            ctx.font = "30pt serif";
            ctx.fillText("Bryan Arbelo", midX + 180, midY);
            ctx.font = "10pt serif";
            ctx.fillText("Hope you like my angular.js + game engine demo :)", midX + 180, midY + 100);
        }

      
        //THERE IS NO WHILE!!


        Game.initialize = function () {
            this.entities = [];
            this.viewport = document.body;

            this.input = new Input();

            this.debug = new Debug();
            this.debug.initialize(this.viewport);

            this.screen = new Screen();
            this.screen.initialize(this.viewport);
            this.screen.setWorld(new World());
        };

        Game.update = function (tick) {
            Game.tick = tick;
            this.input.update();
            this.debug.update();
            this.screen.update();
        };

        Game.draw = function () {
            this.debug.draw();
            this.screen.clear();
            this.screen.draw();
        };

        Game.pause = function () {
            this.paused = (this.paused) ? false : true;
        };

        Game.clear = function () {
            ctx.clearRect(0, 0, c.width, c.height);
        }
        /*
         * Runs the actual loop inside browser
         */
        Game.run = (function () {
            var loops = 0;
            var nextGameTick = (new Date).getTime();
            var startTime = (new Date).getTime();
            return function () {
                loops = 0;
                while (!Game.paused && (new Date).getTime() > nextGameTick && loops < Game.maxFrameSkip) {
                    Game.update(nextGameTick - startTime);
                    nextGameTick += Game.skipTicks;
                    loops++;
                }
                Game.draw();
            };
        })();

        (function () {
            var onEachFrame;
            if (window.webkitRequestAnimationFrame) {
                onEachFrame = function (cb) {
                    var _cb = function () {
                        cb();
                        webkitRequestAnimationFrame(_cb);
                    };
                    _cb();
                };
            } else if (window.mozRequestAnimationFrame) {
                onEachFrame = function (cb) {
                    var _cb = function () {
                        cb();
                        mozRequestAnimationFrame(_cb);
                    };
                    _cb();
                };
            } else {
                onEachFrame = function (cb) {
                    setInterval(cb, Game.skipTicks);
                };
            }

            window.onEachFrame = onEachFrame;
        })();










    }]);
},{}],4:[function(require,module,exports){
angular.module('SlicDirectives', []);

//require('./directives/button.js');
},{}],5:[function(require,module,exports){
angular.module('SlicFactories', []);

//require('./factories/factories.js');
},{}],6:[function(require,module,exports){
angular.module('SlicFilters', []);

//require('./filters/file.js');
},{}]},{},[1])
//@ sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIkM6L0dhbWVSZXN1bWUvc3JjL2dhbWUvYnJvd3NlcmlmeVdpcmUuanMiLCJDOi9HYW1lUmVzdW1lL3NyYy9nYW1lL2NvbnRyb2xsZXJzLmpzIiwiQzovR2FtZVJlc3VtZS9zcmMvZ2FtZS9jb250cm9sbGVycy9tYWluLmpzIiwiQzovR2FtZVJlc3VtZS9zcmMvZ2FtZS9kaXJlY3RpdmVzLmpzIiwiQzovR2FtZVJlc3VtZS9zcmMvZ2FtZS9mYWN0b3JpZXMuanMiLCJDOi9HYW1lUmVzdW1lL3NyYy9nYW1lL2ZpbHRlcnMuanMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IjtBQUFBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQ05BO0FBQ0E7QUFDQTs7QUNGQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQ3RUQTtBQUNBO0FBQ0E7O0FDRkE7QUFDQTtBQUNBOztBQ0ZBO0FBQ0E7QUFDQSIsImZpbGUiOiJnZW5lcmF0ZWQuanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlc0NvbnRlbnQiOlsiXHJcbnJlcXVpcmUoJy4vY29udHJvbGxlcnMuanMnKTtcclxucmVxdWlyZSgnLi9kaXJlY3RpdmVzLmpzJyk7XHJcbnJlcXVpcmUoJy4vZmFjdG9yaWVzLmpzJyk7XHJcbnJlcXVpcmUoJy4vZmlsdGVycy5qcycpO1xyXG5cclxuIiwiYW5ndWxhci5tb2R1bGUoJ1NsaWNDb250cm9sbGVycycsIFtdKTtcclxuXHJcbnJlcXVpcmUoJy4vY29udHJvbGxlcnMvbWFpbi5qcycpOyIsImFuZ3VsYXIubW9kdWxlKCdTbGljQ29udHJvbGxlcnMnKVxyXG4gICAgLmNvbnRyb2xsZXIoJ01haW5Db250cm9sbGVyJywgWyckc2NvcGUnLCAnJGZpbHRlcicsIGZ1bmN0aW9uKCRzY29wZSwgJGZpbHRlcikge1xyXG5cclxuICAgICAgICAvL2dsb2JhbHMgXHJcbiAgICAgICAgdmFyIEdhbWUgPSB7fTtcclxuICAgICAgICBHYW1lLmZwcyA9IDYwO1xyXG4gICAgICAgIEdhbWUubWF4RnJhbWVTa2lwID0gMTA7XHJcbiAgICAgICAgR2FtZS5za2lwVGlja3MgPSAxMDAwIC8gR2FtZS5mcHM7XHJcblxyXG4gICAgICAgIHZhciBwYXJ0aWNsZXMgPSBbXTtcclxuICAgICAgICB2YXIgYyA9IGRvY3VtZW50LmdldEVsZW1lbnRCeUlkKFwibXlDYW52YXNcIik7XHJcbiAgICAgICAgdmFyIGN0eCA9IGMuZ2V0Q29udGV4dChcIjJkXCIpO1xyXG4gICAgICAgIHZhciBtYXhQYXJ0aWNsZXMgPSA3MDAwO1xyXG4gICAgICAgIHZhciBlbWlzc2lvblJhdGUgPSA0OyAvLyBob3cgbWFueSBwYXJ0aWNsZXMgYXJlIGVtaXR0ZWQgZWFjaCBmcmFtZVxyXG4gICAgICAgIHZhciBwYXJ0aWNsZVNpemUgPSAxO1xyXG4gICAgICAgIHZhciBvYmplY3RTaXplID0gMzsgLy8gZHJhd1NpemUgb2YgZW1pdHRlci9maWVsZFxyXG4gICAgICAgIC8vb2JqZWN0c1xyXG4gICAgICAgIGZ1bmN0aW9uIFZlY3Rvcih4LCB5KSB7XHJcbiAgICAgICAgICAgIHRoaXMueCA9IHggfHwgMDtcclxuICAgICAgICAgICAgdGhpcy55ID0geSB8fCAwO1xyXG4gICAgICAgIH1cclxuICAgICAgICBWZWN0b3IucHJvdG90eXBlLmFkZCA9IGZ1bmN0aW9uICh2ZWN0b3IpIHtcclxuICAgICAgICAgICAgdGhpcy54ICs9IHZlY3Rvci54O1xyXG4gICAgICAgICAgICB0aGlzLnkgKz0gdmVjdG9yLnk7XHJcbiAgICAgICAgfVxyXG4gICAgICAgIFZlY3Rvci5wcm90b3R5cGUuZ2V0TWFnbml0dWRlID0gZnVuY3Rpb24gKCkge1xyXG4gICAgICAgICAgICByZXR1cm4gTWF0aC5zcXJ0KHRoaXMueCAqIHRoaXMueCArIHRoaXMueSAqIHRoaXMueSk7XHJcbiAgICAgICAgfTtcclxuICAgICAgICBWZWN0b3IucHJvdG90eXBlLmdldEFuZ2xlID0gZnVuY3Rpb24gKCkge1xyXG4gICAgICAgICAgICByZXR1cm4gTWF0aC5hdGFuMih0aGlzLnksIHRoaXMueCk7XHJcbiAgICAgICAgfTtcclxuICAgICAgICBWZWN0b3IuZnJvbUFuZ2xlID0gZnVuY3Rpb24gKGFuZ2xlLCBtYWduaXR1ZGUpIHtcclxuICAgICAgICAgICAgcmV0dXJuIG5ldyBWZWN0b3IobWFnbml0dWRlICogTWF0aC5jb3MoYW5nbGUpLCBtYWduaXR1ZGUgKiBNYXRoLnNpbihhbmdsZSkpO1xyXG4gICAgICAgIH07XHJcbiAgICAgICAgZnVuY3Rpb24gUGFydGljbGUocG9pbnQsIHZlbG9jaXR5LCBhY2NlbGVyYXRpb24pIHtcclxuICAgICAgICAgICAgdGhpcy5wb3NpdGlvbiA9IHBvaW50IHx8IG5ldyBWZWN0b3IoMCwgMCk7XHJcbiAgICAgICAgICAgIHRoaXMudmVsb2NpdHkgPSB2ZWxvY2l0eSB8fCBuZXcgVmVjdG9yKDAsIDApO1xyXG4gICAgICAgICAgICB0aGlzLmFjY2VsZXJhdGlvbiA9IGFjY2VsZXJhdGlvbiB8fCBuZXcgVmVjdG9yKDAsIDApO1xyXG4gICAgICAgIH1cclxuICAgICAgICBQYXJ0aWNsZS5wcm90b3R5cGUubW92ZSA9IGZ1bmN0aW9uICgpIHtcclxuICAgICAgICAgICAgdGhpcy52ZWxvY2l0eS5hZGQodGhpcy5hY2NlbGVyYXRpb24pOyAvLyBWZWN0b3JcclxuICAgICAgICAgICAgdGhpcy5wb3NpdGlvbi5hZGQodGhpcy52ZWxvY2l0eSk7IC8vIFZlY3RvclxyXG4gICAgICAgIH07XHJcbiAgICAgICAgZnVuY3Rpb24gRW1pdHRlcihwb2ludCwgdmVsb2NpdHksIHNwcmVhZCkge1xyXG4gICAgICAgICAgICB0aGlzLnBvc2l0aW9uID0gcG9pbnQ7IC8vIFZlY3RvclxyXG4gICAgICAgICAgICB0aGlzLnZlbG9jaXR5ID0gdmVsb2NpdHk7IC8vIFZlY3RvclxyXG4gICAgICAgICAgICB0aGlzLnNwcmVhZCA9IHNwcmVhZCB8fCBNYXRoLlBJIC8gMzI7IC8vIHBvc3NpYmxlIGFuZ2xlcyA9IHZlbG9jaXR5ICsvLSBzcHJlYWRcclxuICAgICAgICAgICAgdGhpcy5kcmF3Q29sb3IgPSBcIiM5OTlcIjsgLy8gU28gd2UgY2FuIHRlbGwgdGhlbSBhcGFydCBmcm9tIEZpZWxkcyBsYXRlclxyXG4gICAgICAgIH1cclxuICAgICAgICBFbWl0dGVyLnByb3RvdHlwZS5lbWl0UGFydGljbGUgPSBmdW5jdGlvbiAoKSB7XHJcbiAgICAgICAgICAgIC8vIFVzZSBhbiBhbmdsZSByYW5kb21pemVkIG92ZXIgdGhlIHNwcmVhZCBzbyB3ZSBoYXZlIG1vcmUgb2YgYSBcInNwcmF5XCJcclxuICAgICAgICAgICAgdmFyIGFuZ2xlID0gdGhpcy52ZWxvY2l0eS5nZXRBbmdsZSgpICsgdGhpcy5zcHJlYWQgLSAoTWF0aC5yYW5kb20oKSAqIHRoaXMuc3ByZWFkICogMik7XHJcbiAgICAgICAgICAgIHZhciBtYWduaXR1ZGUgPSB0aGlzLnZlbG9jaXR5LmdldE1hZ25pdHVkZSgpO1xyXG4gICAgICAgICAgICB2YXIgcG9zaXRpb24gPSBuZXcgVmVjdG9yKHRoaXMucG9zaXRpb24ueCwgdGhpcy5wb3NpdGlvbi55KTtcclxuICAgICAgICAgICAgdmFyIHZlbG9jaXR5ID0gVmVjdG9yLmZyb21BbmdsZShhbmdsZSwgbWFnbml0dWRlKTtcclxuICAgICAgICAgICAgLy8gcmV0dXJuIG91ciBuZXcgUGFydGljbGUhXHJcbiAgICAgICAgICAgIHJldHVybiBuZXcgUGFydGljbGUocG9zaXRpb24sIHZlbG9jaXR5KTtcclxuICAgICAgICB9O1xyXG4gICAgICAgIFxyXG4gICAgICAgIGZ1bmN0aW9uIGFkZE5ld1BhcnRpY2xlcygpIHtcclxuICAgICAgICAgICAgLy8gaWYgd2UncmUgYXQgb3VyIG1heCwgc3RvcCBlbWl0dGluZy5cclxuICAgICAgICAgICAgaWYgKHBhcnRpY2xlcy5sZW5ndGggPiBtYXhQYXJ0aWNsZXMpIHJldHVybjtcclxuXHJcbiAgICAgICAgICAgIC8vIGZvciBlYWNoIGVtaXR0ZXJcclxuICAgICAgICAgICAgZm9yICh2YXIgaSA9IDA7IGkgPCBlbWl0dGVycy5sZW5ndGg7IGkrKykge1xyXG5cclxuICAgICAgICAgICAgICAgIC8vIGZvciBbZW1pc3Npb25SYXRlXSwgZW1pdCBhIHBhcnRpY2xlXHJcbiAgICAgICAgICAgICAgICBmb3IgKHZhciBqID0gMDsgaiA8IGVtaXNzaW9uUmF0ZTsgaisrKSB7XHJcbiAgICAgICAgICAgICAgICAgICAgcGFydGljbGVzLnB1c2goZW1pdHRlcnNbaV0uZW1pdFBhcnRpY2xlKCkpO1xyXG4gICAgICAgICAgICAgICAgfVxyXG4gICAgICAgICAgICB9XHJcbiAgICAgICAgfVxyXG4gICAgICAgIGZ1bmN0aW9uIHBsb3RQYXJ0aWNsZXMoYm91bmRzWCwgYm91bmRzWSkge1xyXG4gICAgICAgICAgICAvLyBhIG5ldyBhcnJheSB0byBob2xkIHBhcnRpY2xlcyB3aXRoaW4gb3VyIGJvdW5kc1xyXG4gICAgICAgICAgICB2YXIgY3VycmVudFBhcnRpY2xlcyA9IFtdO1xyXG5cclxuICAgICAgICAgICAgZm9yICh2YXIgaSA9IDA7IGkgPCBwYXJ0aWNsZXMubGVuZ3RoOyBpKyspIHtcclxuICAgICAgICAgICAgICAgIHZhciBwYXJ0aWNsZSA9IHBhcnRpY2xlc1tpXTtcclxuICAgICAgICAgICAgICAgIHZhciBwb3MgPSBwYXJ0aWNsZS5wb3NpdGlvbjtcclxuXHJcbiAgICAgICAgICAgICAgICAvLyBJZiB3ZSdyZSBvdXQgb2YgYm91bmRzLCBkcm9wIHRoaXMgcGFydGljbGUgYW5kIG1vdmUgb24gdG8gdGhlIG5leHRcclxuICAgICAgICAgICAgICAgIGlmIChwb3MueCA8IDAgfHwgcG9zLnggPiBib3VuZHNYIHx8IHBvcy55IDwgMCB8fCBwb3MueSA+IGJvdW5kc1kpIGNvbnRpbnVlO1xyXG5cclxuICAgICAgICAgICAgICAgIC8vIE1vdmUgb3VyIHBhcnRpY2xlc1xyXG4gICAgICAgICAgICAgICAgcGFydGljbGUubW92ZSgpO1xyXG5cclxuICAgICAgICAgICAgICAgIC8vIEFkZCB0aGlzIHBhcnRpY2xlIHRvIHRoZSBsaXN0IG9mIGN1cnJlbnQgcGFydGljbGVzXHJcbiAgICAgICAgICAgICAgICBjdXJyZW50UGFydGljbGVzLnB1c2gocGFydGljbGUpO1xyXG4gICAgICAgICAgICB9XHJcblxyXG4gICAgICAgICAgICAvLyBVcGRhdGUgb3VyIGdsb2JhbCBwYXJ0aWNsZXMsIGNsZWFyaW5nIHJvb20gZm9yIG9sZCBwYXJ0aWNsZXMgdG8gYmUgY29sbGVjdGVkXHJcbiAgICAgICAgICAgIHBhcnRpY2xlcyA9IGN1cnJlbnRQYXJ0aWNsZXM7XHJcbiAgICAgICAgfVxyXG4gICAgICAgIGZ1bmN0aW9uIGRyYXdQYXJ0aWNsZXMoKSB7XHJcbiAgICAgICAgICAgIC8vIFNldCB0aGUgY29sb3Igb2Ygb3VyIHBhcnRpY2xlc1xyXG4gICAgICAgICAgICB2YXIgY29sMSA9IE1hdGguZmxvb3IoTWF0aC5yYW5kb20oKSAqIDI1NSkgKyAwO1xyXG4gICAgICAgICAgICB2YXIgY29sMiA9IE1hdGguZmxvb3IoTWF0aC5yYW5kb20oKSAqIDI1NSkgKyAwO1xyXG4gICAgICAgICAgICB2YXIgY29sMyA9IE1hdGguZmxvb3IoTWF0aC5yYW5kb20oKSAqIDI1NSkgKyAwO1xyXG4gICAgICAgICAgICBjdHguZmlsbFN0eWxlID0gXCJyZ2IoXCIuY29uY2F0KGNvbDEudG9TdHJpbmcoKSwgXCIsXCIsIGNvbDIudG9TdHJpbmcoKSwgXCIsXCIsIGNvbDMudG9TdHJpbmcoKSwgXCIpXCIpO1xyXG5cclxuICAgICAgICAgICAgLy8gRm9yIGVhY2ggcGFydGljbGVcclxuICAgICAgICAgICAgZm9yICh2YXIgaSA9IDA7IGkgPCBwYXJ0aWNsZXMubGVuZ3RoOyBpKyspIHtcclxuICAgICAgICAgICAgICAgIHZhciBwb3NpdGlvbiA9IHBhcnRpY2xlc1tpXS5wb3NpdGlvbjtcclxuXHJcbiAgICAgICAgICAgICAgICAvLyBEcmF3IGEgc3F1YXJlIGF0IG91ciBwb3NpdGlvbiBbcGFydGljbGVTaXplXSB3aWRlIGFuZCB0YWxsXHJcbiAgICAgICAgICAgICAgICBjdHguZmlsbFJlY3QocG9zaXRpb24ueCwgcG9zaXRpb24ueSwgcGFydGljbGVTaXplLCBwYXJ0aWNsZVNpemUpO1xyXG4gICAgICAgICAgICB9XHJcbiAgICAgICAgfVxyXG4gICAgICAgIC8vZW1pdGVyIG9yIHJlcGVsbGVyIGZpZWxkXHJcbiAgICAgICAgZnVuY3Rpb24gRmllbGQocG9pbnQsIG1hc3MpIHtcclxuICAgICAgICAgICAgdGhpcy5wb3NpdGlvbiA9IHBvaW50O1xyXG4gICAgICAgICAgICB0aGlzLnNldE1hc3MobWFzcyk7XHJcbiAgICAgICAgfVxyXG4gICAgICAgIC8vc2V0dGVyXHJcbiAgICAgICAgRmllbGQucHJvdG90eXBlLnNldE1hc3MgPSBmdW5jdGlvbiAobWFzcykge1xyXG4gICAgICAgICAgICB0aGlzLm1hc3MgPSBtYXNzIHx8IDEwMDtcclxuICAgICAgICAgICAgdGhpcy5kcmF3Q29sb3IgPSBtYXNzIDwgMCA/IFwiI2YwMFwiIDogXCIjMGYwXCI7XHJcbiAgICAgICAgfVxyXG5cclxuXHJcblxyXG4gICAgICAgIFBhcnRpY2xlLnByb3RvdHlwZS5zdWJtaXRUb0ZpZWxkcyA9IGZ1bmN0aW9uIChmaWVsZHMpIHtcclxuICAgICAgICAgICAgLy8gb3VyIHN0YXJ0aW5nIGFjY2VsZXJhdGlvbiB0aGlzIGZyYW1lXHJcbiAgICAgICAgICAgIHZhciB0b3RhbEFjY2VsZXJhdGlvblggPSAwO1xyXG4gICAgICAgICAgICB2YXIgdG90YWxBY2NlbGVyYXRpb25ZID0gMDtcclxuXHJcbiAgICAgICAgICAgIC8vIGZvciBlYWNoIHBhc3NlZCBmaWVsZFxyXG4gICAgICAgICAgICBmb3IgKHZhciBpID0gMDsgaSA8IGZpZWxkcy5sZW5ndGg7IGkrKykge1xyXG4gICAgICAgICAgICAgICAgdmFyIGZpZWxkID0gZmllbGRzW2ldO1xyXG5cclxuICAgICAgICAgICAgICAgIC8vIGZpbmQgdGhlIGRpc3RhbmNlIGJldHdlZW4gdGhlIHBhcnRpY2xlIGFuZCB0aGUgZmllbGRcclxuICAgICAgICAgICAgICAgIHZhciB2ZWN0b3JYID0gZmllbGQucG9zaXRpb24ueCAtIHRoaXMucG9zaXRpb24ueDtcclxuICAgICAgICAgICAgICAgIHZhciB2ZWN0b3JZID0gZmllbGQucG9zaXRpb24ueSAtIHRoaXMucG9zaXRpb24ueTtcclxuXHJcbiAgICAgICAgICAgICAgICAvLyBjYWxjdWxhdGUgdGhlIGZvcmNlIHZpYSBNQUdJQyBhbmQgSElHSCBTQ0hPT0wgU0NJRU5DRSFcclxuICAgICAgICAgICAgICAgIHZhciBmb3JjZSA9IGZpZWxkLm1hc3MgLyBNYXRoLnBvdyh2ZWN0b3JYICogdmVjdG9yWCArIHZlY3RvclkgKiB2ZWN0b3JZLCAxLjUpO1xyXG5cclxuICAgICAgICAgICAgICAgIC8vIGFkZCB0byB0aGUgdG90YWwgYWNjZWxlcmF0aW9uIHRoZSBmb3JjZSBhZGp1c3RlZCBieSBkaXN0YW5jZVxyXG4gICAgICAgICAgICAgICAgdG90YWxBY2NlbGVyYXRpb25YICs9IHZlY3RvclggKiBmb3JjZTtcclxuICAgICAgICAgICAgICAgIHRvdGFsQWNjZWxlcmF0aW9uWSArPSB2ZWN0b3JZICogZm9yY2U7XHJcbiAgICAgICAgICAgIH1cclxuXHJcbiAgICAgICAgICAgIC8vIHVwZGF0ZSBvdXIgcGFydGljbGUncyBhY2NlbGVyYXRpb25cclxuICAgICAgICAgICAgdGhpcy5hY2NlbGVyYXRpb24gPSBuZXcgVmVjdG9yKHRvdGFsQWNjZWxlcmF0aW9uWCwgdG90YWxBY2NlbGVyYXRpb25ZKTtcclxuICAgICAgICB9O1xyXG5cclxuICAgICAgICBQYXJ0aWNsZS5wcm90b3R5cGUuc3VibWl0VG9GaWVsZHMgPSBmdW5jdGlvbiAoZmllbGRzKSB7XHJcbiAgICAgICAgICAgIC8vIG91ciBzdGFydGluZyBhY2NlbGVyYXRpb24gdGhpcyBmcmFtZVxyXG4gICAgICAgICAgICB2YXIgdG90YWxBY2NlbGVyYXRpb25YID0gMDtcclxuICAgICAgICAgICAgdmFyIHRvdGFsQWNjZWxlcmF0aW9uWSA9IDA7XHJcblxyXG4gICAgICAgICAgICAvLyBmb3IgZWFjaCBwYXNzZWQgZmllbGRcclxuICAgICAgICAgICAgZm9yICh2YXIgaSA9IDA7IGkgPCBmaWVsZHMubGVuZ3RoOyBpKyspIHtcclxuICAgICAgICAgICAgICAgIHZhciBmaWVsZCA9IGZpZWxkc1tpXTtcclxuXHJcbiAgICAgICAgICAgICAgICAvLyBmaW5kIHRoZSBkaXN0YW5jZSBiZXR3ZWVuIHRoZSBwYXJ0aWNsZSBhbmQgdGhlIGZpZWxkXHJcbiAgICAgICAgICAgICAgICB2YXIgdmVjdG9yWCA9IGZpZWxkLnBvc2l0aW9uLnggLSB0aGlzLnBvc2l0aW9uLng7XHJcbiAgICAgICAgICAgICAgICB2YXIgdmVjdG9yWSA9IGZpZWxkLnBvc2l0aW9uLnkgLSB0aGlzLnBvc2l0aW9uLnk7XHJcblxyXG4gICAgICAgICAgICAgICAgLy8gY2FsY3VsYXRlIHRoZSBmb3JjZSB2aWEgTUFHSUMgYW5kIEhJR0ggU0NIT09MIFNDSUVOQ0UhXHJcbiAgICAgICAgICAgICAgICB2YXIgZm9yY2UgPSBmaWVsZC5tYXNzIC8gTWF0aC5wb3codmVjdG9yWCAqIHZlY3RvclggKyB2ZWN0b3JZICogdmVjdG9yWSwgMS41KTtcclxuXHJcbiAgICAgICAgICAgICAgICAvLyBhZGQgdG8gdGhlIHRvdGFsIGFjY2VsZXJhdGlvbiB0aGUgZm9yY2UgYWRqdXN0ZWQgYnkgZGlzdGFuY2VcclxuICAgICAgICAgICAgICAgIHRvdGFsQWNjZWxlcmF0aW9uWCArPSB2ZWN0b3JYICogZm9yY2U7XHJcbiAgICAgICAgICAgICAgICB0b3RhbEFjY2VsZXJhdGlvblkgKz0gdmVjdG9yWSAqIGZvcmNlO1xyXG4gICAgICAgICAgICB9XHJcblxyXG4gICAgICAgICAgICAvLyB1cGRhdGUgb3VyIHBhcnRpY2xlJ3MgYWNjZWxlcmF0aW9uXHJcbiAgICAgICAgICAgIHRoaXMuYWNjZWxlcmF0aW9uID0gbmV3IFZlY3Rvcih0b3RhbEFjY2VsZXJhdGlvblgsIHRvdGFsQWNjZWxlcmF0aW9uWSk7XHJcbiAgICAgICAgfTtcclxuICAgICAgICBmdW5jdGlvbiBwbG90UGFydGljbGVzKGJvdW5kc1gsIGJvdW5kc1kpIHtcclxuICAgICAgICAgICAgdmFyIGN1cnJlbnRQYXJ0aWNsZXMgPSBbXTtcclxuICAgICAgICAgICAgZm9yICh2YXIgaSA9IDA7IGkgPCBwYXJ0aWNsZXMubGVuZ3RoOyBpKyspIHtcclxuICAgICAgICAgICAgICAgIHZhciBwYXJ0aWNsZSA9IHBhcnRpY2xlc1tpXTtcclxuICAgICAgICAgICAgICAgIHZhciBwb3MgPSBwYXJ0aWNsZS5wb3NpdGlvbjtcclxuICAgICAgICAgICAgICAgIGlmIChwb3MueCA8IDAgfHwgcG9zLnggPiBib3VuZHNYIHx8IHBvcy55IDwgMCB8fCBwb3MueSA+IGJvdW5kc1kpIGNvbnRpbnVlO1xyXG5cclxuICAgICAgICAgICAgICAgIC8vIFVwZGF0ZSB2ZWxvY2l0aWVzIGFuZCBhY2NlbGVyYXRpb25zIHRvIGFjY291bnQgZm9yIHRoZSBmaWVsZHNcclxuICAgICAgICAgICAgICAgIHBhcnRpY2xlLnN1Ym1pdFRvRmllbGRzKGZpZWxkcyk7XHJcblxyXG4gICAgICAgICAgICAgICAgcGFydGljbGUubW92ZSgpO1xyXG4gICAgICAgICAgICAgICAgY3VycmVudFBhcnRpY2xlcy5wdXNoKHBhcnRpY2xlKTtcclxuICAgICAgICAgICAgfVxyXG4gICAgICAgICAgICBwYXJ0aWNsZXMgPSBjdXJyZW50UGFydGljbGVzO1xyXG4gICAgICAgIH1cclxuXHJcbiAgICAgICAgLy8gYG9iamVjdGAgaXMgYSBmaWVsZCBvciBlbWl0dGVyLCBzb21ldGhpbmcgdGhhdCBoYXMgYSBkcmF3Q29sb3IgYW5kIHBvc2l0aW9uXHJcbiAgICAgICAgZnVuY3Rpb24gZHJhd0NpcmNsZShvYmplY3QpIHtcclxuICAgICAgICAgICAgY3R4LmZpbGxTdHlsZSA9IG9iamVjdC5kcmF3Q29sb3I7XHJcbiAgICAgICAgICAgIGN0eC5iZWdpblBhdGgoKTtcclxuICAgICAgICAgICAgY3R4LmFyYyhvYmplY3QucG9zaXRpb24ueCwgb2JqZWN0LnBvc2l0aW9uLnksIG9iamVjdFNpemUsIDAsIE1hdGguUEkgKiAyKTtcclxuICAgICAgICAgICAgY3R4LmNsb3NlUGF0aCgpO1xyXG4gICAgICAgICAgICBjdHguZmlsbCgpO1xyXG4gICAgICAgIH1cclxuXHJcblxyXG4gICAgICAgIHZhciBtaWRYID0gYy53aWR0aCAvIDI7XHJcbiAgICAgICAgdmFyIG1pZFkgPSBjLmhlaWdodCAvIDI7XHJcblxyXG5cclxuICAgICAgICB2YXIgZW1pdHRlcnMgPSBbXHJcbiAgICAgICAgICBuZXcgRW1pdHRlcihuZXcgVmVjdG9yKG1pZFggLSAxNTAsIG1pZFkpLCBWZWN0b3IuZnJvbUFuZ2xlKDYsIDIpKVxyXG4gICAgICAgIF07XHJcblxyXG4gICAgICAgIHZhciBmaWVsZHMgPSBbXHJcbiAgICAgICAgICBuZXcgRmllbGQobmV3IFZlY3RvcihtaWRYIC0gMTAwLCBtaWRZICsgMjApLCAxNTApLFxyXG4gICAgICAgICAgbmV3IEZpZWxkKG5ldyBWZWN0b3IobWlkWCAtIDMwMCwgbWlkWSArIDIwKSwgMTAwKSxcclxuICAgICAgICAgIG5ldyBGaWVsZChuZXcgVmVjdG9yKG1pZFggLSAyMDAsIG1pZFkgLSA0MCksIC0yMCksXHJcbiAgICAgICAgICBuZXcgRmllbGQobmV3IFZlY3RvcihtaWRYLCBtaWRZICsgMjApLCAtMjApLFxyXG4gICAgICAgIF07XHJcblxyXG4gICAgICAgIGZ1bmN0aW9uIGRyYXdNeU5hbWUoKSB7XHJcbiAgICAgICAgICAgIGN0eC5mb250ID0gXCIzMHB0IHNlcmlmXCI7XHJcbiAgICAgICAgICAgIGN0eC5maWxsVGV4dChcIkJyeWFuIEFyYmVsb1wiLCBtaWRYICsgMTgwLCBtaWRZKTtcclxuICAgICAgICAgICAgY3R4LmZvbnQgPSBcIjEwcHQgc2VyaWZcIjtcclxuICAgICAgICAgICAgY3R4LmZpbGxUZXh0KFwiSG9wZSB5b3UgbGlrZSBteSBhbmd1bGFyLmpzICsgZ2FtZSBlbmdpbmUgZGVtbyA6KVwiLCBtaWRYICsgMTgwLCBtaWRZICsgMTAwKTtcclxuICAgICAgICB9XHJcblxyXG4gICAgICBcclxuICAgICAgICAvL1RIRVJFIElTIE5PIFdISUxFISFcclxuXHJcblxyXG4gICAgICAgIEdhbWUuaW5pdGlhbGl6ZSA9IGZ1bmN0aW9uICgpIHtcclxuICAgICAgICAgICAgdGhpcy5lbnRpdGllcyA9IFtdO1xyXG4gICAgICAgICAgICB0aGlzLnZpZXdwb3J0ID0gZG9jdW1lbnQuYm9keTtcclxuXHJcbiAgICAgICAgICAgIHRoaXMuaW5wdXQgPSBuZXcgSW5wdXQoKTtcclxuXHJcbiAgICAgICAgICAgIHRoaXMuZGVidWcgPSBuZXcgRGVidWcoKTtcclxuICAgICAgICAgICAgdGhpcy5kZWJ1Zy5pbml0aWFsaXplKHRoaXMudmlld3BvcnQpO1xyXG5cclxuICAgICAgICAgICAgdGhpcy5zY3JlZW4gPSBuZXcgU2NyZWVuKCk7XHJcbiAgICAgICAgICAgIHRoaXMuc2NyZWVuLmluaXRpYWxpemUodGhpcy52aWV3cG9ydCk7XHJcbiAgICAgICAgICAgIHRoaXMuc2NyZWVuLnNldFdvcmxkKG5ldyBXb3JsZCgpKTtcclxuICAgICAgICB9O1xyXG5cclxuICAgICAgICBHYW1lLnVwZGF0ZSA9IGZ1bmN0aW9uICh0aWNrKSB7XHJcbiAgICAgICAgICAgIEdhbWUudGljayA9IHRpY2s7XHJcbiAgICAgICAgICAgIHRoaXMuaW5wdXQudXBkYXRlKCk7XHJcbiAgICAgICAgICAgIHRoaXMuZGVidWcudXBkYXRlKCk7XHJcbiAgICAgICAgICAgIHRoaXMuc2NyZWVuLnVwZGF0ZSgpO1xyXG4gICAgICAgIH07XHJcblxyXG4gICAgICAgIEdhbWUuZHJhdyA9IGZ1bmN0aW9uICgpIHtcclxuICAgICAgICAgICAgdGhpcy5kZWJ1Zy5kcmF3KCk7XHJcbiAgICAgICAgICAgIHRoaXMuc2NyZWVuLmNsZWFyKCk7XHJcbiAgICAgICAgICAgIHRoaXMuc2NyZWVuLmRyYXcoKTtcclxuICAgICAgICB9O1xyXG5cclxuICAgICAgICBHYW1lLnBhdXNlID0gZnVuY3Rpb24gKCkge1xyXG4gICAgICAgICAgICB0aGlzLnBhdXNlZCA9ICh0aGlzLnBhdXNlZCkgPyBmYWxzZSA6IHRydWU7XHJcbiAgICAgICAgfTtcclxuXHJcbiAgICAgICAgR2FtZS5jbGVhciA9IGZ1bmN0aW9uICgpIHtcclxuICAgICAgICAgICAgY3R4LmNsZWFyUmVjdCgwLCAwLCBjLndpZHRoLCBjLmhlaWdodCk7XHJcbiAgICAgICAgfVxyXG4gICAgICAgIC8qXHJcbiAgICAgICAgICogUnVucyB0aGUgYWN0dWFsIGxvb3AgaW5zaWRlIGJyb3dzZXJcclxuICAgICAgICAgKi9cclxuICAgICAgICBHYW1lLnJ1biA9IChmdW5jdGlvbiAoKSB7XHJcbiAgICAgICAgICAgIHZhciBsb29wcyA9IDA7XHJcbiAgICAgICAgICAgIHZhciBuZXh0R2FtZVRpY2sgPSAobmV3IERhdGUpLmdldFRpbWUoKTtcclxuICAgICAgICAgICAgdmFyIHN0YXJ0VGltZSA9IChuZXcgRGF0ZSkuZ2V0VGltZSgpO1xyXG4gICAgICAgICAgICByZXR1cm4gZnVuY3Rpb24gKCkge1xyXG4gICAgICAgICAgICAgICAgbG9vcHMgPSAwO1xyXG4gICAgICAgICAgICAgICAgd2hpbGUgKCFHYW1lLnBhdXNlZCAmJiAobmV3IERhdGUpLmdldFRpbWUoKSA+IG5leHRHYW1lVGljayAmJiBsb29wcyA8IEdhbWUubWF4RnJhbWVTa2lwKSB7XHJcbiAgICAgICAgICAgICAgICAgICAgR2FtZS51cGRhdGUobmV4dEdhbWVUaWNrIC0gc3RhcnRUaW1lKTtcclxuICAgICAgICAgICAgICAgICAgICBuZXh0R2FtZVRpY2sgKz0gR2FtZS5za2lwVGlja3M7XHJcbiAgICAgICAgICAgICAgICAgICAgbG9vcHMrKztcclxuICAgICAgICAgICAgICAgIH1cclxuICAgICAgICAgICAgICAgIEdhbWUuZHJhdygpO1xyXG4gICAgICAgICAgICB9O1xyXG4gICAgICAgIH0pKCk7XHJcblxyXG4gICAgICAgIChmdW5jdGlvbiAoKSB7XHJcbiAgICAgICAgICAgIHZhciBvbkVhY2hGcmFtZTtcclxuICAgICAgICAgICAgaWYgKHdpbmRvdy53ZWJraXRSZXF1ZXN0QW5pbWF0aW9uRnJhbWUpIHtcclxuICAgICAgICAgICAgICAgIG9uRWFjaEZyYW1lID0gZnVuY3Rpb24gKGNiKSB7XHJcbiAgICAgICAgICAgICAgICAgICAgdmFyIF9jYiA9IGZ1bmN0aW9uICgpIHtcclxuICAgICAgICAgICAgICAgICAgICAgICAgY2IoKTtcclxuICAgICAgICAgICAgICAgICAgICAgICAgd2Via2l0UmVxdWVzdEFuaW1hdGlvbkZyYW1lKF9jYik7XHJcbiAgICAgICAgICAgICAgICAgICAgfTtcclxuICAgICAgICAgICAgICAgICAgICBfY2IoKTtcclxuICAgICAgICAgICAgICAgIH07XHJcbiAgICAgICAgICAgIH0gZWxzZSBpZiAod2luZG93Lm1velJlcXVlc3RBbmltYXRpb25GcmFtZSkge1xyXG4gICAgICAgICAgICAgICAgb25FYWNoRnJhbWUgPSBmdW5jdGlvbiAoY2IpIHtcclxuICAgICAgICAgICAgICAgICAgICB2YXIgX2NiID0gZnVuY3Rpb24gKCkge1xyXG4gICAgICAgICAgICAgICAgICAgICAgICBjYigpO1xyXG4gICAgICAgICAgICAgICAgICAgICAgICBtb3pSZXF1ZXN0QW5pbWF0aW9uRnJhbWUoX2NiKTtcclxuICAgICAgICAgICAgICAgICAgICB9O1xyXG4gICAgICAgICAgICAgICAgICAgIF9jYigpO1xyXG4gICAgICAgICAgICAgICAgfTtcclxuICAgICAgICAgICAgfSBlbHNlIHtcclxuICAgICAgICAgICAgICAgIG9uRWFjaEZyYW1lID0gZnVuY3Rpb24gKGNiKSB7XHJcbiAgICAgICAgICAgICAgICAgICAgc2V0SW50ZXJ2YWwoY2IsIEdhbWUuc2tpcFRpY2tzKTtcclxuICAgICAgICAgICAgICAgIH07XHJcbiAgICAgICAgICAgIH1cclxuXHJcbiAgICAgICAgICAgIHdpbmRvdy5vbkVhY2hGcmFtZSA9IG9uRWFjaEZyYW1lO1xyXG4gICAgICAgIH0pKCk7XHJcblxyXG5cclxuXHJcblxyXG5cclxuXHJcblxyXG5cclxuXHJcblxyXG4gICAgfV0pOyIsImFuZ3VsYXIubW9kdWxlKCdTbGljRGlyZWN0aXZlcycsIFtdKTtcclxuXHJcbi8vcmVxdWlyZSgnLi9kaXJlY3RpdmVzL2J1dHRvbi5qcycpOyIsImFuZ3VsYXIubW9kdWxlKCdTbGljRmFjdG9yaWVzJywgW10pO1xyXG5cclxuLy9yZXF1aXJlKCcuL2ZhY3Rvcmllcy9mYWN0b3JpZXMuanMnKTsiLCJhbmd1bGFyLm1vZHVsZSgnU2xpY0ZpbHRlcnMnLCBbXSk7XHJcblxyXG4vL3JlcXVpcmUoJy4vZmlsdGVycy9maWxlLmpzJyk7Il19
;
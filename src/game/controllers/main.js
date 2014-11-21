angular.module('SlicControllers')
    .controller('MainController', ['$scope', '$filter', function($scope, $filter) {

        //globals 
        var MyGame = {};
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
        function loop() {
            clear();
            drawMyName();
            update();
            render();
            queue();
        }

        function clear() {
            ctx.clearRect(0, 0, c.width, c.height);
        }

        function update() {
            addNewParticles();
            plotParticles(c.width, c.height);
        }

        function render() {
            drawParticles();
            fields.forEach(drawCircle);
            emitters.forEach(drawCircle);
        }

        function queue() {
            window.requestAnimationFrame(loop);
        }

        loop();

        //clear canvas
        function clear() {
            ctx.clearRect(0, 0, c.width, c.height);
        }

    }]);
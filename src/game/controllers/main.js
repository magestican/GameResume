angular.module('Controllers')
    .controller('MainController', ['$scope', '$filter', 'Particle', 'ParticleSvc', 'Emitter', 'Field', 'EmitterSvc', 'DeviceSvc', 'CursorSvc', function ($scope, $filter, Particle, ParticleSvc, Emitter, Field, EmitterSvc, DeviceSvc, CursorSvc) {

        //globals 
        var Game = window.Game = {};
        var ctx = DeviceSvc.ctx;
        var c = DeviceSvc.canvas;
        Game.fps = 60;
        Game.maxFrameSkip = 10;
        Game.skipTicks = 1000 / Game.fps;
        Game.width = c.width;
        Game.height = c.height;

        var objectSize = 3; // drawSize of emitter/field
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


        EmitterSvc.emitters = [
          new Emitter(new Vector(midX - 150, midY), Vector.fromAngle(6, 2))
        ];

        ParticleSvc.fields.push(new Field(new Vector(midX - 100, midY + 20), 150))
        ParticleSvc.fields.push(new Field(new Vector(midX - 300, midY + 20), 100))
        ParticleSvc.fields.push(new Field(new Vector(midX - 200, midY - 40), -20))
        ParticleSvc.fields.push(new Field(new Vector(midX, midY + 20), -20))

        function drawMyName() {
            DeviceSvc.ctx.fillStyle = "rgb(0,0,0)";

            ctx.font = "30pt serif";
            ctx.fillText("Bryan Arbelo", midX + 150, midY);
            ctx.font = "10pt serif";
            ctx.fillText("Hope you like my angular.js + game engine on coffee script", midX + 150, midY + 100);
            ctx.fillText("and the use of google's free hosting and dropbox's storage :)", midX + 150, midY + 114);

        }

        //THERE IS NO WHILE!!
        //clear canvas
        function clear() {
            ctx.clearRect(0, 0, c.width, c.height);
        }

        Game.pause = function () {
            this.paused = (this.paused) ? false : true;
        };

        Game.clear = function () {
            ctx.clearRect(0, 0, c.width, c.height);
        }
        /*
         * Runs the actual loop inside browser
         */

        function loop() {
            clear();
            update();
            draw();
            queue();
        }

        function clear() {
            ctx.clearRect(0, 0, c.width, c.height);

        }

        function update() {
            ParticleSvc.AddNewParticles();
            ParticleSvc.PlotParticles(c.width, c.height);

        }

        function draw() {
            clear();
            ParticleSvc.DrawParticles();
            ParticleSvc.fields.forEach(drawCircle);
            EmitterSvc.emitters.forEach(drawCircle);
            drawMyName();
            CursorSvc.draw();
        }

        function queue() {
            CursorSvc.update();
            window.requestAnimationFrame(loop);
        }

        loop();

    }]);
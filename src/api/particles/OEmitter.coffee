angular.module('Factories')
    .factory('Emitter', ['$rootScope', '$q','Particle', 
    ($rootScope, $q,Particle) ->
        class Emitter 
            # possible angles = velocity +/- 
            constructor : (@position, @velocity, @spread = ( Math.PI / 32)) ->
                @.drawColor = "#999" # So we can tell them apart from Fields later

            emitParticle : () ->
                # Use an angle randomized over the spread so we have more of a "spray"
                angle = this.velocity.getAngle() + this.spread - (Math.random() * this.spread * 2)
                magnitude = this.velocity.getMagnitude()
                position = new Vector(this.position.x, this.position.y)
                velocity = Vector.fromAngle(angle, magnitude)
                # return our new Particle!
                p = new Particle(position, velocity)
                p
        
])

angular.module('Services')
    .service('EmitterSvc', ['$rootScope', '$q','Particle', 
    ($rootScope, $q) ->
        emitters = this.emitters = [];
])
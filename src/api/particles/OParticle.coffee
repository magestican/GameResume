angular.module('Factories')
    .factory('Particle', ['$rootScope', '$q', 
($rootScope, $q) ->

    Particle = (point, velocity, acceleration) ->
        this.position = point || new Vector(0, 0)
        this.velocity = velocity || new Vector(0, 0)
        this.acceleration = acceleration || new Vector(0, 0)
        undefined
    Particle.prototype.move = () ->
        this.velocity.add(this.acceleration) # Vector
        this.position.add(this.velocity) # Vector

    Particle.prototype.submitToFields =  (fields) ->
        # our starting acceleration this frame
        totalAccelerationX = 0
        totalAccelerationY = 0
        
        # for each passed field
        for field in fields
            # find the distance between the particle and the field
            vectorX = field.position.x - this.position.x
            vectorY = field.position.y - this.position.y

            # calculate the force via MAGIC and HIGH SCHOOL SCIENCE!
            force = field.mass / Math.pow(vectorX * vectorX + vectorY * vectorY, 1.5)

            # add to the total acceleration the force adjusted by distance
            totalAccelerationX += vectorX * force
            totalAccelerationY += vectorY * force
        
            # update our particle's acceleration
            this.acceleration = new Vector(totalAccelerationX, totalAccelerationY)
    
    Particle
])
    
#SINGLETON
angular.module('Services')
  .service('ParticleSvc', ['$q', '$rootScope', '$location', 'EmitterSvc','DeviceSvc',
  ($q, $rootScope, $location,EmitterSvc,DeviceSvc) ->
      particles = this.particles = []
      fields = this.fields = []
      particleSize = this.particleSize = 1
      maxParticles = this.maxParticles = 4000;
      emissionRate = this.emissionRate = 4; # how many particles are emitted each frame
      this.DrawParticles = () ->
          # Set the color of our particles
          col1 = Math.floor(Math.random() * 255) + 0
          col2 = Math.floor(Math.random() * 255) + 0
          col3 = Math.floor(Math.random() * 255) + 0
          DeviceSvc.ctx.fillStyle = "rgb(" + col1.toString() + ',' + col2.toString() + ',' + col3.toString() + ')'
          # For each particle
          for particle in particles
              position = particle.position
              # Draw a square at our position [particleSize] wide and tall
              DeviceSvc.ctx.fillRect(position.x, position.y, @particleSize, @particleSize)
         
      this.PlotParticles = (boundsX, boundsY) ->
          # a new array to hold particles within our bounds
          currentParticles = []

          for particle in particles
              pos = particle.position
              # If we're out of bounds, drop this particle and move on to the next
              
              if pos.x < 0 or pos.x > boundsX or pos.y < 0 or pos.y > boundsY 
                continue
               
                
              particle.submitToFields(fields);
              # Move our particles
              particle.move()
              # Add this particle to the list of current particles
              currentParticles.push(particle)
          # Update our global particles, clearing room for old particles to be collected
          particles = currentParticles

       this.AddNewParticles = () ->
          # if we're at our max, stop emitting.
          if particles.length > maxParticles
            return

          # for each emitter
          for emitter in EmitterSvc.emitters
              # for [emissionRate], emit a particle
              for j in [0..emissionRate]
                  try
                    particles.push(emitter.emitParticle())
                  catch error 
                    debugger
                  
        undefined
])


angular.module('Services')
    .service('DeviceSvc', ['$rootScope', '$q','Particle', 
    ($rootScope, $q,Particle) ->
    
      this.canvas = document.getElementById("myCanvas");
      this.ctx = this.canvas.getContext("2d");
      undefined
])

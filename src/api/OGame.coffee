#methods about the game
angular.module('Services')
    .service('GameSvc', ['$rootScope', '$q','Particle',
    ($rootScope, $q,Particle) ->
        class Game 
            this.debug = true
            
        new Game()
])


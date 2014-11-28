(function() {
  angular.module('Services').service('GameSvc', [
    '$rootScope', '$q', 'Particle', function($rootScope, $q, Particle) {
      var Game;
      Game = (function() {
        function Game() {}

        Game.debug = true;

        return Game;

      })();
      return new Game();
    }
  ]);

}).call(this);

//# sourceMappingURL=OGame.js.map

(function() {
  angular.module('Services').service('DeviceSvc', [
    '$rootScope', '$q', 'Particle', function($rootScope, $q, Particle) {
      this.canvas = document.getElementById("myCanvas");
      this.ctx = this.canvas.getContext("2d");
      return void 0;
    }
  ]);

}).call(this);

//# sourceMappingURL=ODevice.js.map

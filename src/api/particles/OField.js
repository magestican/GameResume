(function() {
  angular.module('Factories').factory('Field', [
    '$rootScope', '$q', 'Particle', function($rootScope, $q) {
      var Field;
      Field = (function() {
        function Field(point, mass) {
          this.position = point;
          this.setMass(mass);
        }

        Field.prototype.setMass = function(mass) {
          this.mass = mass != null ? mass : 100;
          this.drawColor = this.mass < 0 ? "#f00" : "#0f0";
          return Field;
        };

        return Field;

      })();
      return Field;
    }
  ]);

}).call(this);

//# sourceMappingURL=OField.js.map

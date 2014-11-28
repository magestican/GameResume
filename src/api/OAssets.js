(function() {
  angular.module('Services').service('AssetsSvc', [
    '$rootScope', '$q', 'Particle', 'GameSvc', function($rootScope, $q, Particle, GameSvc) {
      var AssetHelper;
      AssetHelper = (function() {
        var url;

        url = "https://localhost/";

        AssetHelper.prototype.loadResource = function(resourceName) {
          var image;
          image = new Image();
          image.src = url + resourceName;
          image.onError = function() {
            return console.log("Error loading this image");
          };
          return image;
        };

        function AssetHelper() {
          this.cursor = this.loadResource("img/radix_phantasma_normal_select.png");
        }

        return AssetHelper;

      })();
      return new AssetHelper();
    }
  ]);

}).call(this);

//# sourceMappingURL=OAssets.js.map

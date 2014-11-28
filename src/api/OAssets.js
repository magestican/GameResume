(function() {
  angular.module('Services').service('AssetsSvc', [
    '$rootScope', '$q', 'Particle', 'GameSvc', function($rootScope, $q, Particle, GameSvc) {
      var AssetHelper;
      AssetHelper = (function() {
        var loader, url;

        url = "https://localhost/";

        loader = new ZipLoader('https://drive.google.com/file/d/0B3hHpZXWdStbQ21kYlVVR0tEZUE/view?usp=sharing');

        AssetHelper.prototype.loadResource = function(resourceName) {
          var image;
          image = new Image();
          if (GameSvc.debug) {
            image.src = url + resourceName;
          } else {
            image.src = loader.loadImage('assets.zip://img/logo.png');
          }
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

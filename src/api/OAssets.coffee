#methods to load assets
angular.module('Services')
    .service('AssetsSvc', ['$rootScope', '$q','Particle','GameSvc',
    ($rootScope, $q,Particle, GameSvc) ->
        class AssetHelper 
            url = "https://localhost/"
            # returns the base64 encoded image usable as img source
            loadResource : (resourceName) ->
                image = new Image();
                image.src = url + resourceName;
                    
                image.onError = () ->
                    console.log("Error loading this image");
                return image    
            # possible angles = velocity +/- 
            constructor : () ->
                this.cursor = this.loadResource("img/radix_phantasma_normal_select.png")
            
        new AssetHelper()
])

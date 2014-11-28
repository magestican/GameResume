#methods to load assets
angular.module('Services')
    .service('AssetsSvc', ['$rootScope', '$q','Particle','GameSvc',
    ($rootScope, $q,Particle, GameSvc) ->
        class AssetHelper 
            url = "https://localhost/"
            loader = new ZipLoader('https://drive.google.com/file/d/0B3hHpZXWdStbQ21kYlVVR0tEZUE/view?usp=sharing')
            # returns the base64 encoded image usable as img source
            loadResource : (resourceName) ->
                image = new Image();
                if GameSvc.debug
                    image.src = url + resourceName;
                else
                    image.src = loader.loadImage('assets.zip://img/logo.png')
                    
                image.onError = () ->
                    console.log("Error loading this image");
                return image    
            # possible angles = velocity +/- 
            constructor : () ->
                this.cursor = this.loadResource("img/radix_phantasma_normal_select.png")
            
        new AssetHelper()
])

angular.module('Services')
    .service('CursorSvc', ['$rootScope', '$q','Particle', 'AssetsSvc','DeviceSvc',
    ($rootScope, $q,Particle, AssetsSvc,DeviceSvc) ->
        class Cursor
            constructor : () ->
            
            x = 0
            y = 0
            this.colorR = 255
            this.colorG = 255
            this.colorB = 0
            this.event = {}
            window.onmousemove = (event) ->
                      Cursor.event = event;
          
            update : () ->
                if (!Cursor.event.clientX)
                    return
                    
                rect = DeviceSvc.canvas.getBoundingClientRect();
                x = Math.round( Cursor.event.clientX - rect.left /(rect.right - rect.left) * DeviceSvc.canvas.width) - 5
                y = Math.round( Cursor.event.clientY - rect.top /(rect.bottom - rect.top) * DeviceSvc.canvas.width) - 5
       
            draw :  () ->
                DeviceSvc.ctx.drawImage(AssetsSvc.cursor, x, y)
            
        new Cursor()
])


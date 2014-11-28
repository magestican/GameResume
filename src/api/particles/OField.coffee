angular.module('Factories')
    .factory('Field', ['$rootScope', '$q','Particle', 
($rootScope, $q) ->
    #emiter or repeller field
    class Field 
        constructor: (point, mass) ->
            @position = point;
            @setMass(mass);
        setMass : (@mass = 100) ->
            this.drawColor = if @mass < 0 then "#f00" else "#0f0";
            Field
    Field
])
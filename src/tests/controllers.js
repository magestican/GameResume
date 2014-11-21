describe('Controllers', function() {

    beforeEach(module('Slic'));

    ////////////////////////////////////////////////////////////
    // Application
    ////////////////////////////////////////////////////////////

    describe('Application', function() {

        var scope, controller;

        beforeEach(inject(function($rootScope, $compile, $controller) {
            
            if (scope === undefined) {
                
                scope       = $rootScope.$new();
                controller  = $controller('ApplicationController', { $scope: scope });

            }

        }));

        it('has a model', function() {

            expect(scope.model).not.toBeNull();

        });

    });

});
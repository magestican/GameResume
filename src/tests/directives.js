describe('Directives', function() {

    beforeEach(module('Slic'));

    ////////////////////////////////////////////////////////////
    // Dropdown
    ////////////////////////////////////////////////////////////

    describe('Dropdown', function() {

        var scope, directive;

        beforeEach(inject(function($rootScope, $controller, $compile) {
            
            var html;

            if (scope === undefined) {

                html = [
                    '<li class="header-action dropdown">',
                        '<a href="#" class="dropdown-trigger">Dropdown Trigger</a>',
                        '<ul data-dropdown-menu="true">',
                            '<li><a href="#" ng-click="testMethod()">Dropdown Menu Item</a></li>',
                        '</ul>',
                    '</li>'
                ].join('');

                scope       = $rootScope.$new();
                directive   = $compile(html)(scope);

            }

            jasmine.Clock.useMock();

        }));

        it('has a dropdown object in the scope', function() {

            expect(directive.scope().dropdown).not.toBeNull();

        });

        it('shows the menu when the trigger is clicked', function() {

            directive.find('.dropdown-trigger').trigger('click');

            expect(directive.scope().dropdown.show).toBe(true);

        });

        it('hides the menu when an anchor is clicked', function() {

            directive.find('a[href="#"]').first().trigger('click');

            jasmine.Clock.tick(100);

            expect(directive.scope().dropdown.show).toBe(false);

        });

        it('hides the menu when the mouse leaves the menu', function() {

            directive.find('.dropdown-trigger').first().trigger('click');
            directive.trigger('mouseleave');

            jasmine.Clock.tick(300);

            expect(directive.scope().dropdown.show).toBe(false);

        });

        it('allows methods in the scope to be called', function() {

            scope.testMethod = jasmine.createSpy('testMethod'); 

            directive.find('a[href="#"]').trigger('click'); 

            expect(scope.testMethod).toHaveBeenCalled();

        });

    });

});
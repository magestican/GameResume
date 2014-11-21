angular.module('SlicDirectives')

    .directive('btn', ['$timeout', function($timeout) {
        return {
            restrict: 'C',
            link: function(scope, element, attrs) {
                var tooltipTimer;
                element.on('mouseenter', function() {
                    tooltipTimer = $timeout(function() {
                        element.addClass('tooltip-show');
                        $timeout(function() {
                            element.addClass('tooltip-animate');
                        }, 50);
                    }, 200);
                });
                element.on('mouseleave', function() {
                    $timeout.cancel(tooltipTimer);
                    element.removeClass('tooltip-show tooltip-animate');
                });
            }
        }
    }])

    .directive('tooltip', function() {
        return {
            restrict: 'A',
            replace: true,
            transclude: true,
            templateUrl: 'tooltip.html',
            link: function(scope, element, attrs) {

            }
        };
    });
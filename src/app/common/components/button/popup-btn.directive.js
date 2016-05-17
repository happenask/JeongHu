(function() {
    'use strict';

    angular
        .module('common.components')
        .directive('popupBtn', popupBtn);

    /* @ngInject */
    function popupBtn($window) {
        // Usage:
        //
        // Creates:
        //
        var directive = {
            restrict: 'AE',
            transclude: true,
            template: "<button popup='url' callback='callback' dimensions='width=500,height=300' ng-class='{{btn}}' ng-transclude></button>",
            scope: {
                popup: "=",
                dimensions: "@",
                callback: "=",
                class: '@',
                btn: '@',
                label: '@'
            },
            link: link
        };
        return directive;

        function link($scope, $element) {
            $window.callback = function(data){
                $scope.callback(data);
            };
            $element.on("click", function(e){

                var authwindow = $window.open($scope.popup, "popup", $scope.dimensions);
                authwindow.focus();
            });
        }
    }

})();

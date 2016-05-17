(function() {
    'use strict';

    angular
        .module('common.components')
        .directive('commonFooter', commonMenuDirective);

    /* @ngInject */
    function commonMenuDirective($location) {
        // Usage:
        //
        // Creates:
        //
        var directive = {
            restrict: 'E',
            templateUrl: 'app/common/components/footer/footer.tmpl.html',
            scope: {},
            controller: 'FooterController',
            controllerAs: 'MenuCtrl',
            link: link
        };
        return directive;

        function link($scope, $element) {

        }
    }

})();

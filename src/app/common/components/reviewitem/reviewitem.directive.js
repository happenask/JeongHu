(function() {
    'use strict';

    angular
        .module('common.components')
        .directive('reviewItem', reviewItem);

    /* @ngInject */
    function reviewItem($location) {
        // Usage:
        //
        // Creates:
        //
        var directive = {
            restrict: 'E',
            templateUrl: '/app/common/components/reviewitem/review-item.tmpl.html',
            replace: true,
            scope: '=',
            link: link
        };
        return directive;

        function link($scope, $element) {
            //$mdTheming($element);
            //var $mdTheme = $element.controller('mdTheme'); //eslint-disable-line
            //
            //var menuColor = triTheming.getThemeHue($mdTheme.$mdTheme, 'primary', 'default');
            //var menuColorRGBA = triTheming.rgba(menuColor.value);
            //$element.css({ 'background-color': menuColorRGBA });
            //$element.children('md-content').css({ 'background-color': menuColorRGBA });
        }
    }
})();

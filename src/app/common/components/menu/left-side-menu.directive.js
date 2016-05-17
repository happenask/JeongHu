(function() {
    'use strict';

    angular
        .module('common.components')
        .directive('leftSideMenu', leftSideMenu);

    /* @ngInject */
    function leftSideMenu($location) {
        // Usage:
        //
        // Creates:
        //
        var directive = {
            restrict: 'E',
            template: '<ul class="list-group sidebar-nav-v1 margin-bottom-40">' +
            '<li class="list-group-item no-border-radius sideBarTab {{item.active}}" ng-repeat="item in leftSideMenuController.menu | orderBy:\'priority\'">' +
            '<a href="{{item.href}}"><i class="fa {{item.icon}}"></i> {{item.name | translate}}</a>' +
            '</li></ul>',
            scope: {},
            controller: leftSideMenuController,
            controllerAs: 'leftSideMenuController',
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

    /* @ngInject */
    function leftSideMenuController($location, leftSideMenu) {
        var leftSideMenuController = this;
        // get the menu and order it
        leftSideMenuController.menu = leftSideMenu.menu;
    }
})();

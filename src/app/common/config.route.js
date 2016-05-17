(function() {
    'use strict';

    angular
        .module('common')
        .config(routeConfig);

    /* @ngInject */
    function routeConfig($stateProvider) {
        $stateProvider
            .state('common', {
                abstract: true,
                templateUrl: 'app/common/layouts/default/default.tmpl.html',
                controller: 'DefaultLayoutController',
                controllerAs: 'layoutController'
            })
            .state('fullBackground', {
                abstract: true,
                templateUrl: 'app/common/layouts/default/full-background.tmpl.html',
                controller: 'DefaultLayoutController',
                controllerAs: 'layoutController'
            })
            .state('fullBackground.noFooter', {
                abstract: true,
                views: {
                    menu: {
                        templateUrl: 'app/common/components/menu/menu.tmpl.html',
                        controller: 'MenuController',
                        controllerAs: 'vm'
                    },
                    content: {
                        template: '<div ui-view></div>'
                    }
                }
            })
            .state('common.default', {
                abstract: true,
                views: {
                    menu: {
                        templateUrl: 'app/common/components/menu/menu.tmpl.html',
                        controller: 'MenuController',
                        controllerAs: 'vm'
                    },
                    content: {
                        template: '<div ui-view></div>'
                    },
                    footer: {
                        templateUrl: 'app/common/components/footer/footer.tmpl.html',
                        controller: 'FooterController',
                        controllerAs: 'vm'
                    }
                }
            })
            .state('common.leftSideMenu', {
                abstract: true,
                views: {
                    menu: {
                        templateUrl: 'app/common/components/menu/menu.tmpl.html',
                        controller: 'MenuController',
                        controllerAs: 'vm'
                    },
                    leftsidemenu: {
                        templateUrl: 'app/common/components/menu/left-side-menu.tmpl.html',
                        controller: 'LeftSideMenuController',
                        controllerAs: 'vm'
                    },
                    content: {
                        template: '<div ui-view></div>'
                    },
                    footer: {
                        templateUrl: 'app/common/components/footer/footer.tmpl.html',
                        controller: 'FooterController',
                        controllerAs: 'vm'
                    }
                }
            });
    }
})();
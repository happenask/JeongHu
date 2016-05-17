(function() {
    'use strict';

    angular
        .module('app.pages.review')
        .config(moduleConfig);

    /* @ngInject */
    function moduleConfig($translatePartialLoaderProvider, $stateProvider, $urlRouterProvider, commonMenuProvider) {
        $translatePartialLoaderProvider.addPart('app/pages/review');

        $stateProvider
            .state('common.default.review-list', {
                url: '/review/list?:campaign',
                templateUrl: 'app/pages/review/review.tmpl.html',
                controller: 'ReviewlistController',
                controllerAs: 'vm'
            })
            .state('common.default.review-detail', {
                url: '/review/detail?:rid',
                templateUrl: 'app/pages/review/detail.tmpl.html',
                controller: 'ReviewdetailController',
                controllerAs: 'vm',
                resolve: {
                    getReviewRsv: function($stateParams, Restangular) {
                        var api = Restangular.all('reviews/'+ $stateParams.rid + '/');
                        return api.customGET().then();
                    }
                }
            })
            .state('common.leftSideMenu.review_write', {
                url: '/review/write?:id',
                templateUrl: 'app/pages/review/review_write.tmpl.html',
                controller: 'ReviewWriteController',
                controllerAs: 'vm',
                resolve: {
                    getCampaignRsv: function($stateParams, Restangular) {
                        var api = Restangular.all('campaigns/'+ $stateParams.id + '/');
                        return api.customGET().then();
                    }
                }
            });

            $urlRouterProvider.when('/review', '/review/list');
            $urlRouterProvider.when('/review/', '/review/list');
            $urlRouterProvider.when('/review/list/', '/review/list');
    }
})();
(function() {
    'use strict';

    angular
        .module('app.pages.item')
        .config(moduleConfig);

    /* @ngInject */
    function moduleConfig($translatePartialLoaderProvider, $stateProvider, commonMenuProvider) {
        $translatePartialLoaderProvider.addPart('app/pages/item');

        $stateProvider
            // .state('common.default.item-list', {
            //     url: '/review/list',
            //     templateUrl: 'app/pages/review/review.tmpl.html',
            //     controller: 'ReviewlistController',
            //     controllerAs: 'vm'
            // })
            .state('common.default.item-detail', {
                url: '/item/detail?:id',
                templateUrl: 'app/pages/item/detail.tmpl.html',
                controller: 'ItemdetailController',
                controllerAs: 'vm',
                resolve: {
                    getItemRsv: function($stateParams, Restangular) {
                        var api = Restangular.all('campaigns/'+ $stateParams.id + '/');
                        return api.customGET().then();
                    },
                    getReviewRsv: function($stateParams, Restangular) {
                        var api = Restangular.all('campaigns/'+ $stateParams.id + '/reviews/');
                        return api.customGET('', { 'offset' : 0, 'limit' : 3, 'target' : 'all', 'type': 'hot' }).then();
                    }
                }
            });

    }
})();
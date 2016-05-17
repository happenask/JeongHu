(function() {
    'use strict';

    angular
        .module('app.pages.try')
        .config(moduleConfig);

    /* @ngInject */
    function moduleConfig($translatePartialLoaderProvider, $stateProvider, commonMenuProvider) {

        $translatePartialLoaderProvider.addPart('app/pages/try');

        $stateProvider
            .state('common.default.try', {
                url: '/try',
                templateUrl: 'app/pages/try/try.tmpl.html',
                controller: 'TryController',
                controllerAs: 'vm'
            })
            .state('common.default.detail', {
                url: '/try/detail?:id',
                templateUrl: 'app/pages/try/detail.tmpl.html',
                controller: 'DetailController',
                controllerAs: 'vm',
                resolve: {
                    getCampaignRsv: function($stateParams, Restangular) {
                        var api = Restangular.all('campaigns/'+ $stateParams.id + '/');
                        return api.customGET().then();
                    }
                }
             })
            .state('common.default.apply', {
                url: '/try/apply/:id',
                templateUrl: 'app/pages/try/apply.tmpl.html',
                controller: 'ApplyController',
                controllerAs: 'vm',
                resolve: {
                    getCampaignRsv: function($stateParams, Restangular) {
                        var api = Restangular.all('campaigns/'+ $stateParams.id + '/');
                        return api.customGET().then();
                    }
                }
            });

    }
})();
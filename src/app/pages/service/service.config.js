(function() {
    'use strict';

    angular
        .module('app.pages.service')
        .config(moduleConfig);

    /* @ngInject */
    function moduleConfig($translatePartialLoaderProvider, $stateProvider) {

        $translatePartialLoaderProvider.addPart('app/pages/service');

        $stateProvider
            .state('common.default.story', {
                url: '/service/story',
                templateUrl: 'app/pages/service/story.tmpl.html',
                controller: 'StoryController',
                controllerAs: 'vm'
            })
            .state('common.default.review', {
                url: '/service/review',
                templateUrl: 'app/pages/service/review.tmpl.html',
                controller: 'ReviewController',
                controllerAs: 'vm'
            })
            .state('common.default.privacy', {
                url: '/service/privacy',
                templateUrl: 'app/pages/service/privacy.tmpl.html',
                controller: 'PrivacyController',
                controllerAs: 'vm'
            })
            .state('common.default.policy', {
                url: '/service/policy',
                templateUrl: 'app/pages/service/policy.tmpl.html',
                controller: 'PolicyController',
                controllerAs: 'vm'
            })
            .state('common.default.operation', {
                url: '/service/operation',
                templateUrl: 'app/pages/service/operation.tmpl.html',
                controller: 'OperationController',
                controllerAs: 'vm'
            })
            .state('common.default.partner', {
                    url: '/service/partner',
                    templateUrl: 'app/pages/service/partner.tmpl.html',
                    controller: 'PartnerController',
                    controllerAs: 'vm'
            })
            // 인증 팝업 추가 (변동있을수 있음) - Leo
            .state('common.default.cert', {
                url: '/service/certification',
                templateUrl: 'app/pages/service/cert.tmpl.html',
                controller: 'CertController',
                controllerAs: 'vm'
            });

    }
})();
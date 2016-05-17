(function() {
    'use strict';

    angular
        .module('app.pages.help')
        .config(moduleConfig);

    /* @ngInject */
    function moduleConfig($translatePartialLoaderProvider, $stateProvider, commonMenuProvider) {

        $translatePartialLoaderProvider.addPart('app/pages/help');

        $stateProvider
            .state('common.default.howtouser', {
                url: '/help/howtouse',
                templateUrl: 'app/pages/help/how-to-use.tmpl.html',
                controller: 'HowToUseController',
                controllerAs: 'vm'
            })
            .state('common.default.faq', {
                url: '/help/faq',
                templateUrl: 'app/pages/help/faq.tmpl.html',
                controller: 'FaqController',
                controllerAs: 'vm'
            })
            .state('common.default.ask', {
                url: '/help/ask',
                templateUrl: 'app/pages/help/ask.tmpl.html',
                controller: 'AskController',
                controllerAs: 'vm'
            })
            .state('common.default.certification', {
                url: '/help/certificationInfo',
                templateUrl: 'app/pages/help/certification-info.tmpl.html',
                controller: 'CertificationInfoController',
                controllerAs: 'vm'
            });
    }
})();
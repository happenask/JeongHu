(function() {
    'use strict';

    angular
        .module('app.pages.service')
        .controller('PrivacyController', PrivacyController);

    /* @ngInject */
    function PrivacyController($rootScope, commonLayout, $translate, commonSettings) {
        commonLayout.updateLayoutFromType();
        var vm = this;



        vm.il18n = '/app/pages/service/privacy-con-' + $translate.use() + '.tmpl.html';
        $rootScope.$on('changeLanguage', function(){
            vm.il18n = '/app/pages/service/privacy-con-' + $translate.use() + '.tmpl.html';
        })
    }
})();

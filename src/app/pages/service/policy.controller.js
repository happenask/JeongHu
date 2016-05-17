(function() {
    'use strict';

    angular
        .module('app.pages.service')
        .controller('PolicyController', PolicyController);

    /* @ngInject */
    function PolicyController($rootScope, commonLayout, $translate, commonSettings) {
        commonLayout.updateLayoutFromType();
        var vm = this;


        vm.il18n = '/app/pages/service/policy-con-' + $translate.use() + '.tmpl.html';
        $rootScope.$on('changeLanguage', function(){
            vm.il18n = '/app/pages/service/policy-con-' + $translate.use() + '.tmpl.html';
        })


    }
})();

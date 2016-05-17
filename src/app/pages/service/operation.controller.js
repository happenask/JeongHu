(function() {
    'use strict';

    angular
        .module('app.pages.service')
        .controller('OperationController', OperationController);

    /* @ngInject */
    function OperationController($rootScope, commonLayout, $translate, commonSettings) {
        commonLayout.updateLayoutFromType
        var vm = this;

        vm.il18n = '/app/pages/service/operation-con-' + $translate.use() + '.tmpl.html';
        $rootScope.$on('changeLanguage', function(){
            vm.il18n = '/app/pages/service/operation-con-' + $translate.use() + '.tmpl.html';
        })
        
    }
})();

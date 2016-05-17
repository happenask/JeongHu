(function() {
    'use strict';

    angular
        .module('common.components')
        .controller('FooterController', FooterController);

    /* @ngInject */
    function FooterController($rootScope, $translate, commonSettings) {
        var vm = this;
        vm.switchLanguage = switchLanguage;
        vm.languages = commonSettings.languages;

        function switchLanguage(languageCode) {
            $translate.use(languageCode).then(function() {
                $rootScope.$emit('changeTitle');
            });
        }


    }
})();
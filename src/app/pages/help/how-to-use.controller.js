(function() {
    'use strict';

    angular
        .module('app.pages.help')
        .controller('HowToUseController', HowToUseController);

    /* @ngInject */
    function HowToUseController(commonLayout, $timeout) {
        commonLayout.updateLayoutFromType();
        var vm = this;
        


    }
})();

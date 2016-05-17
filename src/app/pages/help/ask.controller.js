(function() {
    'use strict';

    angular
        .module('app.pages.help')
        .controller('AskController', AskController);

    /* @ngInject */
    function AskController(commonLayout) {
        commonLayout.updateLayoutFromType();
        var vm = this;





    }
})();

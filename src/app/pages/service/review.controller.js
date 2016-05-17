(function() {
    'use strict';

    angular
        .module('app.pages.service')
        .controller('ReviewController', ReviewController);

    /* @ngInject */
    function ReviewController(commonLayout) {
        commonLayout.updateLayoutFromType();
        var vm = this;





    }
})();

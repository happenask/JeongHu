(function() {
    'use strict';

    angular
        .module('app.pages.service')
        .controller('StoryController', StoryController);

    /* @ngInject */
    function StoryController(commonLayout) {
        commonLayout.updateLayoutFromType();
        var vm = this;

        
    }
})();

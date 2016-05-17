(function() {
    'use strict';

    angular
        .module('app')
        .config(config);

    /* @ngInject */
    function config(commonLayoutProvider) {
        //commonLayoutProvider.setDefaultOption('toolbarSize', 'default');
        //
        //commonLayoutProvider.setDefaultOption('toolbarShrink', false);
        //
        //commonLayoutProvider.setDefaultOption('toolbarClass', '');
        //
        //commonLayoutProvider.setDefaultOption('contentClass', '');
        //
        //commonLayoutProvider.setDefaultOption('sideMenuSize', 'full');
        //
        //commonLayoutProvider.setDefaultOption('showToolbar', true);
        commonLayoutProvider.setDefaultOption('headMenu', true);
        commonLayoutProvider.setDefaultOption('footer', true);
    }
})();
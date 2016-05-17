(function() {
    'use strict';

    angular
        .module('common', [
            'common.layouts', 'common.components', 'common.router',
            // 'triangular.profiler',
            // uncomment above to activate the speed profiler
            'ui.router'
        ]);
})();
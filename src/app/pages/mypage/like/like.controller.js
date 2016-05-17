(function() {
    'use strict';

    angular
        .module('app.pages.mypage')
        .controller('LikeController', LikeController);

    /* @ngInject */
    function LikeController($rootScope,Restangular,commonLayout, angularGridInstance) {

        commonLayout.updateLayoutFromType('myPage');
        var vm = this;
        var memberId = $rootScope.globals.currentUser.id;


    }
})();

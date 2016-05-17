(function() {
    'use strict';

    angular
        .module('app.pages.mypage')
        .controller('MessageController', MessageController);

    /* @ngInject */
    function MessageController($rootScope, $timeout, $location, commonLayout, Restangular) {
        commonLayout.updateLayoutFromType('myPage');
        var vm = this;

        vm.api = Restangular.all('members/'+ $rootScope.globals.currentUser.id + '/');
        vm.messages = [];

        vm.init = (init)();
        vm.delMsg = delMsg;

        //////////////////////
        function init() {
            vm.param = {
                offset: 0,
                limit: 50
            };
            vm.api.customGET('messages', vm.param).then(function (response) {
                if(response.status.code === '0000') {
                    vm.messages = response.result.messages;
                    $rootScope.globals.currentUser.newMsgCount = 0;
                }
                else {

                }

            });
        }

        function delMsg(item) {
            Restangular.one("messages", item.item.id).remove().then(function (response) {
                if(response.status.code === '0000') {
                    vm.messages.splice(item.$index, 1);
                }
                else {

                }
            });
        }


    }
})();

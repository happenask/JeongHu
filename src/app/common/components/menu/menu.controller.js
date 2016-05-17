(function() {
    'use strict';

    angular
        .module('common.components')
        .controller('MenuController', menuController);

    /* @ngInject */
    function menuController($rootScope, $state, Authentication, $location, Restangular, $timeout, commonSettings, commonLayout) {

        var vm = this;
        if($rootScope.globals && $rootScope.globals.currentUser) {
            vm.messageApi = Restangular.all('members/'+ $rootScope.globals.currentUser.id + '/messages/new');
        }
        vm.sign = {
            email : null,
            passwd : null
        };
        vm.alert = {
            errmsg : null,
            show : false
        };
        //test
        vm.sign = {
            email : "jason@08liter.com",
            passwd : "123456"
        };
        vm.doSignIn = doSignIn;
        vm.toggleDropdown = toggleDropdown;
        vm.goSignIn = goSignIn;



        ////////////
        function doSignIn() {
            Authentication.clearCredentials();
            Authentication.signIn.post(vm.sign).then(function(user) {
                if(user.status.code === "0000") {
                    Authentication.setCredentials(user.result.member, 'reload');
                    vm.alert.errmsg = "";
                    vm.alert.show = "off";
                }
                else {
                    vm.alert.errmsg = "사용자 정보가 맞지 않습니다.";
                    vm.alert.show = "on";
                }
            });
        }

        function toggleDropdown(target) {
            if(target === 'logout') {
                Authentication.clearCredentials('reload');
            }
            else if(target === 'messages') {
                if($rootScope.globals.sign) {
                    vm.messageApi.getList().then(function (response) {
                        if(response.status.code === '0000') {
                            vm.messages = response.result.messages;
                        }
                        else {

                        }
                    });
                }
            }
            else if(target === 'needSign') {
                if(!$rootScope.globals.sign) {
                    $('#myModal').modal('show');
                }
            }
            else if(target === 'login') {
                $state.go('fullBackground.noFooter.signin');
            }
        }

        function goSignIn() {
            $('#your-modal-id').modal('hide');
            $('body').removeClass('modal-open');
            $('.modal-backdrop').remove();
            $location.path('/signin');
        }

        $timeout(function() {
            $(document).ready(function () {
                $(".sticky").sticky({topSpacing: 0});
            });
        });

    }
})();
